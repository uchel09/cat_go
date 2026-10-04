import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/models/catalog_models.dart';
import '../../../data/models/content_models.dart';
import '../../../data/repositories/content_repository.dart';
import '../../../data/services/catalog_service.dart';
import '../../../data/services/file_picker_service.dart';
import '../../../data/services/pack_importer.dart';

class PacksController extends GetxController {
  final ContentRepository _contentRepository;
  final PackImporter _packImporter;
  final FilePickerService _filePickerService;
  final CatalogService _catalogService;

  PacksController({
    ContentRepository? contentRepository,
    PackImporter? packImporter,
    FilePickerService? filePickerService,
    CatalogService? catalogService,
  }) : _contentRepository = contentRepository ?? Get.find<ContentRepository>(),
       _packImporter = packImporter ?? Get.find<PackImporter>(),
       _filePickerService = filePickerService ?? Get.find<FilePickerService>(),
       _catalogService = catalogService ?? Get.find<CatalogService>();

  // State Paket Terpasang (Lokal)
  final paketList = <PaketItemSummary>[].obs;
  final isLoading = true.obs;
  final isImporting = false.obs;
  final importProgressMessage = ''.obs;

  // State Katalog Online (Tersedia)
  final catalogList = <CatalogPackItem>[].obs;
  final isLoadingCatalog = false.obs;
  final catalogErrorMessage = ''.obs;
  final downloadingPackId =
      ''.obs; // ID paket yang sedang diunduh untuk cegah unduhan ganda
  final downloadProgressMessage = ''.obs;

  StreamSubscription? _subscription;

  @override
  void onInit() {
    super.onInit();
    _subscription = _contentRepository.watchPaketTerpasangList().listen((
      items,
    ) {
      paketList.value = items;
      isLoading.value = false;
    });
    muatKatalog();
  }

  @override
  void onClose() {
    _subscription?.cancel();
    super.onClose();
  }

  // =========================================================================
  // LOGIKA KATALOG ONLINE
  // =========================================================================

  /// Mengambil daftar paket dari katalog index.json online
  Future<void> muatKatalog() async {
    try {
      isLoadingCatalog.value = true;
      catalogErrorMessage.value = '';
      final items = await _catalogService.fetchCatalog();
      catalogList.assignAll(items);
    } catch (e) {
      catalogErrorMessage.value = e.toString();
    } finally {
      isLoadingCatalog.value = false;
    }
  }

  /// Membandingkan paket di katalog dengan paket terpasang di perangkat
  CatalogItemStatus getCatalogItemStatus(CatalogPackItem item) {
    final local = paketList.firstWhereOrNull(
      (p) => p.paket.packId == item.packId,
    );
    if (local == null) {
      return CatalogItemStatus.unduh;
    }
    if (local.paket.packVersion < item.packVersion) {
      return CatalogItemStatus.perbarui;
    }
    return CatalogItemStatus.terbaru;
  }

  /// Mengunduh paket soal dari katalog online lalu mengimpornya via PackImporter
  Future<void> unduhDanImporPaket(
    BuildContext context,
    CatalogPackItem item,
  ) async {
    if (downloadingPackId.isNotEmpty || isImporting.value) {
      return; // Cegah unduhan ganda
    }

    try {
      downloadingPackId.value = item.packId;
      downloadProgressMessage.value = 'Mengunduh paket "${item.nama}"...';

      // 1. Unduh string JSON dari URL statis
      final jsonString = await _catalogService.downloadPackJson(item.url);

      downloadProgressMessage.value = 'Memvalidasi dan memasang paket...';

      // 2. Impor melalui jalur yang SAMA dengan impor file lokal (PackImporter)
      final status = getCatalogItemStatus(item);
      final force = (status == CatalogItemStatus.perbarui);
      final result = await _packImporter.importJsonString(
        jsonString,
        force: force,
      );

      downloadingPackId.value = '';
      downloadProgressMessage.value = '';

      if (!context.mounted) return;

      _showImportResultDialog(context, result);
    } catch (e) {
      downloadingPackId.value = '';
      downloadProgressMessage.value = '';
      if (context.mounted) {
        _showErrorDialog(
          context,
          title: 'Gagal Mengunduh Paket',
          message: e.toString(),
        );
      }
    } finally {
      downloadingPackId.value = '';
      downloadProgressMessage.value = '';
    }
  }

  // =========================================================================
  // LOGIKA IMPOR FILE LOKAL
  // =========================================================================

  /// Memilih file JSON dari penyimpanan lokal dan mengimpornya ke database.
  Future<void> pilihDanImporFile(BuildContext context) async {
    if (isImporting.value || downloadingPackId.isNotEmpty) {
      return; // Mencegah impor ganda
    }

    try {
      final jsonContent = await _filePickerService.pickJsonFileContent();
      if (jsonContent == null || jsonContent.trim().isEmpty) {
        return; // Pengguna membatalkan pemilihan file
      }

      isImporting.value = true;
      importProgressMessage.value = 'Membaca dan memvalidasi paket...';

      final result = await _packImporter.importJsonString(jsonContent);

      isImporting.value = false;
      importProgressMessage.value = '';

      if (!context.mounted) return;

      _showImportResultDialog(context, result);
    } catch (e) {
      isImporting.value = false;
      importProgressMessage.value = '';
      if (context.mounted) {
        _showErrorDialog(
          context,
          title: 'Gagal Membaca File',
          message:
              'File yang dipilih rusak atau bukan JSON yang valid.\n\nDetail: $e',
        );
      }
    } finally {
      isImporting.value = false;
      importProgressMessage.value = '';
    }
  }

  /// Menampilkan dialog detail hasil impor (sukses, dilewati, atau daftar error validasi).
  void _showImportResultDialog(BuildContext context, ImportResult result) {
    switch (result.status) {
      case ImportStatus.success:
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Row(
              children: [
                Icon(Icons.check_circle, color: Colors.green),
                SizedBox(width: 8),
                Text('Impor Berhasil'),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(result.message),
                if (result.skippedSubtests.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Text(
                    'Catatan: Subtes yang sedang berjalan dilewati agar tidak mengganggu ujian:\n• ${result.skippedSubtests.join('\n• ')}',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.orange.shade800,
                    ),
                  ),
                ],
                if (result.warnings.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  const Text(
                    'Peringatan:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    result.warnings.map((w) => '• $w').join('\n'),
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
                  ),
                ],
              ],
            ),
            actions: [
              FilledButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Tutup'),
              ),
            ],
          ),
        );
        break;

      case ImportStatus.skippedVersion:
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Row(
              children: [
                Icon(Icons.info_outline, color: Colors.blue),
                SizedBox(width: 8),
                Text('Paket Dilewati'),
              ],
            ),
            content: Text(result.message),
            actions: [
              FilledButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Tutup'),
              ),
            ],
          ),
        );
        break;

      case ImportStatus.invalid:
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Row(
              children: [
                Icon(Icons.error_outline, color: Colors.red),
                SizedBox(width: 8),
                Text('Validasi Gagal'),
              ],
            ),
            content: SizedBox(
              width: double.maxFinite,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Struktur paket tidak memenuhi spesifikasi yang ditentukan. Perbaiki kesalahan berikut:',
                      style: TextStyle(fontSize: 13),
                    ),
                    const SizedBox(height: 10),
                    ...result.errors.map(
                      (err) => Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              '• ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.red,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                err,
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              FilledButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Tutup'),
              ),
            ],
          ),
        );
        break;

      case ImportStatus.failed:
        _showErrorDialog(
          context,
          title: 'Impor Gagal',
          message: result.message,
        );
        break;
    }
  }

  void _showErrorDialog(
    BuildContext context, {
    required String title,
    required String message,
  }) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.red),
            const SizedBox(width: 8),
            Text(title),
          ],
        ),
        content: Text(message),
        actions: [
          FilledButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

  // =========================================================================
  // LOGIKA HAPUS PAKET
  // =========================================================================

  /// Menampilkan dialog konfirmasi penghapusan paket beserta konsekuensi terhadap progres pengerjaan.
  Future<void> konfirmasiHapusPaket(
    BuildContext context,
    PaketItemSummary item,
  ) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Hapus Paket Soal?'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text.rich(
              TextSpan(
                children: [
                  const TextSpan(text: 'Menghapus paket '),
                  TextSpan(
                    text: item.paket.nama,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const TextSpan(
                    text:
                        ' akan menghapus secara permanen:\n\n'
                        '• Seluruh tes dan subtes dalam paket ini\n'
                        '• Seluruh soal dan wacana bacaan\n'
                        '• Seluruh riwayat jawaban, nilai, dan statistik pengerjaan Anda\n\n'
                        'Tindakan ini tidak dapat dibatalkan.',
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Batal'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red.shade600),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Hapus Permanen'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await hapusPaket(item.paket.packId);
    }
  }

  /// Mengeksekusi penghapusan paket secara kaskade (cascade delete).
  Future<void> hapusPaket(String packId) async {
    try {
      await _contentRepository.hapusPaket(packId);
      final ctx = Get.context;
      if (ctx != null && Get.overlayContext != null) {
        Get.snackbar(
          'Paket Dihapus',
          'Paket soal dan riwayat terkait telah berhasil dihapus.',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 2),
        );
      }
    } catch (e) {
      final ctx = Get.context;
      if (ctx != null && Get.overlayContext != null) {
        Get.snackbar(
          'Gagal Menghapus Paket',
          'Terjadi kesalahan saat menghapus paket: $e',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 3),
        );
      }
    }
  }

  /// Format tanggal pasang: "DD MMM YYYY, HH:mm"
  String formatTanggal(DateTime dt) {
    const bulan = [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember',
    ];
    final b = bulan[dt.month - 1];
    final jam = dt.hour.toString().padLeft(2, '0');
    final menit = dt.minute.toString().padLeft(2, '0');
    return '${dt.day} $b ${dt.year}, $jam:$menit';
  }
}
