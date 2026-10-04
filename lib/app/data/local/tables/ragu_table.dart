import 'package:drift/drift.dart';
import 'soal_table.dart';
import 'subtes_table.dart';

@DataClassName('RaguData')
class Ragu extends Table {
  TextColumn get subtesId =>
      text().references(Subtes, #id, onDelete: KeyAction.cascade)();
  TextColumn get soalId =>
      text().references(Soal, #id, onDelete: KeyAction.cascade)();

  @override
  Set<Column> get primaryKey => {subtesId, soalId};
}
