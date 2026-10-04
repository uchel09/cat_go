import 'package:drift/drift.dart';

@DataClassName('KategoriData')
class Kategori extends Table {
  TextColumn get id => text()();
  TextColumn get nama => text()();
  IntColumn get urutan => integer()();

  @override
  Set<Column> get primaryKey => {id};
}
