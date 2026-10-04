import '../models/content_models.dart';

abstract class ContentRepository {
  /// Memantau daftar semua kategori yang tersedia, terurut berdasarkan kolom urutan.
  Stream<List<KategoriData>> watchKategoriList();

  /// Memantau daftar tes dalam suatu kategori beserta agregasi jumlah subtes,
  /// total durasi menit, dan status turunan (belumMulai/berjalan/selesai).
  Stream<List<TesSummary>> watchTesByKategori(String kategoriId);

  /// Memantau daftar subtes dalam suatu tes beserta status pengerjaan dan jumlah soal aktif.
  Stream<List<SubtesItem>> watchSubtesByTes(String tesId);

  /// Mengambil data metadata tes berdasarkan ID tes.
  Future<TesData?> getTesById(String tesId);

  /// Mengambil konten pengerjaan subtes: metadata subtes, stimulus bacaan,
  /// dan daftar soal aktif yang terurut berdasarkan kolom urutan.
  Future<SubtestContent> getSubtestContent(String subtesId);

  /// Memantau daftar seluruh paket soal yang terpasang di database lokal (Stream).
  Stream<List<PaketItemSummary>> watchPaketTerpasangList();

  /// Menghapus seluruh konten paket dan data pengerjaan terkait secara permanen (Cascade Delete).
  Future<void> hapusPaket(String packId);
}
