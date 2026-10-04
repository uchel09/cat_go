import 'dart:convert';
import 'package:file_picker/file_picker.dart';

/// Layanan untuk memilih file dokumen secara aman di platform mobile/desktop.
class FilePickerService {
  /// Membuka file dialog sistem untuk memilih file JSON.
  /// Mengembalikan konten string dari file yang dipilih, atau null jika dibatalkan.
  Future<String?> pickJsonFileContent() async {
    final file = await FilePicker.pickFile(
      type: FileType.custom,
      allowedExtensions: ['json'],
    );

    if (file == null) {
      return null;
    }

    final bytes = await file.readAsBytes();
    return utf8.decode(bytes);
  }
}
