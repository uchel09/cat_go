import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/models/content_models.dart';
import '../../../data/repositories/content_repository.dart';
import '../../../data/repositories/exam_repository.dart';
import '../../../routes/app_pages.dart';

class ResultController extends GetxController {
  final ContentRepository _contentRepository;
  final ExamRepository _examRepository;

  ResultController({
    String? initialSubtesId,
    String? initialTesId,
    ContentRepository? contentRepository,
    ExamRepository? examRepository,
  })  : _contentRepository = contentRepository ?? Get.find<ContentRepository>(),
        _examRepository = examRepository ?? Get.find<ExamRepository>() {
    if (initialSubtesId != null) subtesId.value = initialSubtesId;
    if (initialTesId != null) tesId.value = initialTesId;
  }

  final subtesId = ''.obs;
  final tesId = ''.obs;
  final isLoading = true.obs;
  final errorMessage = ''.obs;

  final subtes = Rxn<SubtesData>();
  final attempt = Rxn<AttemptSubtesData>();

  final totalSoal = 0.obs;
  final totalBenar = 0.obs;
  final totalSalah = 0.obs;
  final totalKosong = 0.obs;
  final scorePercent = 0.obs;

  @override
  void onInit() {
    super.onInit();
    if (subtesId.value.isEmpty) {
      _extractArguments();
    }
    loadResult();
  }

  void _extractArguments() {
    final args = Get.arguments;
    if (args is String) {
      subtesId.value = args;
    } else if (args is Map) {
      if (args['subtesId'] != null) {
        subtesId.value = args['subtesId'].toString();
      }
      if (args['tesId'] != null) {
        tesId.value = args['tesId'].toString();
      }
    }
  }

  Future<void> loadResult() async {
    if (subtesId.value.isEmpty) {
      errorMessage.value = 'ID Subtes tidak ditemukan.';
      isLoading.value = false;
      return;
    }

    try {
      isLoading.value = true;
      errorMessage.value = '';

      // 1. Ambil metadata subtes
      final content = await _contentRepository.getSubtestContent(subtesId.value);
      subtes.value = content.subtes;

      // 2. Ambil snapshot attempt tersimpan
      final progress = await _examRepository.getProgresSubtes(subtesId.value);
      if (progress != null) {
        attempt.value = progress.attempt;

        final total = progress.attempt.totalSoal ?? content.soalList.length;
        final benar = progress.attempt.benar ?? 0;
        final salah = progress.attempt.salah ?? 0;
        final kosong = progress.attempt.kosong ?? 0;

        totalSoal.value = total;
        totalBenar.value = benar;
        totalSalah.value = salah;
        totalKosong.value = kosong;

        if (total > 0) {
          scorePercent.value = ((benar / total) * 100).round();
        } else {
          scorePercent.value = 0;
        }
      } else {
        errorMessage.value = 'Data hasil ujian belum tersimpan.';
      }
    } catch (e) {
      errorMessage.value = 'Gagal memuat hasil ujian: $e';
    } finally {
      isLoading.value = false;
    }
  }

  /// Navigasi ke halaman pembahasan soal
  void lihatPembahasan() {
    Get.toNamed(
      Routes.REVIEW,
      arguments: {
        'subtesId': subtesId.value,
        'tesId': tesId.value,
      },
    );
  }

  /// Kembali ke daftar tes / subtes
  void kembaliKeDaftarTes() {
    // Kembali hingga rute subtes atau rute awal
    final ctx = Get.context;
    if (ctx != null && Navigator.canPop(ctx)) {
      Get.back();
    } else {
      Get.offAllNamed(Routes.HOME);
    }
  }
}
