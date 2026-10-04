/// Status ketersediaan paket katalog terhadap database lokal.
enum CatalogItemStatus {
  /// Belum pernah dipasang di perangkat lokal.
  unduh,

  /// Sudah terpasang, tetapi ada versi yang lebih baru di katalog.
  perbarui,

  /// Sudah terpasang dengan versi yang sama atau lebih baru.
  terbaru,
}

/// Item paket dalam katalog online (index.json).
class CatalogPackItem {
  final String packId;
  final String nama;
  final int packVersion;
  final String url;
  final int ukuranKb;

  const CatalogPackItem({
    required this.packId,
    required this.nama,
    required this.packVersion,
    required this.url,
    required this.ukuranKb,
  });

  factory CatalogPackItem.fromJson(Map<String, dynamic> json) {
    return CatalogPackItem(
      packId: json['packId'] as String? ?? '',
      nama: json['nama'] as String? ?? '',
      packVersion: json['packVersion'] as int? ?? 1,
      url: json['url'] as String? ?? '',
      ukuranKb: json['ukuranKb'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    'packId': packId,
    'nama': nama,
    'packVersion': packVersion,
    'url': url,
    'ukuranKb': ukuranKb,
  };
}
