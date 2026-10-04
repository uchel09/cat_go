import 'package:drift/drift.dart';

import '../local/app_database.dart';
import '../models/content_models.dart';
import 'content_repository.dart';

class ContentRepositoryDrift implements ContentRepository {
  final AppDatabase _db;

  ContentRepositoryDrift(this._db);

  @override
  Stream<List<KategoriData>> watchKategoriList() {
    return (_db.select(_db.kategori)
      ..orderBy([(tbl) => OrderingTerm(expression: tbl.urutan)]))
      .watch();
  }

  @override
  Stream<List<TesSummary>> watchTesByKategori(String kategoriId) {
    final query = _db.select(_db.tes).join([
      leftOuterJoin(_db.subtes, _db.subtes.tesId.equalsExp(_db.tes.id)),
      leftOuterJoin(_db.attemptSubtes, _db.attemptSubtes.subtesId.equalsExp(_db.subtes.id)),
    ])
      ..where(_db.tes.kategoriId.equals(kategoriId))
      ..orderBy([
        OrderingTerm(expression: _db.tes.urutan),
        OrderingTerm(expression: _db.subtes.urutan),
      ]);

    return query.watch().map((rows) {
      final Map<String, TesData> tesMap = {};
      final Map<String, List<SubtesData>> subtesMap = {};
      final Map<String, Map<String, AttemptSubtesData?>> attemptsMap = {};

      for (final row in rows) {
        final t = row.readTable(_db.tes);
        tesMap.putIfAbsent(t.id, () => t);

        final s = row.readTableOrNull(_db.subtes);
        if (s != null) {
          subtesMap.putIfAbsent(t.id, () => []);
          if (!subtesMap[t.id]!.any((existing) => existing.id == s.id)) {
            subtesMap[t.id]!.add(s);
          }

          final att = row.readTableOrNull(_db.attemptSubtes);
          attemptsMap.putIfAbsent(t.id, () => {});
          attemptsMap[t.id]![s.id] = att;
        }
      }

      final List<TesSummary> summaries = [];
      for (final t in tesMap.values) {
        final subtests = subtesMap[t.id] ?? [];
        final atts = attemptsMap[t.id] ?? {};

        final totalSubtes = subtests.length;
        final totalDurasiMenit = subtests.fold<int>(0, (sum, s) => sum + s.durasiMenit);

        TesStatus derivedStatus;
        if (subtests.isEmpty) {
          derivedStatus = TesStatus.belumMulai;
        } else {
          final statuses = subtests.map((s) {
            final att = atts[s.id];
            return att?.status ?? SubtesStatus.belumMulai;
          }).toList();

          final allSelesai = statuses.every((st) => st == SubtesStatus.selesai);
          final anyBerjalan = statuses.any((st) => st == SubtesStatus.berjalan);
          final anySelesai = statuses.any((st) => st == SubtesStatus.selesai);

          if (allSelesai) {
            derivedStatus = TesStatus.selesai;
          } else if (anyBerjalan || anySelesai) {
            derivedStatus = TesStatus.berjalan;
          } else {
            derivedStatus = TesStatus.belumMulai;
          }
        }

        summaries.add(
          TesSummary(
            tes: t,
            jumlahSubtes: totalSubtes,
            totalDurasiMenit: totalDurasiMenit,
            status: derivedStatus,
          ),
        );
      }
      return summaries;
    });
  }

  @override
  Stream<List<SubtesItem>> watchSubtesByTes(String tesId) {
    final query = _db.select(_db.subtes).join([
      leftOuterJoin(
        _db.attemptSubtes,
        _db.attemptSubtes.subtesId.equalsExp(_db.subtes.id),
      ),
      leftOuterJoin(
        _db.soal,
        _db.soal.subtesId.equalsExp(_db.subtes.id) & _db.soal.aktif.equals(true),
      ),
    ])
      ..where(_db.subtes.tesId.equals(tesId))
      ..orderBy([OrderingTerm(expression: _db.subtes.urutan)]);

    return query.watch().map((rows) {
      final Map<String, SubtesData> subtesMap = {};
      final Map<String, AttemptSubtesData?> attemptsMap = {};
      final Map<String, int> activeCountMap = {};

      for (final row in rows) {
        final s = row.readTable(_db.subtes);
        subtesMap.putIfAbsent(s.id, () => s);

        final att = row.readTableOrNull(_db.attemptSubtes);
        attemptsMap.putIfAbsent(s.id, () => att);

        final q = row.readTableOrNull(_db.soal);
        if (q != null) {
          activeCountMap[s.id] = (activeCountMap[s.id] ?? 0) + 1;
        } else {
          activeCountMap.putIfAbsent(s.id, () => 0);
        }
      }

      return subtesMap.values.map((s) {
        final att = attemptsMap[s.id];
        final count = activeCountMap[s.id] ?? 0;
        final status = att?.status ?? SubtesStatus.belumMulai;
        return SubtesItem(
          subtes: s,
          totalSoalAktif: count,
          status: status,
          attempt: att,
        );
      }).toList();
    });
  }

  @override
  Future<TesData?> getTesById(String tesId) {
    return (_db.select(_db.tes)..where((tbl) => tbl.id.equals(tesId))).getSingleOrNull();
  }

  @override
  Future<SubtestContent> getSubtestContent(String subtesId) async {
    final s = await (_db.select(_db.subtes)..where((tbl) => tbl.id.equals(subtesId))).getSingle();
    final stimuli = await (_db.select(_db.stimulus)
      ..where((tbl) => tbl.subtesId.equals(subtesId))
      ..orderBy([(tbl) => OrderingTerm(expression: tbl.urutan)]))
      .get();
    final soals = await (_db.select(_db.soal)
      ..where((tbl) => tbl.subtesId.equals(subtesId) & tbl.aktif.equals(true))
      ..orderBy([(tbl) => OrderingTerm(expression: tbl.urutan)]))
      .get();

    return SubtestContent(
      subtes: s,
      stimuli: stimuli,
      soalList: soals,
    );
  }

  @override
  Stream<List<PaketItemSummary>> watchPaketTerpasangList() {
    final query = _db.select(_db.paketTerpasang).join([
      leftOuterJoin(_db.tes, _db.tes.packId.equalsExp(_db.paketTerpasang.packId)),
      leftOuterJoin(
        _db.soal,
        _db.soal.packId.equalsExp(_db.paketTerpasang.packId) & _db.soal.aktif.equals(true),
      ),
    ])..orderBy([OrderingTerm.desc(_db.paketTerpasang.tanggalPasang)]);

    return query.watch().map((rows) {
      final Map<String, PaketTerpasangData> pakets = {};
      final Map<String, Set<String>> tesIdsPerPack = {};
      final Map<String, Set<String>> soalIdsPerPack = {};

      for (final row in rows) {
        final p = row.readTable(_db.paketTerpasang);
        pakets[p.packId] = p;

        final t = row.readTableOrNull(_db.tes);
        if (t != null) {
          tesIdsPerPack.putIfAbsent(p.packId, () => {}).add(t.id);
        }

        final s = row.readTableOrNull(_db.soal);
        if (s != null && s.aktif) {
          soalIdsPerPack.putIfAbsent(p.packId, () => {}).add(s.id);
        }
      }

      return pakets.values.map((p) {
        return PaketItemSummary(
          paket: p,
          jumlahTes: tesIdsPerPack[p.packId]?.length ?? 0,
          jumlahSoal: soalIdsPerPack[p.packId]?.length ?? 0,
        );
      }).toList();
    });
  }

  @override
  Future<void> hapusPaket(String packId) async {
    await _db.transaction(() async {
      // 1. Ambil tes yang terkait dengan packId ini
      final tesList = await (_db.select(_db.tes)..where((tbl) => tbl.packId.equals(packId))).get();
      final tesIds = tesList.map((t) => t.id).toList();

      // 2. Ambil subtes yang terkait dengan tes-tes tersebut
      List<String> subtestIds = [];
      if (tesIds.isNotEmpty) {
        final subtests = await (_db.select(_db.subtes)..where((tbl) => tbl.tesId.isIn(tesIds))).get();
        subtestIds = subtests.map((s) => s.id).toList();
      }

      // 3. Hapus data progres pengerjaan (jawaban, ragu, attemptSubtes)
      if (subtestIds.isNotEmpty) {
        await (_db.delete(_db.jawaban)..where((tbl) => tbl.subtesId.isIn(subtestIds))).go();
        await (_db.delete(_db.ragu)..where((tbl) => tbl.subtesId.isIn(subtestIds))).go();
        await (_db.delete(_db.attemptSubtes)..where((tbl) => tbl.subtesId.isIn(subtestIds))).go();

        // 4. Hapus stimulus
        await (_db.delete(_db.stimulus)..where((tbl) => tbl.subtesId.isIn(subtestIds))).go();
      }

      // 5. Hapus semua soal milik packId ini (baik aktif maupun nonaktif)
      await (_db.delete(_db.soal)..where((tbl) => tbl.packId.equals(packId))).go();

      // 6. Hapus subtes & tes
      if (subtestIds.isNotEmpty) {
        await (_db.delete(_db.subtes)..where((tbl) => tbl.id.isIn(subtestIds))).go();
      }
      if (tesIds.isNotEmpty) {
        await (_db.delete(_db.tes)..where((tbl) => tbl.id.isIn(tesIds))).go();
      }

      // 7. Hapus entri di paket_terpasang
      await (_db.delete(_db.paketTerpasang)..where((tbl) => tbl.packId.equals(packId))).go();

      // 8. Bersihkan kategori kosong (kategori yang tidak lagi memiliki tes)
      final allRemainingTes = await _db.select(_db.tes).get();
      final remainingKatIds = allRemainingTes.map((t) => t.kategoriId).toSet();
      await (_db.delete(_db.kategori)..where((tbl) => tbl.id.isNotIn(remainingKatIds))).go();
    });
  }
}
