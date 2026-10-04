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
import 'package:cat_go/app/modules/home/controllers/home_controller.dart';
import 'package:cat_go/app/modules/home/views/home_view.dart';

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

  testWidgets('1. HomeView menampilkan empty state ketika belum ada data kategori', (tester) async {
    Get.put(HomeController(autoInitBundledPacks: false));

    await tester.pumpWidget(
      const GetMaterialApp(
        home: HomeView(),
      ),
    );
    await tester.pump(const Duration(milliseconds: 100));
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.text('Belum Ada Kategori'), findsOneWidget);
    expect(find.text('Paket soal simulasi belum terpasang di perangkat.'), findsOneWidget);
    expect(find.text('Kelola Paket Soal'), findsOneWidget);
  });

  testWidgets('2. HomeView menampilkan ChoiceChips kategori dan kartu tes dengan metadata lengkap', (tester) async {
    // Masukkan data kategori
    await db.into(db.kategori).insert(
      KategoriCompanion.insert(id: 'tbs', nama: 'TBS LPDP', urutan: 1),
    );
    await db.into(db.kategori).insert(
      KategoriCompanion.insert(id: 'utbk', nama: 'UTBK', urutan: 2),
    );

    // Masukkan tes untuk TBS
    await db.into(db.tes).insert(
      TesCompanion.insert(
        id: 'tbs-1',
        kategoriId: 'tbs',
        nama: 'Simulasi TBS 1',
        urutan: 1,
        packId: 'p1',
      ),
    );

    // Masukkan subtes untuk tbs-1
    await db.into(db.subtes).insert(
      SubtesCompanion.insert(
        id: 'tbs-1.sub1',
        tesId: 'tbs-1',
        nama: 'Verbal',
        durasiMenit: 30,
        urutan: 1,
      ),
    );
    await db.into(db.subtes).insert(
      SubtesCompanion.insert(
        id: 'tbs-1.sub2',
        tesId: 'tbs-1',
        nama: 'Kuantitatif',
        durasiMenit: 20,
        urutan: 2,
      ),
    );

    Get.put(HomeController(autoInitBundledPacks: false));

    await tester.pumpWidget(
      const GetMaterialApp(
        home: HomeView(),
      ),
    );
    await tester.pump(const Duration(milliseconds: 100));
    await tester.pump(const Duration(milliseconds: 100));

    // Verifikasi ChoiceChips kategori muncul
    expect(find.text('TBS LPDP'), findsOneWidget);
    expect(find.text('UTBK'), findsOneWidget);

    // Verifikasi kartu tes Simulasi TBS 1 muncul
    expect(find.text('Simulasi TBS 1'), findsOneWidget);
    expect(find.text('2 Subtes'), findsOneWidget);
    expect(find.text('50 Menit'), findsOneWidget);
    expect(find.text('Belum dikerjakan'), findsOneWidget);
    expect(find.text('Mulai Tes'), findsOneWidget);
  });

  testWidgets('3. Kartu tes yang semua subtesnya selesai menampilkan tombol Pembahasan dan Ulangi Tes aktif', (tester) async {
    // Masukkan kategori & tes
    await db.into(db.kategori).insert(
      KategoriCompanion.insert(id: 'tiu', nama: 'TIU SKD', urutan: 1),
    );
    await db.into(db.tes).insert(
      TesCompanion.insert(
        id: 'tiu-1',
        kategoriId: 'tiu',
        nama: 'Simulasi TIU 1',
        urutan: 1,
        packId: 'p1',
      ),
    );
    await db.into(db.subtes).insert(
      SubtesCompanion.insert(
        id: 'tiu-1.sub1',
        tesId: 'tiu-1',
        nama: 'Numerik',
        durasiMenit: 15,
        urutan: 1,
      ),
    );

    // Tandai subtes sebagai selesai
    await db.into(db.attemptSubtes).insert(
      AttemptSubtesCompanion.insert(
        subtesId: 'tiu-1.sub1',
        status: SubtesStatus.selesai,
        selesaiAt: drift.Value(DateTime.now()),
        totalSoal: const drift.Value(10),
        benar: const drift.Value(8),
      ),
    );

    Get.put(HomeController(autoInitBundledPacks: false));

    await tester.pumpWidget(
      const GetMaterialApp(
        home: HomeView(),
      ),
    );
    await tester.pump(const Duration(milliseconds: 100));
    await tester.pump(const Duration(milliseconds: 100));

    // Verifikasi status Selesai
    expect(find.text('Selesai'), findsOneWidget);

    // Verifikasi tombol Pembahasan dan Ulangi Tes ada dan aktif
    final btnPembahasan = find.widgetWithText(OutlinedButton, 'Pembahasan');
    final btnUlangi = find.widgetWithText(OutlinedButton, 'Ulangi Tes');

    expect(btnPembahasan, findsOneWidget);
    expect(btnUlangi, findsOneWidget);

    final pembahasanWidget = tester.widget<OutlinedButton>(btnPembahasan);
    final ulangiWidget = tester.widget<OutlinedButton>(btnUlangi);
    expect(pembahasanWidget.onPressed, isNotNull);
    expect(ulangiWidget.onPressed, isNotNull);
  });

  testWidgets('4. Kartu tes yang baru sebagian selesai atau sedang berjalan menampilkan tombol Lanjutkan', (tester) async {
    await db.into(db.kategori).insert(
      KategoriCompanion.insert(id: 'utbk-kat', nama: 'UTBK SNBT', urutan: 1),
    );
    await db.into(db.tes).insert(
      TesCompanion.insert(
        id: 'utbk-1',
        kategoriId: 'utbk-kat',
        nama: 'UTBK Paket 1',
        urutan: 1,
        packId: 'p1',
      ),
    );
    await db.into(db.subtes).insert(
      SubtesCompanion.insert(
        id: 'utbk-1.sub1',
        tesId: 'utbk-1',
        nama: 'TPS Penalaran Umum',
        durasiMenit: 30,
        urutan: 1,
      ),
    );
    await db.into(db.subtes).insert(
      SubtesCompanion.insert(
        id: 'utbk-1.sub2',
        tesId: 'utbk-1',
        nama: 'Literasi Bahasa',
        durasiMenit: 30,
        urutan: 2,
      ),
    );

    // Subtes 1 berstatus berjalan, Subtes 2 belum mulai
    await db.into(db.attemptSubtes).insert(
      AttemptSubtesCompanion.insert(
        subtesId: 'utbk-1.sub1',
        status: SubtesStatus.berjalan,
        endTime: drift.Value(DateTime.now().add(const Duration(minutes: 25))),
        mulaiAt: drift.Value(DateTime.now()),
      ),
    );

    Get.put(HomeController(autoInitBundledPacks: false));

    await tester.pumpWidget(
      const GetMaterialApp(
        home: HomeView(),
      ),
    );
    await tester.pump(const Duration(milliseconds: 100));
    await tester.pump(const Duration(milliseconds: 100));

    // Status kartu: Sedang dikerjakan
    expect(find.text('Sedang dikerjakan'), findsOneWidget);

    // Tombol: Lanjutkan
    expect(find.text('Lanjutkan'), findsOneWidget);
  });

  testWidgets('5. Ulangi Tes memunculkan dialog konfirmasi dan mereset status tes ke belum dikerjakan', (tester) async {
    await db.into(db.kategori).insert(
      KategoriCompanion.insert(id: 'tbs-kat', nama: 'TBS', urutan: 1),
    );
    await db.into(db.tes).insert(
      TesCompanion.insert(
        id: 'tbs-ulang',
        kategoriId: 'tbs-kat',
        nama: 'TBS Reset Uji',
        urutan: 1,
        packId: 'p1',
      ),
    );
    await db.into(db.subtes).insert(
      SubtesCompanion.insert(
        id: 'tbs-ulang.sub1',
        tesId: 'tbs-ulang',
        nama: 'Subtes 1',
        durasiMenit: 10,
        urutan: 1,
      ),
    );

    // Subtes selesai
    await db.into(db.attemptSubtes).insert(
      AttemptSubtesCompanion.insert(
        subtesId: 'tbs-ulang.sub1',
        status: SubtesStatus.selesai,
        selesaiAt: drift.Value(DateTime.now()),
      ),
    );

    Get.put(HomeController(autoInitBundledPacks: false));

    await tester.pumpWidget(
      const GetMaterialApp(
        home: HomeView(),
      ),
    );
    await tester.pump(const Duration(milliseconds: 100));
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.text('Selesai'), findsOneWidget);

    // Ketuk tombol Ulangi Tes
    await tester.tap(find.widgetWithText(OutlinedButton, 'Ulangi Tes'));
    await tester.pumpAndSettle();

    // Verifikasi Dialog Konfirmasi muncul
    expect(find.text('Ulangi Tes'), findsWidgets); // di dialog
    expect(find.textContaining('Hasil sebelumnya untuk "TBS Reset Uji" akan dihapus.'), findsOneWidget);
    expect(find.text('Batal'), findsOneWidget);
    expect(find.text('Ulangi'), findsOneWidget);

    // Konfirmasi Ulangi
    await tester.tap(find.text('Ulangi'));
    await tester.pumpAndSettle();
    await tester.pump(const Duration(seconds: 3));
    await tester.pumpAndSettle();

    // Verifikasi Drift stream otomatis memperbarui status menjadi Belum dikerjakan dan tombol Mulai Tes muncul
    expect(find.text('Belum dikerjakan'), findsOneWidget);
    expect(find.text('Mulai Tes'), findsOneWidget);
  });
}

