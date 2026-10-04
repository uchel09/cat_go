import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import 'converters/map_string_converter.dart';
import 'tables/attempt_subtes_table.dart';
import 'tables/jawaban_table.dart';
import 'tables/kategori_table.dart';
import 'tables/paket_terpasang_table.dart';
import 'tables/ragu_table.dart';
import 'tables/soal_table.dart';
import 'tables/stimulus_table.dart';
import 'tables/subtes_table.dart';
import 'tables/tes_table.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    Kategori,
    Tes,
    Subtes,
    Stimulus,
    Soal,
    PaketTerpasang,
    AttemptSubtes,
    Jawaban,
    Ragu,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (Migrator m) async {
      await m.createAll();
    },
    onUpgrade: (Migrator m, int from, int to) async {
      // Dari titik ini, setiap perubahan skema Drift wajib menaikkan schemaVersion
      // dan menambahkan migrasi step-by-step di blok ini.
    },
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON;');
    },
  );

  static QueryExecutor _openConnection() {
    return driftDatabase(name: 'cat_go_db');
  }
}
