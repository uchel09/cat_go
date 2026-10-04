import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import '../../config/app_config.dart';
import '../models/catalog_models.dart';

class CatalogException implements Exception {
  final String message;
  CatalogException(this.message);

  @override
  String toString() => message;
}

/// Layanan untuk mengambil katalog paket online dan mengunduh file paket soal statis.
class CatalogService {
  final http.Client _client;

  CatalogService({http.Client? client}) : _client = client ?? http.Client();

  /// Mengambil daftar paket dari katalog index.json online.
  Future<List<CatalogPackItem>> fetchCatalog({String? customUrl}) async {
    final urlStr = customUrl ?? AppConfig.catalogUrl;
    final uri = Uri.parse(urlStr);

    try {
      final response = await _client
          .get(uri)
          .timeout(const Duration(seconds: AppConfig.httpTimeoutSeconds));

      if (response.statusCode != 200) {
        throw CatalogException(
          'Gagal memuat katalog (Server merespons kode: ${response.statusCode}).',
        );
      }

      final dynamic decoded = json.decode(response.body);
      if (decoded is! Map<String, dynamic> || decoded['paket'] is! List) {
        throw CatalogException(
          'Format katalog tidak valid: tidak ditemukan array "paket".',
        );
      }

      final list = decoded['paket'] as List;
      return list
          .whereType<Map<String, dynamic>>()
          .map((item) => CatalogPackItem.fromJson(item))
          .toList();
    } on SocketException {
      throw CatalogException(
        'Tidak ada koneksi internet. Periksa jaringan Anda.',
      );
    } on TimeoutException {
      throw CatalogException(
        'Waktu koneksi habis. Server terlalu lama merespons.',
      );
    } on FormatException catch (e) {
      throw CatalogException(
        'Data katalog rusak atau bukan format JSON yang valid ($e).',
      );
    } catch (e) {
      if (e is CatalogException) rethrow;
      throw CatalogException('Terjadi kendala saat memuat katalog: $e');
    }
  }

  /// Mengunduh file JSON paket soal dari URL statis dengan proteksi batas ukuran.
  Future<String> downloadPackJson(
    String fileUrl, {
    int maxSizeBytes = AppConfig.maxDownloadSizeBytes,
  }) async {
    final uri = Uri.parse(fileUrl);

    try {
      final response = await _client
          .get(uri)
          .timeout(const Duration(seconds: AppConfig.httpTimeoutSeconds * 2));

      if (response.statusCode != 200) {
        throw CatalogException(
          'Gagal mengunduh file paket (Kode status: ${response.statusCode}).',
        );
      }

      final bytes = response.bodyBytes;
      if (bytes.length > maxSizeBytes) {
        final sizeMb = (bytes.length / (1024 * 1024)).toStringAsFixed(2);
        throw CatalogException(
          'Ukuran file ($sizeMb MB) melebihi batas maksimal yang diizinkan (5 MB).',
        );
      }

      return utf8.decode(bytes);
    } on SocketException {
      throw CatalogException(
        'Tidak ada koneksi internet saat mengunduh paket.',
      );
    } on TimeoutException {
      throw CatalogException(
        'Proses unduhan terputus (waktu habis). Silakan coba lagi.',
      );
    } on FormatException {
      throw CatalogException(
        'File yang diunduh rusak atau encoding tidak didukung.',
      );
    } catch (e) {
      if (e is CatalogException) rethrow;
      throw CatalogException('Gagal mengunduh paket: $e');
    }
  }

  void dispose() {
    _client.close();
  }
}
