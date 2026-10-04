import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';

import '../local/app_database.dart';
import '../local/tables/attempt_subtes_table.dart';
import 'pack_validator.dart';

enum ImportStatus { success, skippedVersion, invalid, failed }

/// Hasil eksekusi impor paket soal ke database Drift.
class ImportResult {
  final ImportStatus status;
  final String packId;
  final int packVersion;
  final String message;
  final List<String> errors;
  final List<String> warnings;
  final List<String> skippedSubtests;

  const ImportResult({
    required this.status,
    this.packId = '',
    this.packVersion = 0,
    this.message = '',
    this.errors = const [],
    this.warnings = const [],
    this.skippedSubtests = const [],
  });

  bool get isSuccess => status == ImportStatus.success;
  bool get isSkipped => status == ImportStatus.skippedVersion;
}

class PackImportException implements Exception {
  final String message;
  PackImportException(this.message);

  @override
  String toString() => 'PackImportException: $message';
}

/// Layanan untuk mengimpor paket soal JSON ke dalam database Drift secara transaksional.
class PackImporter {
  final AppDatabase _db;
  final PackValidator _validator;

  PackImporter(this._db, {PackValidator? validator})
    : _validator = validator ?? PackValidator();

  /// Batas ukuran maksimal string paket JSON (5 MB).
  static const int defaultMaxSizeBytes = 5 * 1024 * 1024;

  static Map<String, dynamic> _decodeJsonIsolate(String input) {
    return json.decode(input) as Map<String, dynamic>;
  }

  /// Flag kontrol penggunaan isolate compute (dapat dinonaktifkan di testWidgets)
  static bool useCompute = true;

  /// Membaca string JSON (dengan validasi ukuran dan parsing di background thread)
  /// lalu mengimpornya ke database.
  Future<ImportResult> importJsonString(
    String jsonString, {
    bool force = false,
    int maxSizeBytes = defaultMaxSizeBytes,
  }) async {
    final byteLength = utf8.encode(jsonString).length;
    if (byteLength > maxSizeBytes) {
      return ImportResult(
        status: ImportStatus.failed,
        message:
            'Ukuran file paket (${(byteLength / (1024 * 1024)).toStringAsFixed(2)} MB) melebihi batas 5 MB.',
      );
    }

    try {
      final jsonMap = (useCompute && jsonString.length > 50 * 1024)
          ? await compute(_decodeJsonIsolate, jsonString)
          : json.decode(jsonString) as Map<String, dynamic>;
      return await importPack(jsonMap, force: force);
    } catch (e) {
      return ImportResult(
        status: ImportStatus.failed,
        message: 'Gagal mem-parsing format JSON: $e',
      );
    }
  }

  /// Mengimpor paket JSON yang sudah ter-decode secara transaksional ke database Drift.
  Future<ImportResult> importPack(
    Map<String, dynamic> json, {
    bool force = false,
  }) async {
    // 1. Validasi struktur paket
    final validation = _validator.validate(json);
    if (!validation.isValid) {
      return ImportResult(
        status: ImportStatus.invalid,
        errors: validation.errors,
        warnings: validation.warnings,
        message: 'Paket tidak valid dan dibatalkan.',
      );
    }

    final packId = json['packId'].toString();
    final packVersion = json['packVersion'] as int;
    final packNama = json['nama'].toString();

    // 2. Cek apakah versi yang terpasang sudah ada
    final existingInstalled = await (_db.select(
      _db.paketTerpasang,
    )..where((tbl) => tbl.packId.equals(packId))).getSingleOrNull();

    if (existingInstalled != null &&
        packVersion <= existingInstalled.packVersion &&
        !force) {
      return ImportResult(
        status: ImportStatus.skippedVersion,
        packId: packId,
        packVersion: packVersion,
        warnings: validation.warnings,
        message:
            'Versi paket ($packVersion) tidak lebih baru dari yang terpasang (${existingInstalled.packVersion}). Impor dilewati.',
      );
    }

    final List<String> skippedSubtests = [];

    // 3. Seluruh impor dijalankan dalam SATU transaksi atomik
    await _db.transaction(() async {
      // Kumpulkan ID semua subtes dalam paket baru
      final tesList = json['tes'] as List;
      final Set<String> newSubtestIds = {};
      final Set<String> newSoalIds = {};

      for (final t in tesList) {
        final subtesList = t['subtes'] as List;
        for (final s in subtesList) {
          final subId = s['id'].toString();
          newSubtestIds.add(subId);
          final soalList = s['soal'] as List;
          for (final q in soalList) {
            newSoalIds.add(q['id'].toString());
          }
        }
      }

      // Ambil attempt dari subtes-subtes tersebut untuk mendeteksi yang sedang berjalan
      final attempts = await (_db.select(
        _db.attemptSubtes,
      )..where((tbl) => tbl.subtesId.isIn(newSubtestIds))).get();

      final Set<String> runningSubtestIds = {};
      for (final att in attempts) {
        if (att.status == SubtesStatus.berjalan) {
          runningSubtestIds.add(att.subtesId);
        }
      }

      // A. Upsert Kategori
      final kategoriObj = json['kategori'] as Map<String, dynamic>;
      final katId = kategoriObj['id'].toString();
      final katNama = kategoriObj['nama'].toString();

      await _db
          .into(_db.kategori)
          .insertOnConflictUpdate(
            KategoriCompanion.insert(id: katId, nama: katNama, urutan: 1),
          );

      // B. Upsert Tes, Subtes, Stimulus, dan Soal
      for (int tIdx = 0; tIdx < tesList.length; tIdx++) {
        final t = tesList[tIdx] as Map<String, dynamic>;
        final tesId = t['id'].toString();
        final tesNama = t['nama'].toString();

        await _db
            .into(_db.tes)
            .insertOnConflictUpdate(
              TesCompanion.insert(
                id: tesId,
                kategoriId: katId,
                nama: tesNama,
                urutan: tIdx + 1,
                packId: packId,
              ),
            );

        final subtesList = t['subtes'] as List;
        for (int sIdx = 0; sIdx < subtesList.length; sIdx++) {
          final s = subtesList[sIdx] as Map<String, dynamic>;
          final subId = s['id'].toString();
          final subNama = s['nama'].toString();
          final durasiMenit = s['durasiMenit'] as int;

          // Jika subtes sedang berjalan: jangan diubah, lewati dan laporkan!
          if (runningSubtestIds.contains(subId)) {
            skippedSubtests.add(
              'Subtes "$subNama" ($subId) sedang dikerjakan dan tidak diubah.',
            );
            continue;
          }

          // Subtes berstatus selesai diperbolehkan memperbarui konten tanpa mengubah snapshot skor
          await _db
              .into(_db.subtes)
              .insertOnConflictUpdate(
                SubtesCompanion.insert(
                  id: subId,
                  tesId: tesId,
                  nama: subNama,
                  durasiMenit: durasiMenit,
                  urutan: sIdx + 1,
                ),
              );

          // Upsert Stimulus
          final stimulusList = s['stimulus'] as List?;
          if (stimulusList != null) {
            for (int stIdx = 0; stIdx < stimulusList.length; stIdx++) {
              final st = stimulusList[stIdx] as Map<String, dynamic>;
              final stId = st['id'].toString();
              final stJudul = st['judul']?.toString();
              final stIsi = st['isi'].toString();

              await _db
                  .into(_db.stimulus)
                  .insertOnConflictUpdate(
                    StimulusCompanion.insert(
                      id: stId,
                      subtesId: subId,
                      judul: Value(stJudul),
                      isi: stIsi,
                      urutan: stIdx + 1,
                    ),
                  );
            }
          }

          // Upsert Soal
          final soalList = s['soal'] as List;
          for (int qIdx = 0; qIdx < soalList.length; qIdx++) {
            final q = soalList[qIdx] as Map<String, dynamic>;
            final qId = q['id'].toString();
            final qStimulusId = q['stimulusId']?.toString();
            final qTeks = q['teks'].toString();
            final qOpsiRaw = q['opsi'] as Map;
            final qOpsi = qOpsiRaw.map(
              (k, v) => MapEntry(k.toString(), v.toString()),
            );
            final qJawabanBenar = q['jawabanBenar'].toString();
            final qPembahasan = q['pembahasan']?.toString();

            await _db
                .into(_db.soal)
                .insertOnConflictUpdate(
                  SoalCompanion.insert(
                    id: qId,
                    subtesId: subId,
                    stimulusId: Value(qStimulusId),
                    urutan: qIdx + 1,
                    teks: qTeks,
                    opsi: qOpsi,
                    jawabanBenar: qJawabanBenar,
                    pembahasan: Value(qPembahasan),
                    aktif: const Value(true),
                    packId: packId,
                  ),
                );
          }
        }
      }

      // C. Soal yang tidak ada lagi di versi baru: set aktif = false (jangan dihapus)
      final existingSoals = await (_db.select(
        _db.soal,
      )..where((tbl) => tbl.packId.equals(packId))).get();

      for (final existingSoal in existingSoals) {
        // Jangan nonaktifkan jika subtes-nya dilewati (karena sedang berjalan)
        if (!runningSubtestIds.contains(existingSoal.subtesId)) {
          if (!newSoalIds.contains(existingSoal.id) && existingSoal.aktif) {
            await (_db.update(_db.soal)
                  ..where((tbl) => tbl.id.equals(existingSoal.id)))
                .write(const SoalCompanion(aktif: Value(false)));
          }
        }
      }

      // D. Catat paket_terpasang
      await _db
          .into(_db.paketTerpasang)
          .insertOnConflictUpdate(
            PaketTerpasangCompanion.insert(
              packId: packId,
              packVersion: packVersion,
              nama: packNama,
              tanggalPasang: DateTime.now(),
            ),
          );
    });

    return ImportResult(
      status: ImportStatus.success,
      packId: packId,
      packVersion: packVersion,
      message: 'Paket "$packNama" (v$packVersion) berhasil diimpor.',
      warnings: validation.warnings,
      skippedSubtests: skippedSubtests,
    );
  }
}
