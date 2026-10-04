import 'package:cat_go/app/data/local/app_database.dart';
import 'package:cat_go/app/data/repositories/content_repository.dart';
import 'package:cat_go/app/data/repositories/content_repository_drift.dart';
import 'package:cat_go/app/data/repositories/exam_repository.dart';
import 'package:cat_go/app/data/repositories/exam_repository_drift.dart';
import 'package:cat_go/app/modules/review/controllers/review_controller.dart';
import 'package:cat_go/app/modules/review/views/review_view.dart';
import 'package:drift/drift.dart' as drift;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

void main() {
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

    // Kategori, Tes, Subtes
    await db.into(db.kategori).insert(
      KategoriCompanion.insert(id: 'k1', nama: 'TBS', urutan: 1),
    );
    await db.into(db.tes).insert(
      TesCompanion.insert(id: 't1', kategoriId: 'k1', nama: 'Simulasi TBS 1', urutan: 1, packId: 'p1'),
    );
    await db.into(db.subtes).insert(
      SubtesCompanion.insert(id: 'sub-rev', tesId: 't1', nama: 'Pemahaman Bacaan', durasiMenit: 15, urutan: 1),
    );

    // Stimulus wacana
    await db.into(db.stimulus).insert(
      StimulusCompanion.insert(
        id: 'stim-rev',
        subtesId: 'sub-rev',
        judul: const drift.Value('Artikel Sains'),
        isi: 'Wacana penelitian tentang energi terbarukan di Indonesia.',
        urutan: 1,
      ),
    );

    // 3 soal: q1 & q2 berwacana, q3 berdiri sendiri
    await db.into(db.soal).insert(
      SoalCompanion.insert(
        id: 'q1',
        subtesId: 'sub-rev',
        stimulusId: const drift.Value('stim-rev'),
        urutan: 1,
        teks: 'Apa topik utama paragraf pertama?',
        opsi: {'A': 'Energi surya', 'B': 'Batu bara', 'C': 'Minyak bumi'},
        jawabanBenar: 'A',
        pembahasan: const drift.Value('Paragraf pertama berfokus pada potensi energi surya.'),
        aktif: const drift.Value(true),
        packId: 'p1',
      ),
    );
    await db.into(db.soal).insert(
      SoalCompanion.insert(
        id: 'q2',
        subtesId: 'sub-rev',
        stimulusId: const drift.Value('stim-rev'),
        urutan: 2,
        teks: 'Kesimpulan hasil studi adalah...',
        opsi: {'A': 'Tidak efisien', 'B': 'Sangat ramah lingkungan', 'C': 'Biaya mahal'},
        jawabanBenar: 'B',
        pembahasan: const drift.Value('Studi menyimpulkan dampak ramah lingkungan yang tinggi.'),
        aktif: const drift.Value(true),
        packId: 'p1',
      ),
    );
    await db.into(db.soal).insert(
      SoalCompanion.insert(
        id: 'q3',
        subtesId: 'sub-rev',
        urutan: 3,
        teks: 'Sinonim kata mandiri adalah...',
        opsi: {'A': 'Bergantung', 'B': 'Berdiri sendiri', 'C': 'Bersama-sama'},
        jawabanBenar: 'B',
        pembahasan: const drift.Value('Mandiri bermakna mampu berdiri sendiri tanpa ketergantungan.'),
        aktif: const drift.Value(true),
        packId: 'p1',
      ),
    );

    // Jawaban:
    // q1: 'A' (Benar)
    // q2: 'C' (Salah, kunci 'B')
    // q3: kosong (Tidak dijawab, kunci 'B')
    final endTime = DateTime.now().add(const Duration(minutes: 15));
    await examRepo.mulaiSubtes('sub-rev', endTime);
    await examRepo.simpanJawaban('sub-rev', 'q1', 'A');
    await examRepo.simpanJawaban('sub-rev', 'q2', 'C');
    await examRepo.selesaikanSubtes('sub-rev');
  });

  tearDown(() async {
    if (Get.isRegistered<ReviewController>()) {
      Get.delete<ReviewController>(force: true);
    }
    await db.close();
    Get.reset();
  });

  test('1. ReviewController memuat konten, progres, status evaluasi, dan navigasi soal', () async {
    final controller = Get.put(
      ReviewController(initialSubtesId: 'sub-rev', initialTesId: 't1'),
    );

    await controller.loadReviewData();

    expect(controller.isLoading.value, isFalse);
    expect(controller.errorMessage.value, isEmpty);
    expect(controller.soalList.length, equals(3));
    expect(controller.stimuliMap.containsKey('stim-rev'), isTrue);
    expect(controller.stimulusRangeMap['stim-rev'], equals('Wacana untuk soal no. 1 - 2'));

    // Status evaluasi
    expect(controller.getSoalStatus(controller.soalList[0]), equals(ReviewItemStatus.benar));
    expect(controller.getSoalStatus(controller.soalList[1]), equals(ReviewItemStatus.salah));
    expect(controller.getSoalStatus(controller.soalList[2]), equals(ReviewItemStatus.kosong));

    // Ringkasan
    expect(controller.totalBenar, equals(1));
    expect(controller.totalSalah, equals(1));
    expect(controller.totalKosong, equals(1));

    // Navigasi
    expect(controller.currentIndex.value, equals(0));
    expect(controller.isFirstQuestion, isTrue);

    controller.nextQuestion();
    expect(controller.currentIndex.value, equals(1));
    expect(controller.currentSoalStatus, equals(ReviewItemStatus.salah));

    controller.nextQuestion();
    expect(controller.currentIndex.value, equals(2));
    expect(controller.isLastQuestion, isTrue);
    expect(controller.currentStimulus, isNull);

    controller.prevQuestion();
    expect(controller.currentIndex.value, equals(1));
  });

  testWidgets('2. ReviewView menampilkan evaluasi soal, opsi read-only, kunci jawaban, dan pembahasan', (tester) async {
    final controller = Get.put(
      ReviewController(initialSubtesId: 'sub-rev', initialTesId: 't1'),
    );

    await tester.pumpWidget(
      const GetMaterialApp(
        home: ReviewView(),
      ),
    );
    await tester.pump(const Duration(milliseconds: 100));
    await tester.pump(const Duration(milliseconds: 100));

    // Verifikasi AppBar
    expect(find.text('Pembahasan'), findsWidgets);
    expect(find.text('Pemahaman Bacaan'), findsOneWidget);

    // Soal 1 (BENAR)
    expect(find.text('Soal 1 dari 3'), findsOneWidget);
    expect(find.text('BENAR'), findsOneWidget);
    expect(find.text('Apa topik utama paragraf pertama?'), findsOneWidget);
    expect(find.text('Jawaban Anda (Benar)'), findsOneWidget);
    expect(find.text('Pembahasan'), findsWidgets);
    expect(find.text('Paragraf pertama berfokus pada potensi energi surya.'), findsOneWidget);

    // Stimulus wacana muncul untuk soal 1
    expect(find.text('Wacana untuk soal no. 1 - 2'), findsOneWidget);
    expect(find.text('Artikel Sains'), findsOneWidget);

    // Pindah ke Soal 2 (SALAH)
    await tester.tap(find.text('Berikutnya'));
    await tester.pumpAndSettle();

    expect(find.text('Soal 2 dari 3'), findsOneWidget);
    expect(find.text('SALAH'), findsOneWidget);
    expect(find.text('Jawaban Anda (Salah)'), findsOneWidget); // Opsi C
    expect(find.text('Kunci Jawaban'), findsOneWidget); // Opsi B
    expect(find.text('Studi menyimpulkan dampak ramah lingkungan yang tinggi.'), findsOneWidget);

    // Pindah ke Soal 3 (KOSONG / TIDAK DIJAWAB)
    await tester.tap(find.text('Berikutnya'));
    await tester.pumpAndSettle();

    expect(find.text('Soal 3 dari 3'), findsOneWidget);
    expect(find.text('TIDAK DIJAWAB'), findsOneWidget);
    expect(find.text('Kunci Jawaban'), findsOneWidget); // Opsi B
    expect(find.text('Mandiri bermakna mampu berdiri sendiri tanpa ketergantungan.'), findsOneWidget);
    // Soal 3 tidak punya stimulus
    expect(find.text('Wacana untuk soal no. 1 - 2'), findsNothing);

    // Buka BottomSheet Daftar Soal
    await tester.tap(find.byIcon(Icons.grid_view_rounded));
    await tester.pumpAndSettle();

    expect(find.text('Daftar Nomor Soal'), findsOneWidget);
    expect(find.text('Benar'), findsOneWidget);
    expect(find.text('Salah'), findsOneWidget);
    expect(find.text('Kosong'), findsOneWidget);

    // Lompat ke soal 1 dari bottom sheet
    await tester.tap(find.descendant(of: find.byType(GridView), matching: find.text('1')));
    await tester.pumpAndSettle();

    expect(controller.currentIndex.value, equals(0));
    expect(find.text('Soal 1 dari 3'), findsOneWidget);
  });
}
