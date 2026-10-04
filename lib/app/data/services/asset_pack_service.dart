import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'pack_importer.dart';

/// Layanan untuk mengelola dan mengimpor paket soal bawaan dari aset aplikasi.
class AssetPackService {
  final PackImporter _importer;

  static const List<String> bundledAssets = [
    'assets/packs/tbs_lpdp.json',
    'assets/packs/utbk.json',
    'assets/packs/tiu.json',
  ];

  AssetPackService(this._importer);

  /// Mengimpor seluruh paket bawaan yang belum terpasang atau memiliki versi lebih baru.
  Future<void> initBundledPacks({void Function(String message)? onProgress}) async {
    for (final assetPath in bundledAssets) {
      try {
        final jsonString = await rootBundle
            .loadString(assetPath)
            .timeout(const Duration(seconds: 2));
        final jsonMap = json.decode(jsonString) as Map<String, dynamic>;
        final packNama = jsonMap['nama']?.toString() ?? 'Paket';

        onProgress?.call('Menyiapkan $packNama...');
        await _importer.importPack(jsonMap, force: false);
      } catch (e) {
        debugPrint('Gagal memuat paket bawaan $assetPath: $e');
      }
    }
  }
}
