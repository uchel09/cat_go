import 'package:cat_go/app/data/local/app_database.dart';
import 'package:cat_go/app/data/local/tables/attempt_subtes_table.dart';
import 'package:cat_go/app/data/repositories/content_repository.dart';
import 'package:cat_go/app/data/repositories/content_repository_drift.dart';
import 'package:cat_go/app/data/repositories/exam_repository.dart';
import 'package:cat_go/app/data/repositories/exam_repository_drift.dart';
import 'package:cat_go/app/modules/exam/controllers/exam_controller.dart';
import 'package:drift/drift.dart' as drift;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late AppDatabase db;
  late ContentRepository contentRepo;
  late ExamRepository examRepo;

  setUp(() async {
    Get.reset();
    db = AppDatabase(NativeDatabase.memory());
    contentRepo = ContentRepositoryDrift(db);
    examRepo = ExamRepositoryDrift(db);

    Get.put<AppDatabase>(db);
    Get.put<ContentRepository>(contentRepo);
    Get.put<ExamRepository>(examRepo);

    // Siapkan data tes & subtes
    await db.into(db.kategori).insert(
      KategoriCompanion.insert(id: 'k1', nama: 'TBS', urutan: 1),
    );
    await db.into(db.tes).insert(
      TesCompanion.insert(id: 't1', kategoriId: 'k1', nama: 'Simulasi 1', urutan: 1, packId: 'p1'),
    );
    await db.into(db.subtes).insert(
      SubtesCompanion.insert(id: 'sub-pm', tesId: 't1', nama: 'Pemecahan Masalah', durasiMenit: 15, urutan: 1),
    );

    // Stimulus wacana
    await db.into(db.stimulus).insert(
      StimulusCompanion.insert(
        id: 'stim-1',
        subtesId: 'sub-pm',
        judul: const drift.Value('Studi Kasus Lingkungan'),
        isi: 'Paragraf 1 mengenai lingkungan hidup.\n\nParagraf 2 mengenai ekosistem.',
        urutan: 1,
      ),
    );

    // Soal 1 & 2 memakai stimulus-1, Soal 3 berdiri sendiri
    await db.into(db.soal).insert(
      SoalCompanion.insert(
        id: 'q1',
        subtesId: 'sub-pm',
        stimulusId: const drift.Value('stim-1'),
        urutan: 1,
        teks: 'Berdasarkan wacana, apa faktor utama?',
        opsi: {'A': 'Emisi gas', 'B': 'Limbah plastik', 'C': 'Deforestasi'},
        jawabanBenar: 'A',
        aktif: const drift.Value(true),
        packId: 'p1',
      ),
    );
    await db.into(db.soal).insert(
      SoalCompanion.insert(
        id: 'q2',
        subtesId: 'sub-pm',
        stimulusId: const drift.Value('stim-1'),
        urutan: 2,
        teks: 'Solusi yang dianjurkan dalam wacana adalah...',
        opsi: {'A': 'Penghijauan', 'B': 'Pengurangan plastik', 'C': 'Semua benar'},
        jawabanBenar: 'C',
        aktif: const drift.Value(true),
        packId: 'p1',
      ),
    );
    await db.into(db.soal).insert(
      SoalCompanion.insert(
        id: 'q3',
        subtesId: 'sub-pm',
        urutan: 3,
        teks: 'Soal tanpa stimulus: 2 + 2 = ?',
        opsi: {'A': '3', 'B': '4', 'C': '5'},
        jawabanBenar: 'B',
        aktif: const drift.Value(true),
        packId: 'p1',
      ),
    );
  });

  tearDown(() async {
    await db.close();
    Get.reset();
  });

  test('1. Inisialisasi ExamController memuat konten, stimulus, dan hitung rentang wacana otomatis', () async {
    final controller = Get.put(
      ExamController(initialSubtesId: 'sub-pm', initialTesId: 't1'),
    );
    await controller.loadData();

    expect(controller.subtes.value?.nama, 'Pemecahan Masalah');
    expect(controller.soalList.length, 3);
    expect(controller.stimuliMap.containsKey('stim-1'), isTrue);

    // Rentang wacana otomatis dihitung: soal no. 1 - 2
    expect(controller.stimulusRangeMap['stim-1'], 'Wacana untuk soal no. 1 - 2');

    // Timer terinisialisasi dan sisa waktu positif
    expect(controller.endTime.value, isNotNull);
    expect(controller.sisaWaktu.value.inMinutes, greaterThanOrEqualTo(14));
  });

  test('2. Pilih opsi jawaban meng-update UI seketika dan menyimpan ke Drift di latar belakang', () async {
    final controller = Get.put(
      ExamController(initialSubtesId: 'sub-pm', initialTesId: 't1'),
    );
    await controller.loadData();

    expect(controller.currentAnswer, isNull);

    // Pilih opsi A untuk soal no. 1
    await controller.pilihOpsi('A');
    expect(controller.currentAnswer, 'A');
    expect(controller.totalTerjawab, 1);

    // Verifikasi tersimpan di database Drift
    final progress = await examRepo.getProgresSubtes('sub-pm');
    expect(progress?.jawabanMap['q1'], 'A');

    // Ganti jawaban ke B
    await controller.pilihOpsi('B');
    expect(controller.currentAnswer, 'B');

    final progressUpdated = await examRepo.getProgresSubtes('sub-pm');
    expect(progressUpdated?.jawabanMap['q1'], 'B');
  });

  test('3. Toggle ragu-ragu memperbarui state dan database', () async {
    final controller = Get.put(
      ExamController(initialSubtesId: 'sub-pm', initialTesId: 't1'),
    );
    await controller.loadData();

    expect(controller.isCurrentRagu, isFalse);

    // Tandai ragu
    await controller.toggleRagu();
    expect(controller.isCurrentRagu, isTrue);
    expect(controller.totalRagu, 1);

    var progress = await examRepo.getProgresSubtes('sub-pm');
    expect(progress?.raguSet.contains('q1'), isTrue);

    // Hapus tanda ragu
    await controller.toggleRagu();
    expect(controller.isCurrentRagu, isFalse);
    expect(controller.totalRagu, 0);

    progress = await examRepo.getProgresSubtes('sub-pm');
    expect(progress?.raguSet.contains('q1'), isFalse);
  });

  test('4. Navigasi soal: Next, Prev, dan perpindahan stimulus', () async {
    final controller = Get.put(
      ExamController(initialSubtesId: 'sub-pm', initialTesId: 't1'),
    );
    await controller.loadData();

    expect(controller.currentIndex.value, 0);
    expect(controller.isFirstQuestion, isTrue);
    expect(controller.currentStimulus, isNotNull);

    // Next ke soal 2 (masih wacana stim-1)
    controller.nextQuestion();
    expect(controller.currentIndex.value, 1);
    expect(controller.currentStimulus?.id, 'stim-1');

    // Next ke soal 3 (tanpa wacana)
    controller.nextQuestion();
    expect(controller.currentIndex.value, 2);
    expect(controller.currentStimulus, isNull);
    expect(controller.isLastQuestion, isTrue);

    // Prev kembali ke soal 2
    controller.prevQuestion();
    expect(controller.currentIndex.value, 1);
    expect(controller.currentStimulus?.id, 'stim-1');
  });

  test('5. Submit ujian menyelesaikan attempt dan menghitung snapshot skor di Drift', () async {
    final controller = Get.put(
      ExamController(initialSubtesId: 'sub-pm', initialTesId: 't1'),
    );
    await controller.loadData();

    // Jawab soal 1 Benar ('A'), soal 2 Salah ('A' kunci 'C'), soal 3 Kosong
    controller.goToQuestion(0);
    await controller.pilihOpsi('A');

    controller.goToQuestion(1);
    await controller.pilihOpsi('A');

    await controller.submitSubtes();

    // Verifikasi di database Drift
    final progress = await examRepo.getProgresSubtes('sub-pm');
    expect(progress?.attempt.status, SubtesStatus.selesai);
    expect(progress?.attempt.benar, 1);
    expect(progress?.attempt.salah, 1);
    expect(progress?.attempt.kosong, 1);
    expect(progress?.attempt.totalSoal, 3);
  });

  test('6. Jika dibuka kembali saat batas waktu telah habis, langsung otomatis submit', () async {
    // Set endTime di masa lalu (5 menit lalu)
    final pastEndTime = DateTime.now().subtract(const Duration(minutes: 5));
    await examRepo.mulaiSubtes('sub-pm', pastEndTime);

    final controller = Get.put(
      ExamController(initialSubtesId: 'sub-pm', initialTesId: 't1'),
    );
    await controller.loadData();

    // Harus terdeteksi waktu habis dan tersubmit
    expect(controller.isTimeUp.value, isTrue);
    expect(controller.sisaWaktu.value, Duration.zero);

    final progress = await examRepo.getProgresSubtes('sub-pm');
    expect(progress?.attempt.status, SubtesStatus.selesai);
  });
}
