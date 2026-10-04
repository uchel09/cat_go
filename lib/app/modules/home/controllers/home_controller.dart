import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/models/content_models.dart';
import '../../../data/repositories/content_repository.dart';
import '../../../data/repositories/exam_repository.dart';
import '../../../data/services/asset_pack_service.dart';

class HomeController extends GetxController {
  final ContentRepository _contentRepository;
  final ExamRepository _examRepository;
  final AssetPackService? _assetPackService;
  final bool autoInitBundledPacks;

  HomeController({
    ContentRepository? contentRepository,
    ExamRepository? examRepository,
    AssetPackService? assetPackService,
    this.autoInitBundledPacks = true,
  }) : _contentRepository = contentRepository ?? Get.find<ContentRepository>(),
       _examRepository = examRepository ?? Get.find<ExamRepository>(),
       _assetPackService =
           assetPackService ??
           (Get.isRegistered<AssetPackService>()
               ? Get.find<AssetPackService>()
               : null);

  final isLoading = true.obs;
  final loadingMessage = 'Menyiapkan paket soal...'.obs;

  final kategoriList = <KategoriData>[].obs;
  final selectedKategoriId = RxnString();
  final tesList = <TesSummary>[].obs;
  final isLoadingTes = false.obs;

  StreamSubscription? _kategoriSubscription;
  StreamSubscription? _tesSubscription;

  @override
  void onInit() {
    super.onInit();
    initData();
  }

  Future<void> initData() async {
    if (autoInitBundledPacks && _assetPackService != null) {
      try {
        await _assetPackService.initBundledPacks(
          onProgress: (msg) => loadingMessage.value = msg,
        );
      } catch (_) {
        // Abaikan error agar app tetap dapat lanjut membuka UI
      }
    }

    _kategoriSubscription = _contentRepository.watchKategoriList().listen((
      kategoris,
    ) {
      kategoriList.value = kategoris;
      if (kategoris.isNotEmpty) {
        final currentSelected = selectedKategoriId.value;
        if (currentSelected == null ||
            !kategoris.any((k) => k.id == currentSelected)) {
          selectKategori(kategoris.first.id);
        }
      } else {
        selectedKategoriId.value = null;
        tesList.clear();
      }
      isLoading.value = false;
    });
  }

  void selectKategori(String kategoriId) {
    if (selectedKategoriId.value == kategoriId && _tesSubscription != null) {
      return;
    }
    selectedKategoriId.value = kategoriId;
    isLoadingTes.value = true;

    _tesSubscription?.cancel();
    _tesSubscription = _contentRepository.watchTesByKategori(kategoriId).listen(
      (items) {
        tesList.value = items;
        isLoadingTes.value = false;
      },
    );
  }

  /// Membuka halaman daftar subtes dari tes tertentu
  void navigateToSubtest(String tesId) {
    Get.toNamed('/subtes', arguments: tesId);
  }

  /// Menuju daftar pembahasan per subtes (halaman subtes)
  void lihatPembahasanTes(String tesId) {
    navigateToSubtest(tesId);
  }

  /// Menampilkan dialog konfirmasi sebelum mereset progres tes
  Future<void> konfirmasiUlangiTes(
    BuildContext context,
    TesSummary summary,
  ) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Ulangi Tes'),
        content: Text(
          'Hasil sebelumnya untuk "${summary.tes.nama}" akan dihapus. '
          'Apakah Anda yakin ingin mengulang seluruh tes ini dari awal?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Batal'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red.shade600),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Ulangi'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await ulangiTes(summary.tes.id);
    }
  }

  /// Menghapus seluruh riwayat pengerjaan tes dalam satu transaksi atomik
  Future<void> ulangiTes(String tesId) async {
    try {
      await _examRepository.ulangiTes(tesId);
      final ctx = Get.context;
      if (ctx != null && Get.overlayContext != null) {
        Get.snackbar(
          'Tes Direset',
          'Hasil sebelumnya telah dihapus. Anda dapat mengerjakan kembali dari awal.',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 2),
        );
      }
    } catch (e) {
      final ctx = Get.context;
      if (ctx != null && Get.overlayContext != null) {
        Get.snackbar(
          'Gagal Mengulang Tes',
          'Terjadi kesalahan saat menghapus data: $e',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 3),
        );
      }
    }
  }

  @override
  void onClose() {
    _kategoriSubscription?.cancel();
    _tesSubscription?.cancel();
    super.onClose();
  }
}
