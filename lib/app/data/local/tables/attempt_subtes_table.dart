import 'package:drift/drift.dart';
import 'subtes_table.dart';

enum SubtesStatus { belumMulai, berjalan, selesai }

@DataClassName('AttemptSubtesData')
class AttemptSubtes extends Table {
  TextColumn get subtesId =>
      text().references(Subtes, #id, onDelete: KeyAction.cascade)();
  TextColumn get status => textEnum<SubtesStatus>()();
  DateTimeColumn get endTime => dateTime().nullable()();
  DateTimeColumn get mulaiAt => dateTime().nullable()();
  DateTimeColumn get selesaiAt => dateTime().nullable()();
  IntColumn get benar => integer().nullable()();
  IntColumn get salah => integer().nullable()();
  IntColumn get kosong => integer().nullable()();
  IntColumn get totalSoal => integer().nullable()();

  @override
  Set<Column> get primaryKey => {subtesId};
}
