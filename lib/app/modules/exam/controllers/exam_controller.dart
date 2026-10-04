import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/models/content_models.dart';
import '../../../data/repositories/content_repository.dart';
import '../../../data/repositories/exam_repository.dart';

class ExamController extends GetxController with WidgetsBindingObserver {
  final ContentRepository _contentRepository;
  final ExamRepository _examRepository;
  final bool enableTimer;

  ExamController({
    String? initialSubtesId,
    String? initialTesId,
    ContentRepository? contentRepository,
    ExamRepository? examRepository,
    this.enableTimer = true,
  })  : _contentRepository = contentRepository ?? Get.find<ContentRepository>(),
        _examRepository = examRepository ?? Get.find<ExamRepository>() {
    if (initialSubtesId != null) subtesId.value = initialSubtesId;
    if (initialTesId != null) tesId.value = initialTesId;
  }

  // State Identifikasi & Loading
  final subtesId = ''.obs;
  final tesId = ''.obs;
  final isLoading = true.obs;
  final isSubmitting = false.obs;
  final errorMessage = ''.obs;

  // Data Konten
  final subtes = Rxn<SubtesData>();
  final stimuliMap = <String, StimulusData>{}.obs;
  final stimulusRangeMap = <String, String>{}.obs;
  final soalList = <SoalData>[].obs;
  final currentIndex = 0.obs;

  // Progres Pengerjaan
  final jawabanMap = <String, String>{}.obs; // soalId -> opsi
  final raguSet = <String>{}.obs; // Set of soalId

  // Timer & Waktu
  final endTime = Rxn<DateTime>();
  final sisaWaktu = Duration.zero.obs;
  final isTimeUp = false.obs;
  Timer? _timer;
  bool _hasSubmitted = false;

  // Panel Wacana & Scroll Controllers
  final isStimulusCollapsed = false.obs;
  late final ScrollController stimulusScrollController;
  late final ScrollController questionScrollController;
  String? _currentStimulusId;

  // Getters Pembantu
  SoalData? get currentSoal =>
      soalList.isNotEmpty && currentIndex.value < soalList.length
          ? soalList[currentIndex.value]
          : null;

  StimulusData? get currentStimulus {
    final stimulusId = currentSoal?.stimulusId;
    if (stimulusId == null) return null;
    return stimuliMap[stimulusId];
  }

  String get currentStimulusRangeLabel {
    final stimulusId = currentSoal?.stimulusId;
    if (stimulusId == null) return 'Wacana';
    return stimulusRangeMap[stimulusId] ?? 'Wacana';
  }

  bool get isFirstQuestion => currentIndex.value == 0;
  bool get isLastQuestion =>
      soalList.isEmpty || currentIndex.value == soalList.length - 1;

  bool get isCurrentRagu {
    final s = currentSoal;
    if (s == null) return false;
    return raguSet.contains(s.id);
  }

  String? get currentAnswer {
    final s = currentSoal;
    if (s == null) return null;
    return jawabanMap[s.id];
  }

  int get totalTerjawab => jawabanMap.length;
  int get totalRagu => raguSet.length;
  int get totalKosong => soalList.length - jawabanMap.length;

  /// Status timer mendekati habis (<= 1 menit)
  bool get isTimerUrgent => sisaWaktu.value.inSeconds <= 60;

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
    stimulusScrollController = ScrollController();
    questionScrollController = ScrollController();

    if (subtesId.value.isEmpty) {
      _extractArguments();
    }
    loadData();
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

  Future<void> loadData() {
    return _loadDataFuture ??= _doLoadData();
  }

  Future<void> _doLoadData() async {
    if (subtesId.value.isEmpty) {
      errorMessage.value = 'ID Subtes tidak ditemukan.';
      isLoading.value = false;
      return;
    }

    try {
      isLoading.value = true;
      errorMessage.value = '';

      // 1. Muat konten subtes (stimulus + soal aktif terurut)
      final content = await _contentRepository.getSubtestContent(subtesId.value);
      subtes.value = content.subtes;
      if (tesId.value.isEmpty) {
        tesId.value = content.subtes.tesId;
      }
      soalList.assignAll(content.soalList);

      // Petakan stimulus berdasarkan ID
      final Map<String, StimulusData> sMap = {};
      for (final s in content.stimuli) {
        sMap[s.id] = s;
      }
      stimuliMap.assignAll(sMap);

      // Hitung otomatis rentang nomor soal untuk setiap stimulus: "Wacana untuk soal no. X - Y"
      final Map<String, String> rangeMap = {};
      for (final s in content.stimuli) {
        final matchingIndices = <int>[];
        for (int i = 0; i < content.soalList.length; i++) {
          if (content.soalList[i].stimulusId == s.id) {
            matchingIndices.add(i + 1); // 1-based index
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

      // 2. Muat progres tersimpan (jawaban, ragu, endTime)
      final progress = await _examRepository.getProgresSubtes(subtesId.value);
      if (progress != null) {
        jawabanMap.assignAll(progress.jawabanMap);
        raguSet.assignAll(progress.raguSet);

        // Jika subtes ternyata sudah selesai, batalkan pengerjaan
        if (progress.attempt.status == SubtesStatus.selesai) {
          isLoading.value = false;
          _hasSubmitted = true;
          return;
        }

        endTime.value = progress.attempt.endTime;
      }

      // Jika belum memiliki endTime di database, buat baru (sekarang + durasi)
      if (endTime.value == null) {
        final targetEnd = DateTime.now().add(Duration(minutes: content.subtes.durasiMenit));
        endTime.value = targetEnd;
        await _examRepository.mulaiSubtes(subtesId.value, targetEnd);
      }

      // 3. Periksa sisa waktu terhadap DateTime.now()
      final target = endTime.value!;
      final now = DateTime.now();
      final diff = target.difference(now);

      if (diff.isNegative || diff == Duration.zero) {
        // Waktu sudah habis saat dibuka kembali -> langsung submit
        sisaWaktu.value = Duration.zero;
        isTimeUp.value = true;
        isLoading.value = false;
        await submitSubtes(isAutoSubmit: true);
        return;
      }

      sisaWaktu.value = diff;
      _startTimer();

      if (soalList.isNotEmpty) {
        _currentStimulusId = soalList.first.stimulusId;
      }
    } catch (e) {
      errorMessage.value = 'Gagal memuat konten ujian: $e';
    } finally {
      isLoading.value = false;
    }
  }

  void _startTimer() {
    if (!enableTimer) return;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _tick());
  }

  void _tick() {
    if (_hasSubmitted || endTime.value == null) return;

    final target = endTime.value!;
    final now = DateTime.now();
    final remaining = target.difference(now);

    if (remaining.isNegative || remaining == Duration.zero) {
      sisaWaktu.value = Duration.zero;
      isTimeUp.value = true;
      _timer?.cancel();
      _handleTimeUp();
    } else {
      sisaWaktu.value = remaining;
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Hitung ulang sisa waktu secara akurat saat app kembali ke foreground
    if (state == AppLifecycleState.resumed) {
      _tick();
    }
  }

  /// Pindah ke nomor soal tertentu (0-indexed).
  void goToQuestion(int index) {
    if (index < 0 || index >= soalList.length) return;

    final targetSoal = soalList[index];
    final targetStimulusId = targetSoal.stimulusId;

    // Jika berpindah ke wacana berbeda, scroll wacana kembali ke atas.
    // Jika masih wacana yang sama, posisi scroll dipertahankan.
    if (targetStimulusId != _currentStimulusId) {
      if (stimulusScrollController.hasClients) {
        stimulusScrollController.jumpTo(0.0);
      }
      _currentStimulusId = targetStimulusId;
    }

    currentIndex.value = index;

    // Selalu reset scroll area soal ke atas saat berganti nomor soal
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

  /// Memilih opsi jawaban (A, B, C, D, E).
  /// UI di-update seketika lebih dulu, lalu disimpan ke Drift di background.
  Future<void> pilihOpsi(String opsi) async {
    final s = currentSoal;
    if (s == null || _hasSubmitted) return;

    jawabanMap[s.id] = opsi;
    await _examRepository.simpanJawaban(subtesId.value, s.id, opsi).catchError((_) {
      // Penanganan jika ada kendala penyimpanan latar belakang
    });
  }

  /// Menandai atau menghapus status ragu-ragu pada soal aktif.
  Future<void> toggleRagu() async {
    final s = currentSoal;
    if (s == null || _hasSubmitted) return;

    final isCurrentlyRagu = raguSet.contains(s.id);
    if (isCurrentlyRagu) {
      raguSet.remove(s.id);
    } else {
      raguSet.add(s.id);
    }

    await _examRepository.setRagu(subtesId.value, s.id, !isCurrentlyRagu).catchError((_) {});
  }

  /// Toggle ciutkan/perluas panel wacana.
  void toggleStimulusCollapse() {
    isStimulusCollapsed.toggle();
  }

  /// Format waktu hitung mundur MM:SS.
  String get formattedTimer {
    final d = sisaWaktu.value;
    if (d.isNegative) return '00:00';
    final totalSeconds = d.inSeconds;
    final minutes = totalSeconds ~/ 60;
    final seconds = totalSeconds % 60;
    final mm = minutes.toString().padLeft(2, '0');
    final ss = seconds.toString().padLeft(2, '0');
    return '$mm:$ss';
  }

  /// Mengirimkan dan menyelesaikan subtes secara definitif.
  Future<void> submitSubtes({bool isAutoSubmit = false}) async {
    if (_hasSubmitted) return;
    _hasSubmitted = true;
    _timer?.cancel();

    try {
      isSubmitting.value = true;
      await _examRepository.selesaikanSubtes(subtesId.value);

      if (Get.overlayContext != null) {
        if (isAutoSubmit) {
          Get.snackbar(
            'Waktu Habis',
            'Waktu pengerjaan telah berakhir. Jawaban Anda berhasil dikumpulkan.',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red.shade700,
            colorText: Colors.white,
            duration: const Duration(seconds: 3),
          );
        } else {
          Get.snackbar(
            'Ujian Selesai',
            'Jawaban Anda berhasil dikumpulkan.',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green.shade700,
            colorText: Colors.white,
            duration: const Duration(seconds: 2),
          );
        }

        // Setelah submit: buka halaman Hasil (/result)
        Get.offNamed(
          '/result',
          arguments: {
            'subtesId': subtesId.value,
            'tesId': tesId.value,
          },
        );
      }
    } catch (e) {
      errorMessage.value = 'Gagal menyimpan hasil ujian: $e';
      _hasSubmitted = false; // Boleh coba kirim ulang jika error
    } finally {
      isSubmitting.value = false;
    }
  }

  void _handleTimeUp() {
    submitSubtes(isAutoSubmit: true);
  }

  @override
  void onClose() {
    _timer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    stimulusScrollController.dispose();
    questionScrollController.dispose();
    super.onClose();
  }
}
