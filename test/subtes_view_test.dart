import 'package:drift/drift.dart' as drift;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

import 'package:cat_go/app/data/local/app_database.dart';
import 'package:cat_go/app/data/local/tables/attempt_subtes_table.dart';
import 'package:cat_go/app/data/repositories/content_repository.dart';
import 'package:cat_go/app/data/repositories/content_repository_drift.dart';
import 'package:cat_go/app/data/repositories/exam_repository.dart';
import 'package:cat_go/app/data/repositories/exam_repository_drift.dart';
import 'package:cat_go/app/modules/subtes/controllers/subtes_controller.dart';
import 'package:cat_go/app/modules/subtes/views/subtes_view.dart';

void main() {
  late AppDatabase db;
  late ContentRepository contentRepo;
  late ExamRepository examRepo;

  setUp(() {
    Get.reset();
    db = AppDatabase(NativeDatabase.memory());
    contentRepo = ContentRepositoryDrift(db);
    examRepo = ExamRepositoryDrift(db);

    Get.put<AppDatabase>(db);
    Get.put<ContentRepository>(contentRepo);
    Get.put<ExamRepository>(examRepo);
  });

  tearDown(() async {
    await db.close();
    Get.reset();
  });

  testWidgets('1. SubtesView menampilkan nama tes dan daftar subtes dengan metadata lengkap', (tester) async {
    // 1. Setup Data
    await db.into(db.kategori).insert(
      KategoriCompanion.insert(id: 'kat-1', nama: 'TBS LPDP', urutan: 1),
    );
    await db.into(db.tes).insert(
      TesCompanion.insert(
        id: 'tbs-1',
        kategoriId: 'kat-1',
        nama: 'Simulasi TBS 1',
        urutan: 1,
        packId: 'p1',
      ),
    );
    await db.into(db.subtes).insert(
      SubtesCompanion.insert(
        id: 'tbs-1.verbal',
        tesId: 'tbs-1',
        nama: 'Penalaran Verbal',
        durasiMenit: 30,
        urutan: 1,
      ),
    );
    // Tambahkan 3 soal aktif dan 1 nonaktif
    await db.into(db.soal).insert(
      SoalCompanion.insert(
        id: 'q1',
        subtesId: 'tbs-1.verbal',
        urutan: 1,
        teks: 'Soal 1',
        opsi: {'A': 'A'},
        jawabanBenar: 'A',
        aktif: drift.Value(true),
        packId: 'p1',
      ),
    );
    await db.into(db.soal).insert(
      SoalCompanion.insert(
        id: 'q2',
        subtesId: 'tbs-1.verbal',
        urutan: 2,
        teks: 'Soal 2',
        opsi: {'A': 'A'},
        jawabanBenar: 'A',
        aktif: drift.Value(true),
        packId: 'p1',
      ),
    );
    await db.into(db.soal).insert(
      SoalCompanion.insert(
        id: 'q3',
        subtesId: 'tbs-1.verbal',
        urutan: 3,
        teks: 'Soal 3',
        opsi: {'A': 'A'},
        jawabanBenar: 'A',
        aktif: drift.Value(false), // Nonaktif
        packId: 'p1',
      ),
    );

    Get.put(SubtesController(initialTesId: 'tbs-1'));

    await tester.pumpWidget(
      const GetMaterialApp(
        home: SubtesView(),
      ),
    );
    await tester.pump(const Duration(milliseconds: 100));
    await tester.pump(const Duration(milliseconds: 100));

    // Verifikasi nama tes di AppBar
    expect(find.text('Simulasi TBS 1'), findsOneWidget);

    // Verifikasi metadata kartu subtes:
    expect(find.text('Penalaran Verbal'), findsOneWidget);
    expect(find.text('2 Soal'), findsOneWidget); // Hanya 2 soal aktif
    expect(find.text('30 Menit'), findsOneWidget);
    expect(find.text('Belum mulai'), findsOneWidget);
    expect(find.text('Mulai'), findsOneWidget);
  });

  testWidgets('2. Klik Mulai memicu mulaiSubtes dan timer baru berjalan setelah diklik', (tester) async {
    // Setup subtes
    await db.into(db.kategori).insert(
      KategoriCompanion.insert(id: 'kat-1', nama: 'TBS', urutan: 1),
    );
    await db.into(db.tes).insert(
      TesCompanion.insert(id: 'tes-1', kategoriId: 'kat-1', nama: 'Tes 1', urutan: 1, packId: 'p1'),
    );
    await db.into(db.subtes).insert(
      SubtesCompanion.insert(id: 'sub-1', tesId: 'tes-1', nama: 'Subtes 1', durasiMenit: 25, urutan: 1),
    );

    // Cek bahwa sebelum diklik, belum ada rekaman attempt di database
    var attemptBefore = await examRepo.getProgresSubtes('sub-1');
    expect(attemptBefore, isNull);

    Get.put(SubtesController(initialTesId: 'tes-1'));

    await tester.pumpWidget(
      GetMaterialApp(
        home: const SubtesView(),
        getPages: [
          GetPage(
            name: '/exam',
            page: () => const Scaffold(),
          ),
        ],
      ),
    );
    await tester.pump(const Duration(milliseconds: 100));
    await tester.pump(const Duration(milliseconds: 100));

    // Klik tombol Mulai
    final btnMulai = find.text('Mulai');
    expect(btnMulai, findsOneWidget);
    await tester.tap(btnMulai);
    await tester.pump(const Duration(milliseconds: 100));

    // Verifikasi bahwa status sekarang adalah 'berjalan' dan endTime terpasang
    final attemptAfter = await examRepo.getProgresSubtes('sub-1');
    expect(attemptAfter, isNotNull);
    expect(attemptAfter!.attempt.status, SubtesStatus.berjalan);
    expect(attemptAfter.attempt.endTime, isNotNull);
  });

  testWidgets('3. Subtes berstatus Berjalan menampilkan tombol Lanjutkan dan Selesai menampilkan Lihat Hasil', (tester) async {
    await db.into(db.kategori).insert(KategoriCompanion.insert(id: 'k', nama: 'K', urutan: 1));
    await db.into(db.tes).insert(TesCompanion.insert(id: 't', kategoriId: 'k', nama: 'Tes', urutan: 1, packId: 'p'));

    // Subtes A: Berjalan
    await db.into(db.subtes).insert(SubtesCompanion.insert(id: 'sub-a', tesId: 't', nama: 'Subtes Berjalan', durasiMenit: 10, urutan: 1));
    await db.into(db.attemptSubtes).insert(
      AttemptSubtesCompanion.insert(
        subtesId: 'sub-a',
        status: SubtesStatus.berjalan,
        endTime: drift.Value(DateTime.now().add(const Duration(minutes: 10))),
      ),
    );

    // Subtes B: Selesai
    await db.into(db.subtes).insert(SubtesCompanion.insert(id: 'sub-b', tesId: 't', nama: 'Subtes Selesai', durasiMenit: 15, urutan: 2));
    await db.into(db.attemptSubtes).insert(
      AttemptSubtesCompanion.insert(
        subtesId: 'sub-b',
        status: SubtesStatus.selesai,
        selesaiAt: drift.Value(DateTime.now()),
        benar: const drift.Value(5),
        salah: const drift.Value(2),
        kosong: const drift.Value(1),
        totalSoal: const drift.Value(8),
      ),
    );

    Get.put(SubtesController(initialTesId: 't'));

    await tester.pumpWidget(
      const GetMaterialApp(
        home: SubtesView(),
      ),
    );
    await tester.pump(const Duration(milliseconds: 100));
    await tester.pump(const Duration(milliseconds: 100));

    // Subtes A: status Berjalan & tombol Lanjutkan
    expect(find.text('Berjalan'), findsOneWidget);
    expect(find.text('Lanjutkan'), findsOneWidget);

    // Subtes B: status Selesai & tombol Lihat Hasil (disabled)
    expect(find.text('Selesai'), findsOneWidget);
    expect(find.text('Lihat Hasil'), findsOneWidget);

    final btnLihatHasil = tester.widget<OutlinedButton>(
      find.byWidgetPredicate((w) => w is OutlinedButton),
    );
    expect(btnLihatHasil.onPressed, isNotNull); // Aktif di Tahap 6
  });
}
