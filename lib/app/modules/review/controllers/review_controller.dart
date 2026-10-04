import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/models/content_models.dart';
import '../../../data/repositories/content_repository.dart';
import '../../../data/repositories/exam_repository.dart';
import '../../../routes/app_pages.dart';

/// Status evaluasi soal dalam lembar pembahasan
enum ReviewItemStatus { benar, salah, kosong }

class ReviewController extends GetxController {
  final ContentRepository _contentRepository;
  final ExamRepository _examRepository;

  ReviewController({
    String? initialSubtesId,
    String? initialTesId,
    ContentRepository? contentRepository,
    ExamRepository? examRepository,
  }) : _contentRepository = contentRepository ?? Get.find<ContentRepository>(),
       _examRepository = examRepository ?? Get.find<ExamRepository>() {
    if (initialSubtesId != null) subtesId.value = initialSubtesId;
    if (initialTesId != null) tesId.value = initialTesId;
  }

  // Identifikasi & Loading State
  final subtesId = ''.obs;
  final tesId = ''.obs;
  final isLoading = true.obs;
  final errorMessage = ''.obs;

  // Data Konten
  final subtes = Rxn<SubtesData>();
  final stimuliMap = <String, StimulusData>{}.obs;
  final stimulusRangeMap = <String, String>{}.obs;
  final soalList = <SoalData>[].obs;
  final currentIndex = 0.obs;

  // Data Progres & Evaluasi
  final jawabanMap = <String, String>{}.obs; // soalId -> opsi dipilih
  final raguSet = <String>{}.obs;
  final attempt = Rxn<AttemptSubtesData>();

  // Panel Wacana & Scroll Controller
  final isStimulusCollapsed = false.obs;
  late final ScrollController stimulusScrollController;
  late final ScrollController questionScrollController;
  String? _currentStimulusId;

  // Getters Soal Aktif
  SoalData? get currentSoal =>
      soalList.isNotEmpty && currentIndex.value < soalList.length
      ? soalList[currentIndex.value]
      : null;

  StimulusData? get currentStimulus {
    final sId = currentSoal?.stimulusId;
    if (sId == null) return null;
    return stimuliMap[sId];
  }

  String get currentStimulusRangeLabel {
    final sId = currentSoal?.stimulusId;
    if (sId == null) return 'Wacana';
    return stimulusRangeMap[sId] ?? 'Wacana';
  }

  String? get currentSoalUserAnswer {
    final s = currentSoal;
    if (s == null) return null;
    return jawabanMap[s.id];
  }

  ReviewItemStatus get currentSoalStatus {
    final s = currentSoal;
    if (s == null) return ReviewItemStatus.kosong;
    return getSoalStatus(s);
  }

  bool get isFirstQuestion => currentIndex.value == 0;
  bool get isLastQuestion =>
      soalList.isEmpty || currentIndex.value == soalList.length - 1;

  // Getters Ringkasan Evaluasi
  int get totalBenar =>
      soalList.where((s) => getSoalStatus(s) == ReviewItemStatus.benar).length;
  int get totalSalah =>
      soalList.where((s) => getSoalStatus(s) == ReviewItemStatus.salah).length;
  int get totalKosong =>
      soalList.where((s) => getSoalStatus(s) == ReviewItemStatus.kosong).length;

  @override
  void onInit() {
    super.onInit();
    stimulusScrollController = ScrollController();
    questionScrollController = ScrollController();

    if (subtesId.value.isEmpty) {
      _extractArguments();
    }
    loadReviewData();
  }

  @override
  void onClose() {
    stimulusScrollController.dispose();
    questionScrollController.dispose();
    super.onClose();
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

  Future<void>? _loadDataFuture;

  Future<void> loadReviewData() {
    return _loadDataFuture ??= _doLoadReviewData();
  }

  Future<void> _doLoadReviewData() async {
    if (subtesId.value.isEmpty) {
      errorMessage.value = 'ID Subtes tidak ditemukan.';
      isLoading.value = false;
      return;
    }

    try {
      isLoading.value = true;
      errorMessage.value = '';

      // 1. Muat konten subtes (stimulus + soal aktif terurut)
      final content = await _contentRepository.getSubtestContent(
        subtesId.value,
      );
      subtes.value = content.subtes;
      soalList.assignAll(content.soalList);

      // Petakan stimulus berdasarkan ID
      final Map<String, StimulusData> sMap = {};
      for (final s in content.stimuli) {
        sMap[s.id] = s;
      }
      stimuliMap.assignAll(sMap);

      // Hitung otomatis rentang nomor soal untuk setiap stimulus
      final Map<String, String> rangeMap = {};
      for (final s in content.stimuli) {
        final matchingIndices = <int>[];
        for (int i = 0; i < content.soalList.length; i++) {
          if (content.soalList[i].stimulusId == s.id) {
            matchingIndices.add(i + 1);
          }
        }
        if (matchingIndices.isEmpty) {
          rangeMap[s.id] = 'Wacana';
        } else if (matchingIndices.length == 1) {
          rangeMap[s.id] = 'Wacana untuk soal no. ${matchingIndices.first}';
        } else {
          rangeMap[s.id] =
              'Wacana untuk soal no. ${matchingIndices.first} - ${matchingIndices.last}';
        }
      }
      stimulusRangeMap.assignAll(rangeMap);

      // 2. Muat progres tersimpan (jawaban user, attempt)
      final progress = await _examRepository.getProgresSubtes(subtesId.value);
      if (progress != null) {
        attempt.value = progress.attempt;
        jawabanMap.assignAll(progress.jawabanMap);
        raguSet.assignAll(progress.raguSet);
      }

      if (soalList.isNotEmpty) {
        _currentStimulusId = soalList.first.stimulusId;
      }
    } catch (e) {
      errorMessage.value = 'Gagal memuat pembahasan: $e';
    } finally {
      isLoading.value = false;
    }
  }

  /// Menentukan status jawaban untuk satu soal (benar / salah / kosong)
  ReviewItemStatus getSoalStatus(SoalData soal) {
    final userAns = jawabanMap[soal.id];
    if (userAns == null || userAns.trim().isEmpty) {
      return ReviewItemStatus.kosong;
    }
    if (userAns.trim().toUpperCase() ==
        soal.jawabanBenar.trim().toUpperCase()) {
      return ReviewItemStatus.benar;
    }
    return ReviewItemStatus.salah;
  }

  ReviewItemStatus getStatusAtIndex(int index) {
    if (index < 0 || index >= soalList.length) {
      return ReviewItemStatus.kosong;
    }
    return getSoalStatus(soalList[index]);
  }

  /// Pindah ke nomor soal tertentu
  void goToQuestion(int index) {
    if (index < 0 || index >= soalList.length) return;

    final targetSoal = soalList[index];
    final targetStimulusId = targetSoal.stimulusId;

    // Reset scroll wacana hanya jika berpindah ke stimulus yang berbeda
    if (targetStimulusId != _currentStimulusId) {
      _currentStimulusId = targetStimulusId;
      if (stimulusScrollController.hasClients) {
        stimulusScrollController.jumpTo(0.0);
      }
    }

    currentIndex.value = index;

    // Reset scroll area soal ke atas
    if (questionScrollController.hasClients) {
      questionScrollController.jumpTo(0.0);
    }
  }

  void prevQuestion() {
    goToQuestion(currentIndex.value - 1);
  }

  void nextQuestion() {
    goToQuestion(currentIndex.value + 1);
  }

  void toggleStimulusCollapse() {
    isStimulusCollapsed.toggle();
  }

  void kembali() {
    final ctx = Get.context;
    if (ctx != null && Navigator.canPop(ctx)) {
      Get.back();
    } else {
      Get.offAllNamed(Routes.HOME);
    }
  }
}
