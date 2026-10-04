import 'dart:convert';
import 'dart:io';
import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:cat_go/app/data/local/app_database.dart';
import 'package:cat_go/app/data/local/tables/attempt_subtes_table.dart';
import 'package:cat_go/app/data/services/pack_importer.dart';
import 'package:cat_go/app/data/services/pack_validator.dart';

Map<String, dynamic> createSamplePack({
  int schemaVersion = 1,
  String packId = 'pack-test',
  int packVersion = 1,
  String nama = 'Paket Uji',
  String katId = 'kat-test',
  String tesId = 'tes-test-1',
  String subtesId = 'sub-test-1',
  List<Map<String, dynamic>>? stimulusList,
  List<Map<String, dynamic>>? soalList,
}) {
  return {
    'schemaVersion': schemaVersion,
    'packId': packId,
    'packVersion': packVersion,
    'nama': nama,
    'kategori': {'id': katId, 'nama': 'Kategori Uji'},
    'tes': [
      {
        'id': tesId,
        'nama': 'Tes Uji 1',
        'subtes': [
          {
            'id': subtesId,
            'nama': 'Subtes Uji 1',
            'durasiMenit': 10,
            'stimulus': stimulusList ?? [],
            'soal':
                soalList ??
                [
                  {
                    'id': '$subtesId.q1',
                    'teks': 'Pertanyaan 1',
                    'opsi': {'A': 'Pilihan A', 'B': 'Pilihan B'},
                    'jawabanBenar': 'A',
                    'pembahasan': 'Penjelasan 1',
                  },
                ],
          },
        ],
      },
    ],
  };
}

void main() {
  late AppDatabase db;
  late PackValidator validator;
  late PackImporter importer;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    validator = PackValidator();
    importer = PackImporter(db, validator: validator);
  });

  tearDown(() async {
    await db.close();
  });

  test('1. Validasi dan impor paket valid', () async {
    final pack = createSamplePack();
    final validation = validator.validate(pack);
    expect(validation.isValid, isTrue);
    expect(validation.errors, isEmpty);

    final result = await importer.importPack(pack);
    expect(result.status, ImportStatus.success);

    // Cek entitas di database
    final kategori = await (db.select(
      db.kategori,
    )..where((tbl) => tbl.id.equals('kat-test'))).getSingleOrNull();
    expect(kategori, isNotNull);
    expect(kategori!.nama, 'Kategori Uji');

    final tes = await (db.select(
      db.tes,
    )..where((tbl) => tbl.id.equals('tes-test-1'))).getSingleOrNull();
    expect(tes, isNotNull);

    final soal = await (db.select(
      db.soal,
    )..where((tbl) => tbl.id.equals('sub-test-1.q1'))).getSingleOrNull();
    expect(soal, isNotNull);
    expect(soal!.aktif, isTrue);

    final installed = await (db.select(
      db.paketTerpasang,
    )..where((tbl) => tbl.packId.equals('pack-test'))).getSingleOrNull();
    expect(installed, isNotNull);
    expect(installed!.packVersion, 1);
  });

  test('2. Deteksi ID duplikat di seluruh paket', () {
    final pack = createSamplePack(
      soalList: [
        {
          'id': 'duplicate-id',
          'teks': 'Soal 1',
          'opsi': {'A': 'A', 'B': 'B'},
          'jawabanBenar': 'A',
        },
        {
          'id': 'duplicate-id',
          'teks': 'Soal 2',
          'opsi': {'A': 'A', 'B': 'B'},
          'jawabanBenar': 'B',
        },
      ],
    );

    final validation = validator.validate(pack);
    expect(validation.isValid, isFalse);
    expect(validation.errors.any((e) => e.contains('ID duplikat')), isTrue);
  });

  test('3. Deteksi jawabanBenar tidak ada di opsi', () {
    final pack = createSamplePack(
      soalList: [
        {
          'id': 'q-invalid-ans',
          'teks': 'Soal invalid jawaban',
          'opsi': {'A': 'Pilihan A', 'B': 'Pilihan B'},
          'jawabanBenar': 'C', // 'C' tidak ada di opsi
        },
      ],
    );

    final validation = validator.validate(pack);
    expect(validation.isValid, isFalse);
    expect(
      validation.errors.any((e) => e.contains('tidak ada di opsi')),
      isTrue,
    );
  });

  test('4. Deteksi stimulusId tidak ditemukan di subtes yang sama', () {
    final pack = createSamplePack(
      soalList: [
        {
          'id': 'q-missing-stim',
          'stimulusId': 'non-existent-stim',
          'teks': 'Soal dengan stimulus gaib',
          'opsi': {'A': 'A', 'B': 'B'},
          'jawabanBenar': 'A',
        },
      ],
    );

    final validation = validator.validate(pack);
    expect(validation.isValid, isFalse);
    expect(
      validation.errors.any(
        (e) => e.contains('tidak ditemukan pada subtes yang sama'),
      ),
      isTrue,
    );
  });

  test('5. Validasi soal yang memakai wacana sama harus berurutan', () {
    // Soal dengan stimulus s1 diselingi soal tanpa stimulus lalu memakai s1 lagi
    final pack = createSamplePack(
      stimulusList: [
        {'id': 'stim-1', 'judul': 'Wacana 1', 'isi': 'Isi wacana 1'},
      ],
      soalList: [
        {
          'id': 'q1',
          'stimulusId': 'stim-1',
          'teks': 'Soal 1',
          'opsi': {'A': 'A'},
          'jawabanBenar': 'A',
        },
        {
          'id': 'q2',
          'teks': 'Soal 2 (tanpa wacana)',
          'opsi': {'A': 'A'},
          'jawabanBenar': 'A',
        },
        {
          'id': 'q3',
          'stimulusId': 'stim-1',
          'teks': 'Soal 3 (wacana terputus)',
          'opsi': {'A': 'A'},
          'jawabanBenar': 'A',
        },
      ],
    );

    final validation = validator.validate(pack);
    expect(validation.isValid, isFalse);
    expect(validation.errors.any((e) => e.contains('tidak berurutan')), isTrue);
  });

  test('6. Peringatan untuk wacana yang tidak digunakan', () {
    final pack = createSamplePack(
      stimulusList: [
        {
          'id': 'stim-unused',
          'judul': 'Wacana Tak Terpakai',
          'isi': 'Isi wacana',
        },
      ],
      soalList: [
        {
          'id': 'q1',
          'teks': 'Soal biasa',
          'opsi': {'A': 'A'},
          'jawabanBenar': 'A',
        },
      ],
    );

    final validation = validator.validate(pack);
    expect(validation.isValid, isTrue); // Tetap valid
    expect(validation.hasWarnings, isTrue);
    expect(
      validation.warnings.any(
        (w) => w.contains('tidak digunakan oleh soal mana pun'),
      ),
      isTrue,
    );
  });

  test('7. Impor ulang versi sama diabaikan kecuali dipaksa (force)', () async {
    final pack = createSamplePack(packVersion: 1);

    // Impor pertama kali
    final res1 = await importer.importPack(pack);
    expect(res1.status, ImportStatus.success);

    // Impor kedua kali (versi sama, tanpa force)
    final res2 = await importer.importPack(pack, force: false);
    expect(res2.status, ImportStatus.skippedVersion);

    // Impor ketiga kali dengan force: true
    final res3 = await importer.importPack(pack, force: true);
    expect(res3.status, ImportStatus.success);
  });

  test(
    '8. Impor versi lebih baru memperbarui konten dan menonaktifkan soal lama',
    () async {
      // Versi 1: memiliki q1 dan q2
      final packV1 = createSamplePack(
        packVersion: 1,
        soalList: [
          {
            'id': 'sub-test-1.q1',
            'teks': 'Soal 1 v1',
            'opsi': {'A': 'A'},
            'jawabanBenar': 'A',
          },
          {
            'id': 'sub-test-1.q2',
            'teks': 'Soal 2 v1',
            'opsi': {'A': 'A'},
            'jawabanBenar': 'A',
          },
        ],
      );
      await importer.importPack(packV1);

      // Versi 2: memiliki q1 (teks diubah) dan q3 (baru). q2 dihilangkan!
      final packV2 = createSamplePack(
        packVersion: 2,
        soalList: [
          {
            'id': 'sub-test-1.q1',
            'teks': 'Soal 1 v2 terbarui',
            'opsi': {'A': 'A'},
            'jawabanBenar': 'A',
          },
          {
            'id': 'sub-test-1.q3',
            'teks': 'Soal 3 v2 baru',
            'opsi': {'A': 'A'},
            'jawabanBenar': 'A',
          },
        ],
      );
      final resV2 = await importer.importPack(packV2);
      expect(resV2.status, ImportStatus.success);

      // Verifikasi q1 diperbarui dan aktif
      final q1 = await (db.select(
        db.soal,
      )..where((tbl) => tbl.id.equals('sub-test-1.q1'))).getSingle();
      expect(q1.teks, 'Soal 1 v2 terbarui');
      expect(q1.aktif, isTrue);

      // Verifikasi q3 ditambahkan dan aktif
      final q3 = await (db.select(
        db.soal,
      )..where((tbl) => tbl.id.equals('sub-test-1.q3'))).getSingle();
      expect(q3.aktif, isTrue);

      // Verifikasi q2 tidak dihapus tetapi dinonaktifkan (aktif = false)
      final q2 = await (db.select(
        db.soal,
      )..where((tbl) => tbl.id.equals('sub-test-1.q2'))).getSingle();
      expect(q2.aktif, isFalse);

      // Versi terpasang sekarang adalah 2
      final installed = await (db.select(
        db.paketTerpasang,
      )..where((tbl) => tbl.packId.equals('pack-test'))).getSingle();
      expect(installed.packVersion, 2);
    },
  );

  test(
    '9. Subtes yang sedang berjalan tidak tertimpa saat impor paket baru',
    () async {
      // Impor versi 1
      final packV1 = createSamplePack(
        packVersion: 1,
        soalList: [
          {
            'id': 'sub-test-1.q1',
            'teks': 'Soal Awal',
            'opsi': {'A': 'A'},
            'jawabanBenar': 'A',
          },
        ],
      );
      await importer.importPack(packV1);

      // Set status subtes menjadi 'berjalan'
      await db
          .into(db.attemptSubtes)
          .insert(
            AttemptSubtesCompanion.insert(
              subtesId: 'sub-test-1',
              status: SubtesStatus.berjalan,
              mulaiAt: Value(DateTime.now()),
            ),
          );

      // Impor versi 2 yang berusaha mengubah teks soal pada subtes tersebut
      final packV2 = createSamplePack(
        packVersion: 2,
        soalList: [
          {
            'id': 'sub-test-1.q1',
            'teks': 'Soal Diubah di V2',
            'opsi': {'A': 'A'},
            'jawabanBenar': 'A',
          },
        ],
      );
      final resV2 = await importer.importPack(packV2);
      expect(resV2.status, ImportStatus.success);
      expect(resV2.skippedSubtests.isNotEmpty, isTrue);

      // Teks soal di database tidak boleh berubah karena subtes sedang berjalan
      final q1 = await (db.select(
        db.soal,
      )..where((tbl) => tbl.id.equals('sub-test-1.q1'))).getSingle();
      expect(q1.teks, 'Soal Awal');
    },
  );

  test('10. Validasi integritas ketiga file paket bawaan (assets/packs/)', () {
    final assetFiles = [
      'assets/packs/tbs_lpdp.json',
      'assets/packs/utbk.json',
      'assets/packs/tiu.json',
    ];

    for (final filePath in assetFiles) {
      final file = File(filePath);
      expect(file.existsSync(), isTrue, reason: 'File $filePath harus ada');
      final content = file.readAsStringSync();
      final jsonMap = json.decode(content) as Map<String, dynamic>;

      final result = validator.validate(jsonMap);
      expect(
        result.isValid,
        isTrue,
        reason: 'Validasi $filePath gagal: ${result.errors.join("; ")}',
      );
      expect(result.errors, isEmpty);
    }
  });
}
