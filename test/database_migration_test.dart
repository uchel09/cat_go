import 'package:cat_go/app/data/local/app_database.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Database Migration & Schema Tests', () {
    test(
      '1. Database menginisialisasi schemaVersion yang benar dan tabel dibuat',
      () async {
        final db = AppDatabase(NativeDatabase.memory());
        addTearDown(() => db.close());

        expect(db.schemaVersion, equals(1));

        // Pastikan strategi migrasi onCreate membuat seluruh tabel yang terdaftar
        final kategoris = await db.select(db.kategori).get();
        expect(kategoris, isEmpty);

        final tesList = await db.select(db.tes).get();
        expect(tesList, isEmpty);

        final attempts = await db.select(db.attemptSubtes).get();
        expect(attempts, isEmpty);
      },
    );

    test(
      '2. Foreign key constraints diaktifkan oleh MigrationStrategy.beforeOpen',
      () async {
        final db = AppDatabase(NativeDatabase.memory());
        addTearDown(() => db.close());

        // Cek status PRAGMA foreign_keys
        final result = await db
            .customSelect('PRAGMA foreign_keys;')
            .getSingle();
        final fkEnabled = result.data.values.first;
        expect(fkEnabled, equals(1)); // 1 berarti foreign keys aktif
      },
    );

    test(
      '3. Foreign key violation melempar error saat referensi induk tidak ada',
      () async {
        final db = AppDatabase(NativeDatabase.memory());
        addTearDown(() => db.close());

        // Mencoba menyisipkan tes dengan kategoriId yang tidak ada di tabel kategori
        expect(() async {
          await db
              .into(db.tes)
              .insert(
                TesCompanion.insert(
                  id: 'tes-orphaned',
                  kategoriId: 'kat-non-existent',
                  nama: 'Tes Tanpa Induk',
                  urutan: 1,
                  packId: 'pack-none',
                ),
              );
        }, throwsA(anything));
      },
    );
  });
}
