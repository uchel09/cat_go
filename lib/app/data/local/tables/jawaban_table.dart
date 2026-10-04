import 'package:drift/drift.dart';
import 'soal_table.dart';
import 'subtes_table.dart';

@DataClassName('JawabanData')
class Jawaban extends Table {
  TextColumn get subtesId =>
      text().references(Subtes, #id, onDelete: KeyAction.cascade)();
  TextColumn get soalId =>
      text().references(Soal, #id, onDelete: KeyAction.cascade)();
  TextColumn get opsi => text()();

  @override
  Set<Column> get primaryKey => {subtesId, soalId};
}
