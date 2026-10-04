import 'package:drift/drift.dart';

@DataClassName('PaketTerpasangData')
class PaketTerpasang extends Table {
  TextColumn get packId => text()();
  IntColumn get packVersion => integer()();
  TextColumn get nama => text()();
  DateTimeColumn get tanggalPasang => dateTime()();

  @override
  Set<Column> get primaryKey => {packId};
}
