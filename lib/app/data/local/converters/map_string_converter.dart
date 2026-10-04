import 'dart:convert';
import 'package:drift/drift.dart';

/// TypeConverter untuk menyimpan dan membaca opsi pilihan ganda berupa JSON `Map<String, String>`.
class MapStringConverter extends TypeConverter<Map<String, String>, String> {
  const MapStringConverter();

  @override
  Map<String, String> fromSql(String fromDb) {
    if (fromDb.trim().isEmpty) return <String, String>{};
    try {
      final decoded = json.decode(fromDb) as Map<String, dynamic>;
      return decoded.map((key, value) => MapEntry(key, value.toString()));
    } catch (_) {
      return <String, String>{};
    }
  }

  @override
  String toSql(Map<String, String> value) {
    return json.encode(value);
  }
}
