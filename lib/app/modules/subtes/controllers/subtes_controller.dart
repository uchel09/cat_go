import 'dart:async';
import 'package:get/get.dart';

import '../../../data/models/content_models.dart';
import '../../../data/repositories/content_repository.dart';
import '../../../data/repositories/exam_repository.dart';

class SubtesController extends GetxController {
  final ContentRepository _contentRepository;
  final ExamRepository _examRepository;

  SubtesController({
    String? initialTesId,
    String? initialTesNama,
    ContentRepository? contentRepository,
    ExamRepository? examRepository,
  })  : _contentRepository = contentRepository ?? Get.find<ContentRepository>(),
        _examRepository = examRepository ?? Get.find<ExamRepository>() {
    if (initialTesId != null) {
      tesId.value = initialTesId;
    }
    if (initialTesNama != null) {
      tesNama.value = initialTesNama;
    }
  }

  final tesId = ''.obs;
  final tesNama = ''.obs;
  final subtesList = <SubtesItem>[].obs;
  final isLoading = true.obs;

  StreamSubscription? _subtesSubscription;

  @override
  void onInit() {
    super.onInit();
    if (tesId.value.isEmpty) {
      _extractArguments();
    }
    loadSubtes();
  }

  void _extractArguments() {
    final args = Get.arguments;
    if (args is String) {
      tesId.value = args;
    } else if (args is Map && args['tesId'] != null) {
      tesId.value = args['tesId'].toString();
      if (args['tesNama'] != null) {
        tesNama.value = args['tesNama'].toString();
      }
    }
  }

  Future<void> loadSubtes() async {
    if (tesId.value.isEmpty) {
      isLoading.value = false;
      return;
    }

    // Ambil nama tes jika belum terisi
    if (tesNama.value.isEmpty) {
      final tes = await _contentRepository.getTesById(tesId.value);
      tesNama.value = tes?.nama ?? 'Daftar Subtes';
    }

    // Subskripsi reaktif
    _subtesSubscription?.cancel();
    _subtesSubscription = _contentRepository.watchSubtesByTes(tesId.value).listen((items) {
      subtesList.value = items;
      isLoading.value = false;
    });
  }

  /// Memulai pengerjaan subtes: menghitung endTime = sekarang + durasi.
  /// Timer baru berjalan setelah tombol ini diklik.
  Future<void> mulaiSubtes(SubtesItem item) async {
    final now = DateTime.now();
    final endTime = now.add(Duration(minutes: item.subtes.durasiMenit));

    await _examRepository.mulaiSubtes(item.subtes.id, endTime);

    Get.toNamed('/exam', arguments: {
      'tesId': tesId.value,
      'subtesId': item.subtes.id,
    });
  }

  /// Melanjutkan pengerjaan subtes yang sedang berjalan tanpa menghitung ulang endTime.
  void lanjutkanSubtes(SubtesItem item) {
    Get.toNamed('/exam', arguments: {
      'tesId': tesId.value,
      'subtesId': item.subtes.id,
    });
  }

  /// Melihat hasil pengerjaan subtes yang telah selesai.
  void lihatHasil(SubtesItem item) {
    Get.toNamed('/result', arguments: {
      'tesId': tesId.value,
      'subtesId': item.subtes.id,
    });
  }

  /// Melihat pembahasan subtes yang telah selesai secara langsung.
  void lihatPembahasan(SubtesItem item) {
    Get.toNamed('/review', arguments: {
      'tesId': tesId.value,
      'subtesId': item.subtes.id,
    });
  }

  /// Tombol kembali ke List Tes
  void backToListTes() {
    Get.back();
  }

  @override
  void onClose() {
    _subtesSubscription?.cancel();
    super.onClose();
  }
}
