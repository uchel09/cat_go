import 'dart:convert';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

import 'package:cat_go/app/data/local/app_database.dart';
import 'package:cat_go/app/data/models/catalog_models.dart';
import 'package:cat_go/app/data/repositories/content_repository.dart';
import 'package:cat_go/app/data/repositories/content_repository_drift.dart';
import 'package:cat_go/app/data/repositories/exam_repository.dart';
import 'package:cat_go/app/data/repositories/exam_repository_drift.dart';
import 'package:cat_go/app/data/services/catalog_service.dart';
import 'package:cat_go/app/data/services/file_picker_service.dart';
import 'package:cat_go/app/data/services/pack_importer.dart';
import 'package:cat_go/app/data/services/pack_validator.dart';
import 'package:cat_go/app/modules/packs/controllers/packs_controller.dart';
import 'package:cat_go/app/modules/packs/views/packs_view.dart';

class FakeFilePickerService extends FilePickerService {
  String? jsonContentToReturn;

  @override
  Future<String?> pickJsonFileContent() async {
    return jsonContentToReturn;
  }
}

class FakeCatalogService extends CatalogService {
  List<CatalogPackItem> catalogToReturn = [];
  Map<String, String> urlToContent = {};

  @override
  Future<List<CatalogPackItem>> fetchCatalog({String? customUrl}) async {
    return catalogToReturn;
  }

  @override
  Future<String> downloadPackJson(
    String fileUrl, {
    int maxSizeBytes = 5 * 1024 * 1024,
  }) async {
    if (urlToContent.containsKey(fileUrl)) {
      return urlToContent[fileUrl]!;
    }
    throw CatalogException('File tidak ditemukan di server.');
  }
}

void main() {
  late AppDatabase db;
  late ContentRepository contentRepo;
  late ExamRepository examRepo;
  late PackValidator validator;
  late PackImporter importer;
  late FakeFilePickerService fakePicker;
  late FakeCatalogService fakeCatalog;

  final sampleValidPack = {
    'schemaVersion': 1,
    'packId': 'pack-test-1',
    'packVersion': 1,
    'nama': 'Paket Uji Coba 1',
    'kategori': {'id': 'kat-uji', 'nama': 'Kategori Uji'},
    'tes': [
      {
        'id': 'tes-uji-1',
        'nama': 'Tes Uji 1',
        'subtes': [
          {
            'id': 'sub-uji-1',
            'nama': 'Subtes A',
            'durasiMenit': 10,
            'stimulus': [],
            'soal': [
              {
                'id': 'soal-uji-1',
                'teks': 'Pertanyaan 1',
                'opsi': {'A': 'Pilihan A', 'B': 'Pilihan B'},
                'jawabanBenar': 'A',
                'pembahasan': 'Pembahasan 1',
              },
            ],
          },
        ],
      },
    ],
  };

  setUp(() async {
    Get.reset();
    db = AppDatabase(NativeDatabase.memory());
    contentRepo = ContentRepositoryDrift(db);
    examRepo = ExamRepositoryDrift(db);
    validator = PackValidator();
    importer = PackImporter(db, validator: validator);
    fakePicker = FakeFilePickerService();
    fakeCatalog = FakeCatalogService();

    Get.put<AppDatabase>(db);
    Get.put<ContentRepository>(contentRepo);
    Get.put<ExamRepository>(examRepo);
    Get.put<PackValidator>(validator);
    Get.put<PackImporter>(importer);
    Get.put<FilePickerService>(fakePicker);
    Get.put<CatalogService>(fakeCatalog);
  });

  tearDown(() async {
    if (Get.isRegistered<PacksController>()) {
      Get.delete<PacksController>(force: true);
    }
    await db.close();
    Get.reset();
  });

  testWidgets(
    '1. PacksView menampilkan empty state ketika belum ada paket terpasang',
    (tester) async {
      Get.put(
        PacksController(
          contentRepository: contentRepo,
          packImporter: importer,
          filePickerService: fakePicker,
          catalogService: fakeCatalog,
        ),
      );

      await tester.pumpWidget(const GetMaterialApp(home: PacksView()));
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.text('Paket Tes'), findsOneWidget);
      expect(find.text('Terpasang'), findsOneWidget);
      expect(find.text('Tersedia'), findsOneWidget);
      expect(find.text('Belum Ada Paket Terpasang'), findsOneWidget);
      expect(find.text('Impor dari File'), findsOneWidget);
    },
  );

  testWidgets(
    '2. Impor paket valid berhasil memasang paket dan memperbarui daftar di UI',
    (tester) async {
      final controller = Get.put(
        PacksController(
          contentRepository: contentRepo,
          packImporter: importer,
          filePickerService: fakePicker,
          catalogService: fakeCatalog,
        ),
      );

      await tester.pumpWidget(const GetMaterialApp(home: PacksView()));
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pump(const Duration(milliseconds: 100));

      // Siapkan file JSON valid
      fakePicker.jsonContentToReturn = json.encode(sampleValidPack);

      // Ketuk tombol Impor dari File
      await tester.tap(find.text('Impor dari File'));
      await tester.pump();

      while (controller.isImporting.value) {
        await tester.pump(const Duration(milliseconds: 50));
      }
      await tester.pumpAndSettle();

      // Verifikasi Dialog Berhasil muncul
      expect(find.text('Impor Berhasil'), findsOneWidget);
      expect(find.text('Tutup'), findsOneWidget);

      // Tutup dialog
      await tester.tap(find.text('Tutup'));
      await tester.pumpAndSettle();

      // Verifikasi Kartu Paket muncul di daftar
      expect(controller.paketList.length, equals(1));
      expect(find.text('Paket Uji Coba 1'), findsOneWidget);
      expect(find.text('v1'), findsOneWidget);
      expect(find.text('1 Tes'), findsOneWidget);
      expect(find.text('1 Soal'), findsOneWidget);
    },
  );

  testWidgets(
    '3. Impor file bukan JSON atau format invalid memunculkan dialog error yang jelas',
    (tester) async {
      final controller = Get.put(
        PacksController(
          contentRepository: contentRepo,
          packImporter: importer,
          filePickerService: fakePicker,
          catalogService: fakeCatalog,
        ),
      );

      await tester.pumpWidget(const GetMaterialApp(home: PacksView()));
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pump(const Duration(milliseconds: 100));

      // Siapkan JSON yang tidak valid (jawabanBenar tidak ada di opsi)
      final invalidPack = Map<String, dynamic>.from(sampleValidPack);
      invalidPack['packId'] = 'pack-invalid';
      invalidPack['tes'] = [
        {
          'id': 't-err',
          'nama': 'Tes Err',
          'subtes': [
            {
              'id': 'sub-err',
              'nama': 'Subtes Err',
              'durasiMenit': 10,
              'stimulus': [],
              'soal': [
                {
                  'id': 'q-err',
                  'teks': 'Teks',
                  'opsi': {'A': 'Pilihan A'},
                  'jawabanBenar': 'Z', // Tidak ada di opsi!
                  'pembahasan': 'Bahasan',
                },
              ],
            },
          ],
        },
      ];

      fakePicker.jsonContentToReturn = json.encode(invalidPack);

      // Ketuk Impor
      await tester.tap(find.text('Impor dari File'));
      await tester.pump();

      while (controller.isImporting.value) {
        await tester.pump(const Duration(milliseconds: 50));
      }
      await tester.pumpAndSettle();

      // Verifikasi Dialog Validasi Gagal muncul dan menyebut ID yang salah
      expect(find.text('Validasi Gagal'), findsOneWidget);
      expect(
        find.textContaining('jawabanBenar "Z" tidak ada di opsi'),
        findsOneWidget,
      );

      await tester.tap(find.text('Tutup'));
      await tester.pumpAndSettle();
    },
  );

  testWidgets(
    '4. Hapus paket memunculkan dialog konfirmasi konsekuensi dan menghapus data secara kaskade',
    (tester) async {
      // Impor satu paket terlebih dahulu
      await importer.importJsonString(json.encode(sampleValidPack));

      // Mulai dan simpan progres di subtes paket tersebut
      final endTime = DateTime.now().add(const Duration(minutes: 10));
      await examRepo.mulaiSubtes('sub-uji-1', endTime);
      await examRepo.simpanJawaban('sub-uji-1', 'soal-uji-1', 'A');

      final controller = Get.put(
        PacksController(
          contentRepository: contentRepo,
          packImporter: importer,
          filePickerService: fakePicker,
          catalogService: fakeCatalog,
        ),
      );

      await tester.pumpWidget(const GetMaterialApp(home: PacksView()));
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pump(const Duration(milliseconds: 100));

      // Verifikasi paket tampil
      expect(find.text('Paket Uji Coba 1'), findsOneWidget);

      // Ketuk tombol icon Hapus
      await tester.tap(find.byIcon(Icons.delete_outline));
      await tester.pumpAndSettle();

      // Verifikasi Dialog Konfirmasi Hapus muncul dengan penjelasan konsekuensi
      expect(find.text('Hapus Paket Soal?'), findsOneWidget);
      expect(
        find.textContaining(
          'Menghapus paket Paket Uji Coba 1 akan menghapus secara permanen',
        ),
        findsOneWidget,
      );
      expect(find.text('Batal'), findsOneWidget);
      expect(find.text('Hapus Permanen'), findsOneWidget);

      // Konfirmasi Hapus
      await tester.tap(find.text('Hapus Permanen'));
      await tester.pumpAndSettle();
      await tester.pump(const Duration(seconds: 3));
      await tester.pumpAndSettle();

      // Verifikasi paket telah terhapus dari UI
      expect(controller.paketList.isEmpty, isTrue);
      expect(find.text('Belum Ada Paket Terpasang'), findsOneWidget);

      // Verifikasi database bersih (tes dan kategori ikut terhapus)
      final remainingTes = await db.select(db.tes).get();
      expect(remainingTes.isEmpty, isTrue);

      final remainingKat = await db.select(db.kategori).get();
      expect(remainingKat.isEmpty, isTrue);
    },
  );

  testWidgets(
    '5. Tab Tersedia menampilkan katalog online, tombol Unduh, dan otomatis menjadi Terbaru setelah diunduh',
    (tester) async {
      // Siapkan data katalog online
      fakeCatalog.catalogToReturn = [
        const CatalogPackItem(
          packId: 'pack-online-1',
          nama: 'Paket Online Simulasi',
          packVersion: 1,
          url: 'https://example.com/online1.json',
          ukuranKb: 60,
        ),
      ];
      final onlinePackJson = Map<String, dynamic>.from(sampleValidPack);
      onlinePackJson['packId'] = 'pack-online-1';
      onlinePackJson['nama'] = 'Paket Online Simulasi';
      fakeCatalog.urlToContent['https://example.com/online1.json'] = json
          .encode(onlinePackJson);

      final controller = Get.put(
        PacksController(
          contentRepository: contentRepo,
          packImporter: importer,
          filePickerService: fakePicker,
          catalogService: fakeCatalog,
        ),
      );

      await tester.pumpWidget(const GetMaterialApp(home: PacksView()));
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pump(const Duration(milliseconds: 100));

      // Beralih ke Tab "Tersedia"
      await tester.tap(find.text('Tersedia'));
      await tester.pumpAndSettle();

      // Verifikasi Kartu Katalog muncul dengan tombol "Unduh"
      expect(find.text('Paket Online Simulasi'), findsOneWidget);
      expect(find.text('60 KB'), findsOneWidget);
      expect(find.text('Unduh'), findsOneWidget);

      // Ketuk tombol Unduh
      await tester.tap(find.text('Unduh'));
      await tester.pump();

      while (controller.downloadingPackId.value.isNotEmpty) {
        await tester.pump(const Duration(milliseconds: 50));
      }
      await tester.pumpAndSettle();

      // Dialog Berhasil muncul
      expect(find.text('Impor Berhasil'), findsOneWidget);
      await tester.tap(find.text('Tutup'));
      await tester.pumpAndSettle();

      // Tombol kini berubah menjadi badge "Terbaru"
      expect(find.text('Terbaru'), findsOneWidget);
      expect(find.text('Unduh'), findsNothing);
    },
  );
}
