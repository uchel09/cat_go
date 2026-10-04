import 'package:cat_go/app/data/local/app_database.dart';
import 'package:cat_go/app/data/repositories/content_repository.dart';
import 'package:cat_go/app/data/repositories/content_repository_drift.dart';
import 'package:cat_go/app/data/repositories/exam_repository.dart';
import 'package:cat_go/app/data/repositories/exam_repository_drift.dart';
import 'package:cat_go/app/modules/result/controllers/result_controller.dart';
import 'package:cat_go/app/modules/result/views/result_view.dart';
import 'package:drift/drift.dart' as drift;
import 'package:drift/native.dart';
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

    // Siapkan data subtes & soal
    await db
        .into(db.kategori)
        .insert(KategoriCompanion.insert(id: 'k1', nama: 'TBS', urutan: 1));
    await db
        .into(db.tes)
        .insert(
          TesCompanion.insert(
            id: 't1',
            kategoriId: 'k1',
            nama: 'Simulasi TBS 1',
            urutan: 1,
            packId: 'p1',
          ),
        );
    await db
        .into(db.subtes)
        .insert(
          SubtesCompanion.insert(
            id: 'sub-res',
            tesId: 't1',
            nama: 'Penalaran Logis',
            durasiMenit: 20,
            urutan: 1,
          ),
        );

    // 3 soal
    await db
        .into(db.soal)
        .insert(
          SoalCompanion.insert(
            id: 'q1',
            subtesId: 'sub-res',
            urutan: 1,
            teks: 'Soal 1',
            opsi: {'A': 'Opt A', 'B': 'Opt B'},
            jawabanBenar: 'A',
            pembahasan: const drift.Value('Pembahasan 1'),
            aktif: const drift.Value(true),
            packId: 'p1',
          ),
        );
    await db
        .into(db.soal)
        .insert(
          SoalCompanion.insert(
            id: 'q2',
            subtesId: 'sub-res',
            urutan: 2,
            teks: 'Soal 2',
            opsi: {'A': 'Opt A', 'B': 'Opt B'},
            jawabanBenar: 'B',
            pembahasan: const drift.Value('Pembahasan 2'),
            aktif: const drift.Value(true),
            packId: 'p1',
          ),
        );
    await db
        .into(db.soal)
        .insert(
          SoalCompanion.insert(
            id: 'q3',
            subtesId: 'sub-res',
            urutan: 3,
            teks: 'Soal 3',
            opsi: {'A': 'Opt A', 'B': 'Opt B'},
            jawabanBenar: 'A',
            pembahasan: const drift.Value('Pembahasan 3'),
            aktif: const drift.Value(true),
            packId: 'p1',
          ),
        );

    // Simulasi pengerjaan: q1 benar (A), q2 salah (A != B), q3 kosong
    final endTime = DateTime.now().add(const Duration(minutes: 20));
    await examRepo.mulaiSubtes('sub-res', endTime);
    await examRepo.simpanJawaban('sub-res', 'q1', 'A');
    await examRepo.simpanJawaban('sub-res', 'q2', 'A');

    // Selesaikan subtes
    await examRepo.selesaikanSubtes('sub-res');
  });

  tearDown(() async {
    if (Get.isRegistered<ResultController>()) {
      Get.delete<ResultController>(force: true);
    }
    await db.close();
    Get.reset();
  });

  test(
    '1. ResultController memuat snapshot hasil dan menghitung skor persentase',
    () async {
      final controller = Get.put(
        ResultController(initialSubtesId: 'sub-res', initialTesId: 't1'),
      );

      await controller.loadResult();

      expect(controller.isLoading.value, isFalse);
      expect(controller.errorMessage.value, isEmpty);
      expect(controller.totalSoal.value, equals(3));
      expect(controller.totalBenar.value, equals(1));
      expect(controller.totalSalah.value, equals(1));
      expect(controller.totalKosong.value, equals(1));
      // 1 dari 3 = 33%
      expect(controller.scorePercent.value, equals(33));
    },
  );

  testWidgets(
    '2. ResultView menampilkan kartu skor, metrik hasil, dan tombol aksi',
    (tester) async {
      Get.put(ResultController(initialSubtesId: 'sub-res', initialTesId: 't1'));

      await tester.pumpWidget(const GetMaterialApp(home: ResultView()));
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pump(const Duration(milliseconds: 100));

      // Verifikasi Header & Judul
      expect(find.text('Hasil Ujian'), findsWidgets);
      expect(find.text('Penalaran Logis'), findsOneWidget);

      // Verifikasi Skor Utama
      expect(find.text('Skor Akhir'), findsOneWidget);
      expect(find.text('33'), findsOneWidget);

      // Verifikasi Kartu Metrik
      expect(find.text('Benar'), findsOneWidget);
      expect(find.text('Salah'), findsOneWidget);
      expect(find.text('Kosong'), findsOneWidget);

      // Verifikasi Ringkasan Informasi
      expect(find.text('3 Soal'), findsOneWidget);
      expect(find.text('33.3%'), findsOneWidget);

      // Verifikasi Tombol Aksi
      expect(find.text('Lihat Pembahasan'), findsOneWidget);
      expect(find.text('Kembali ke Daftar Tes'), findsOneWidget);
    },
  );
}
