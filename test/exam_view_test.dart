import 'package:cat_go/app/data/local/app_database.dart';
import 'package:cat_go/app/data/repositories/content_repository.dart';
import 'package:cat_go/app/data/repositories/content_repository_drift.dart';
import 'package:cat_go/app/data/repositories/exam_repository.dart';
import 'package:cat_go/app/data/repositories/exam_repository_drift.dart';
import 'package:cat_go/app/modules/exam/controllers/exam_controller.dart';
import 'package:cat_go/app/modules/exam/views/exam_view.dart';
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

    // Siapkan data subtes & stimulus
    await db.into(db.kategori).insert(
      KategoriCompanion.insert(id: 'k1', nama: 'TBS', urutan: 1),
    );
    await db.into(db.tes).insert(
      TesCompanion.insert(id: 't1', kategoriId: 'k1', nama: 'Simulasi TBS 1', urutan: 1, packId: 'p1'),
    );
    await db.into(db.subtes).insert(
      SubtesCompanion.insert(id: 'sub-1', tesId: 't1', nama: 'Penalaran Verbal', durasiMenit: 30, urutan: 1),
    );

    await db.into(db.stimulus).insert(
      StimulusCompanion.insert(
        id: 's1',
        subtesId: 'sub-1',
        judul: const drift.Value('Teks Bacaan 1'),
        isi: 'Ini adalah paragraf stimulus panjang untuk soal no 1 dan 2.',
        urutan: 1,
      ),
    );

    await db.into(db.soal).insert(
      SoalCompanion.insert(
        id: 'q1',
        subtesId: 'sub-1',
        stimulusId: const drift.Value('s1'),
        urutan: 1,
        teks: 'Pertanyaan pertama wacana?',
        opsi: {'A': 'Pilihan A', 'B': 'Pilihan B'},
        jawabanBenar: 'A',
        aktif: const drift.Value(true),
        packId: 'p1',
      ),
    );
    await db.into(db.soal).insert(
      SoalCompanion.insert(
        id: 'q2',
        subtesId: 'sub-1',
        stimulusId: const drift.Value('s1'),
        urutan: 2,
        teks: 'Pertanyaan kedua wacana?',
        opsi: {'A': 'Pilihan A2', 'B': 'Pilihan B2'},
        jawabanBenar: 'B',
        aktif: const drift.Value(true),
        packId: 'p1',
      ),
    );
    await db.into(db.soal).insert(
      SoalCompanion.insert(
        id: 'q3',
        subtesId: 'sub-1',
        urutan: 3,
        teks: 'Pertanyaan ketiga mandiri?',
        opsi: {'A': 'Pilihan A3', 'B': 'Pilihan B3'},
        jawabanBenar: 'A',
        aktif: const drift.Value(true),
        packId: 'p1',
      ),
    );
  });

  tearDown(() async {
    if (Get.isRegistered<ExamController>()) {
      Get.delete<ExamController>(force: true);
    }
    await db.close();
    Get.reset();
  });

  testWidgets('1. ExamView menampilkan AppBar dengan nama subtes, timer, dan wacana otomatis', (tester) async {
    Get.put(ExamController(initialSubtesId: 'sub-1', initialTesId: 't1', enableTimer: false));

    await tester.pumpWidget(
      const GetMaterialApp(
        home: ExamView(),
      ),
    );
    await tester.pump(const Duration(milliseconds: 100));
    await tester.pump(const Duration(milliseconds: 100));

    // Verifikasi AppBar
    expect(find.text('Penalaran Verbal'), findsOneWidget);
    expect(find.text('Selesai'), findsOneWidget);

    // Verifikasi StimulusPanel
    expect(find.text('Wacana untuk soal no. 1 - 2'), findsOneWidget);
    expect(find.text('Teks Bacaan 1'), findsOneWidget);
    expect(find.text('Ini adalah paragraf stimulus panjang untuk soal no 1 dan 2.'), findsOneWidget);

    // Verifikasi Soal & Opsi
    expect(find.text('Soal 1 dari 3'), findsOneWidget);
    expect(find.text('Pertanyaan pertama wacana?'), findsOneWidget);
    expect(find.text('Pilihan A'), findsOneWidget);
    expect(find.text('Pilihan B'), findsOneWidget);

    // Verifikasi tombol navigasi bawah
    expect(find.text('Sebelumnya'), findsOneWidget);
    expect(find.text('Ragu'), findsOneWidget);
    expect(find.text('Berikutnya'), findsOneWidget);
  });

  testWidgets('2. Memilih opsi dan menandai ragu-ragu meng-update UI seketika', (tester) async {
    final controller = Get.put(ExamController(initialSubtesId: 'sub-1', initialTesId: 't1', enableTimer: false));

    await tester.pumpWidget(
      const GetMaterialApp(
        home: ExamView(),
      ),
    );
    await tester.pump(const Duration(milliseconds: 100));
    await tester.pump(const Duration(milliseconds: 100));

    // Klik opsi A
    await tester.tap(find.text('Pilihan A'));
    await tester.pump();

    expect(controller.currentAnswer, 'A');

    // Klik tombol Ragu
    await tester.tap(find.text('Ragu'));
    await tester.pump();

    expect(controller.isCurrentRagu, isTrue);
    expect(find.text('Ragu-ragu'), findsOneWidget); // Badge status ragu di header nomor soal
  });

  testWidgets('3. Navigasi soal berpindah ke soal 3 tanpa wacana dan wacana menghilang', (tester) async {
    Get.put(ExamController(initialSubtesId: 'sub-1', initialTesId: 't1', enableTimer: false));

    await tester.pumpWidget(
      const GetMaterialApp(
        home: ExamView(),
      ),
    );
    await tester.pump(const Duration(milliseconds: 100));
    await tester.pump(const Duration(milliseconds: 100));

    // Ke soal 2
    await tester.tap(find.text('Berikutnya'));
    await tester.pump(const Duration(milliseconds: 50));
    expect(find.text('Soal 2 dari 3'), findsOneWidget);
    expect(find.text('Teks Bacaan 1'), findsOneWidget); // Wacana tetap ada

    // Ke soal 3
    await tester.tap(find.text('Berikutnya'));
    await tester.pump(const Duration(milliseconds: 50));
    expect(find.text('Soal 3 dari 3'), findsOneWidget);
    expect(find.text('Pertanyaan ketiga mandiri?'), findsOneWidget);

    // Wacana harus hilang karena soal 3 tidak punya stimulus
    expect(find.text('Teks Bacaan 1'), findsNothing);
  });

  testWidgets('4. Tombol Daftar Soal membuka BottomSheet dengan GridView nomor soal', (tester) async {
    Get.put(ExamController(initialSubtesId: 'sub-1', initialTesId: 't1', enableTimer: false));

    await tester.pumpWidget(
      const GetMaterialApp(
        home: ExamView(),
      ),
    );
    await tester.pump(const Duration(milliseconds: 100));
    await tester.pump(const Duration(milliseconds: 100));

    // Buka BottomSheet Daftar Soal
    await tester.tap(find.byIcon(Icons.grid_view_rounded));
    await tester.pumpAndSettle();

    expect(find.text('Daftar Nomor Soal'), findsOneWidget);
    expect(find.text('Sudah Dijawab'), findsOneWidget);
    expect(find.text('Belum Dijawab'), findsOneWidget);
    expect(find.text('Ragu-ragu'), findsOneWidget);

    // Ketuk nomor 3 untuk lompat ke nomor 3
    await tester.tap(find.text('3'));
    await tester.pumpAndSettle();

    expect(find.text('Soal 3 dari 3'), findsOneWidget);
  });

  testWidgets('5. Tombol Selesai menampilkan dialog konfirmasi dengan ringkasan progres', (tester) async {
    Get.put(ExamController(initialSubtesId: 'sub-1', initialTesId: 't1', enableTimer: false));

    await tester.pumpWidget(
      const GetMaterialApp(
        home: ExamView(),
      ),
    );
    await tester.pump(const Duration(milliseconds: 100));
    await tester.pump(const Duration(milliseconds: 100));

    // Klik tombol Selesai di AppBar
    await tester.tap(find.text('Selesai'));
    await tester.pumpAndSettle();

    expect(find.text('Kumpulkan Ujian?'), findsOneWidget);
    expect(find.text('Terjawab'), findsOneWidget);
    expect(find.text('Ragu-ragu'), findsOneWidget);
    expect(find.text('Belum Dijawab'), findsOneWidget);
    expect(find.text('Ya, Selesaikan'), findsOneWidget);
  });

  testWidgets('6. Cegat tombol back dengan dialog konfirmasi keluar', (tester) async {
    Get.put(ExamController(initialSubtesId: 'sub-1', initialTesId: 't1', enableTimer: false));

    await tester.pumpWidget(
      const GetMaterialApp(
        home: ExamView(),
      ),
    );
    await tester.pump(const Duration(milliseconds: 100));
    await tester.pump(const Duration(milliseconds: 100));

    // Klik tombol back di AppBar
    await tester.tap(find.byTooltip('Kembali'));
    await tester.pumpAndSettle();

    expect(find.text('Tinggalkan Ujian?'), findsOneWidget);
    expect(find.text('Tetap di Sini'), findsOneWidget);
    expect(find.text('Keluar'), findsOneWidget);
  });

  testWidgets('7. Tampilan pada layar sempit 360px responsif tanpa overflow dan label tombol ringkas', (tester) async {
    tester.view.physicalSize = const Size(360, 640);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    Get.put(ExamController(initialSubtesId: 'sub-1', initialTesId: 't1', enableTimer: false));

    await tester.pumpWidget(
      const GetMaterialApp(
        home: ExamView(),
      ),
    );
    await tester.pump(const Duration(milliseconds: 100));
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.text('Prev'), findsOneWidget);
    expect(find.text('Next'), findsOneWidget);
    expect(find.text('Ragu'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
