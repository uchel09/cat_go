/// Konfigurasi global aplikasi CAT Go.
class AppConfig {
  AppConfig._();

  /// URL default untuk mengambil katalog index paket soal online.
  static const String catalogUrl =
      'https://raw.githubusercontent.com/russel/cat_go_packs/main/index.json';

  /// Batas waktu timeout permintaan HTTP (detik).
  static const int httpTimeoutSeconds = 15;

  /// Batas ukuran maksimal file paket yang diunduh (5 MB).
  static const int maxDownloadSizeBytes = 5 * 1024 * 1024;
}
