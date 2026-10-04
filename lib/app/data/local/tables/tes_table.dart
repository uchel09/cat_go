import 'package:drift/drift.dart';
import 'kategori_table.dart';

@DataClassName('TesData')
class Tes extends Table {
  TextColumn get id => text()();
  TextColumn get kategoriId =>
      text().references(Kategori, #id, onDelete: KeyAction.cascade)();
  TextColumn get nama => text()();
  IntColumn get urutan => integer()();
  TextColumn get packId => text()();

  @override
  Set<Column> get primaryKey => {id};
}
