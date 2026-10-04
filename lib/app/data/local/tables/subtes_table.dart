import 'package:drift/drift.dart';
import 'tes_table.dart';

@DataClassName('SubtesData')
class Subtes extends Table {
  TextColumn get id => text()();
  TextColumn get tesId =>
      text().references(Tes, #id, onDelete: KeyAction.cascade)();
  TextColumn get nama => text()();
  IntColumn get durasiMenit => integer()();
  IntColumn get urutan => integer()();

  @override
  Set<Column> get primaryKey => {id};
}
