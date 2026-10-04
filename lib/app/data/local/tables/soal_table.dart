import 'package:drift/drift.dart';
import '../converters/map_string_converter.dart';
import 'stimulus_table.dart';
import 'subtes_table.dart';

@DataClassName('SoalData')
@TableIndex(name: 'soal_subtes_urutan_idx', columns: {#subtesId, #urutan})
class Soal extends Table {
  TextColumn get id => text()();
  TextColumn get subtesId =>
      text().references(Subtes, #id, onDelete: KeyAction.cascade)();
  TextColumn get stimulusId => text().nullable().references(
    Stimulus,
    #id,
    onDelete: KeyAction.setNull,
  )();
  IntColumn get urutan => integer()();
  TextColumn get teks => text()();
  TextColumn get opsi => text().map(const MapStringConverter())();
  TextColumn get jawabanBenar => text()();
  TextColumn get pembahasan => text().nullable()();
  BoolColumn get aktif => boolean().withDefault(const Constant(true))();
  TextColumn get packId => text()();

  @override
  Set<Column> get primaryKey => {id};
}
