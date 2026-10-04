import 'package:drift/drift.dart';
import 'subtes_table.dart';

@DataClassName('StimulusData')
class Stimulus extends Table {
  TextColumn get id => text()();
  TextColumn get subtesId =>
      text().references(Subtes, #id, onDelete: KeyAction.cascade)();
  TextColumn get judul => text().nullable()();
  TextColumn get isi => text()();
  IntColumn get urutan => integer()();

  @override
  Set<Column> get primaryKey => {id};
}
