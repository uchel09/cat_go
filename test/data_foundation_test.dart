import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:cat_go/app/data/local/app_database.dart';
import 'package:cat_go/app/data/models/content_models.dart';
import 'package:cat_go/app/data/repositories/content_repository_drift.dart';
import 'package:cat_go/app/data/repositories/exam_repository_drift.dart';

void main() {
  late AppDatabase db;
  late ContentRepositoryDrift contentRepo;
  late ExamRepositoryDrift examRepo;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    contentRepo = ContentRepositoryDrift(db);
    examRepo = ExamRepositoryDrift(db);
  });

  tearDown(() async {
    await db.close();
  });

  test('1. Simpan dan ambil konten (kategori, tes, subtes, stimulus, soal dengan TypeConverter)', () async {
    // 1. Insert kategori
    await db.into(db.kategori).insert(
      const KategoriCompanion(
        id: Value('kat-lpdp'),
        nama: Value('TBS LPDP'),
        urutan: Value(1),
      ),
    );

    // 2. Insert tes
    await db.into(db.tes).insert(
      const TesCompanion(
        id: Value('tbs-lpdp-1'),
        kategoriId: Value('kat-lpdp'),
        nama: Value('Simulasi TBS 1'),
        urutan: Value(1),
        packId: Value('pkg-01'),
      ),
    );

    // 3. Insert subtes
    await db.into(db.subtes).insert(
      const SubtesCompanion(
        id: Value('tbs-lpdp-1.verbal'),
        tesId: Value('tbs-lpdp-1'),
        nama: Value('Penalaran Verbal'),
        durasiMenit: Value(30),
        urutan: Value(1),
      ),
    );

    // 4. Insert stimulus
    await db.into(db.stimulus).insert(
      const StimulusCompanion(
        id: Value('stim-01'),
        subtesId: Value('tbs-lpdp-1.verbal'),
        judul: Value('Wacana Lingkungan'),
        isi: Value('Teks wacana tentang perubahan iklim global...'),
        urutan: Value(1),
      ),
    );

    // 5. Insert soal dengan opsi Map JSON
    await db.into(db.soal).insert(
      const SoalCompanion(
        id: Value('tbs-lpdp-1.verbal.q001'),
        subtesId: Value('tbs-lpdp-1.verbal'),
        stimulusId: Value('stim-01'),
        urutan: Value(1),
        teks: Value('Apa gagasan utama paragraf di atas?'),
        opsi: Value({
          'A': 'Perubahan iklim meningkat',
          'B': 'Pengurangan emisi karbon',
          'C': 'Dampak industri hijau',
        }),
        jawabanBenar: Value('A'),
        pembahasan: Value('Paragraf pertama menjelaskan peningkatan perubahan iklim.'),
        aktif: Value(true),
        packId: Value('pkg-01'),
      ),
    );

    // Ambil daftar kategori via repository
    final kategoriList = await contentRepo.watchKategoriList().first;
    expect(kategoriList.length, 1);
    expect(kategoriList.first.nama, 'TBS LPDP');

    // Ambil konten subtes lengkap
    final subtestContent = await contentRepo.getSubtestContent('tbs-lpdp-1.verbal');
    expect(subtestContent.subtes.nama, 'Penalaran Verbal');
    expect(subtestContent.stimuli.length, 1);
    expect(subtestContent.stimuli.first.judul, 'Wacana Lingkungan');
    expect(subtestContent.soalList.length, 1);

    final soal = subtestContent.soalList.first;
    expect(soal.opsi['A'], 'Perubahan iklim meningkat');
    expect(soal.opsi['B'], 'Pengurangan emisi karbon');
    expect(soal.jawabanBenar, 'A');
  });

  test('2. Status turunan tes: belumMulai -> berjalan -> selesai', () async {
    // Setup 1 tes dengan 2 subtes
    await db.into(db.kategori).insert(
      const KategoriCompanion(
        id: Value('kat-utbk'),
        nama: Value('UTBK SNBT'),
        urutan: Value(1),
      ),
    );
    await db.into(db.tes).insert(
      const TesCompanion(
        id: Value('utbk-1'),
        kategoriId: Value('kat-utbk'),
        nama: Value('Tryout UTBK 1'),
        urutan: Value(1),
        packId: Value('pkg-utbk'),
      ),
    );
    await db.into(db.subtes).insert(
      const SubtesCompanion(
        id: Value('utbk-1.sub1'),
        tesId: Value('utbk-1'),
        nama: Value('Penalaran Umum'),
        durasiMenit: Value(30),
        urutan: Value(1),
      ),
    );
    await db.into(db.subtes).insert(
      const SubtesCompanion(
        id: Value('utbk-1.sub2'),
        tesId: Value('utbk-1'),
        nama: Value('Literasi Bahasa'),
        durasiMenit: Value(45),
        urutan: Value(2),
      ),
    );

    // Kondisi 1: Belum ada subtes dimulai
    var tesSummaries = await contentRepo.watchTesByKategori('kat-utbk').first;
    expect(tesSummaries.length, 1);
    expect(tesSummaries.first.jumlahSubtes, 2);
    expect(tesSummaries.first.totalDurasiMenit, 75);
    expect(tesSummaries.first.status, TesStatus.belumMulai);

    // Kondisi 2: Subtes 1 dimulai (berjalan)
    final deadline = DateTime.now().add(const Duration(minutes: 30));
    await examRepo.mulaiSubtes('utbk-1.sub1', deadline);

    tesSummaries = await contentRepo.watchTesByKategori('kat-utbk').first;
    expect(tesSummaries.first.status, TesStatus.berjalan);

    // Kondisi 3: Subtes 1 selesai, tapi subtes 2 belum mulai -> Status tes tetap 'berjalan'
    await examRepo.selesaikanSubtes('utbk-1.sub1');
    tesSummaries = await contentRepo.watchTesByKategori('kat-utbk').first;
    expect(tesSummaries.first.status, TesStatus.berjalan);

    // Kondisi 4: Subtes 2 juga diselesaikan -> Status tes menjadi 'selesai'
    await examRepo.mulaiSubtes('utbk-1.sub2', deadline);
    await examRepo.selesaikanSubtes('utbk-1.sub2');

    tesSummaries = await contentRepo.watchTesByKategori('kat-utbk').first;
    expect(tesSummaries.first.status, TesStatus.selesai);
  });

  test('3. SelesaikanSubtes menghitung skor snapshot dengan akurat (benar, salah, kosong)', () async {
    // Setup data
    await db.into(db.kategori).insert(const KategoriCompanion(id: Value('kat-1'), nama: Value('TIU'), urutan: Value(1)));
    await db.into(db.tes).insert(const TesCompanion(id: Value('tiu-1'), kategoriId: Value('kat-1'), nama: Value('Tes 1'), urutan: Value(1), packId: Value('p1')));
    await db.into(db.subtes).insert(const SubtesCompanion(id: Value('sub-score'), tesId: Value('tiu-1'), nama: Value('Hitungan'), durasiMenit: Value(20), urutan: Value(1)));

    // 4 Soal: q1 (kunci A), q2 (kunci B), q3 (kunci C), q4 nonaktif (diabaikan)
    await db.into(db.soal).insert(const SoalCompanion(id: Value('q1'), subtesId: Value('sub-score'), urutan: Value(1), teks: Value('1+1='), opsi: Value({'A': '2', 'B': '3'}), jawabanBenar: Value('A'), aktif: Value(true), packId: Value('p1')));
    await db.into(db.soal).insert(const SoalCompanion(id: Value('q2'), subtesId: Value('sub-score'), urutan: Value(2), teks: Value('2+2='), opsi: Value({'A': '3', 'B': '4'}), jawabanBenar: Value('B'), aktif: Value(true), packId: Value('p1')));
    await db.into(db.soal).insert(const SoalCompanion(id: Value('q3'), subtesId: Value('sub-score'), urutan: Value(3), teks: Value('3+3='), opsi: Value({'A': '5', 'C': '6'}), jawabanBenar: Value('C'), aktif: Value(true), packId: Value('p1')));
    await db.into(db.soal).insert(const SoalCompanion(id: Value('q4-nonaktif'), subtesId: Value('sub-score'), urutan: Value(4), teks: Value('Diabaikan'), opsi: Value({}), jawabanBenar: Value('A'), aktif: Value(false), packId: Value('p1')));

    // Mulai subtes
    await examRepo.mulaiSubtes('sub-score', DateTime.now().add(const Duration(minutes: 20)));

    // User menjawab:
    // q1 -> 'A' (Benar)
    // q2 -> 'A' (Salah, seharusnya B)
    // q3 -> Tidak dijawab (Kosong)
    await examRepo.simpanJawaban('sub-score', 'q1', 'A');
    await examRepo.simpanJawaban('sub-score', 'q2', 'A');

    // Tandai ragu pada q2
    await examRepo.setRagu('sub-score', 'q2', true);

    // Cek progres saat berjalan
    final progressBefore = await examRepo.getProgresSubtes('sub-score');
    expect(progressBefore, isNotNull);
    expect(progressBefore!.attempt.status, SubtesStatus.berjalan);
    expect(progressBefore.jawabanMap['q1'], 'A');
    expect(progressBefore.jawabanMap['q2'], 'A');
    expect(progressBefore.raguSet.contains('q2'), isTrue);

    // Selesaikan subtes
    final result = await examRepo.selesaikanSubtes('sub-score');
    expect(result.totalSoal, 3); // Hanya 3 soal aktif
    expect(result.benar, 1);
    expect(result.salah, 1);
    expect(result.kosong, 1);

    // Cek snapshot di database
    final progressAfter = await examRepo.getProgresSubtes('sub-score');
    expect(progressAfter!.attempt.status, SubtesStatus.selesai);
    expect(progressAfter.attempt.benar, 1);
    expect(progressAfter.attempt.salah, 1);
    expect(progressAfter.attempt.kosong, 1);
    expect(progressAfter.attempt.totalSoal, 3);
    expect(progressAfter.attempt.selesaiAt, isNotNull);
  });

  test('4. UlangiTes menghapus progres tes yang dipilih tanpa mengganggu tes lain', () async {
    // Setup Kategori
    await db.into(db.kategori).insert(const KategoriCompanion(id: Value('kat-all'), nama: Value('Semua'), urutan: Value(1)));

    // Setup Tes A dan Tes B
    await db.into(db.tes).insert(const TesCompanion(id: Value('tes-a'), kategoriId: Value('kat-all'), nama: Value('Tes A'), urutan: Value(1), packId: Value('p1')));
    await db.into(db.tes).insert(const TesCompanion(id: Value('tes-b'), kategoriId: Value('kat-all'), nama: Value('Tes B'), urutan: Value(2), packId: Value('p1')));

    // Subtes untuk Tes A dan Tes B
    await db.into(db.subtes).insert(const SubtesCompanion(id: Value('sub-a1'), tesId: Value('tes-a'), nama: Value('Sub A1'), durasiMenit: Value(10), urutan: Value(1)));
    await db.into(db.subtes).insert(const SubtesCompanion(id: Value('sub-b1'), tesId: Value('tes-b'), nama: Value('Sub B1'), durasiMenit: Value(10), urutan: Value(1)));

    // Soal
    await db.into(db.soal).insert(const SoalCompanion(id: Value('qa1'), subtesId: Value('sub-a1'), urutan: Value(1), teks: Value('Soal A'), opsi: Value({}), jawabanBenar: Value('A'), aktif: Value(true), packId: Value('p1')));
    await db.into(db.soal).insert(const SoalCompanion(id: Value('qb1'), subtesId: Value('sub-b1'), urutan: Value(1), teks: Value('Soal B'), opsi: Value({}), jawabanBenar: Value('B'), aktif: Value(true), packId: Value('p1')));

    // Jalankan dan simpan progres di Tes A
    await examRepo.mulaiSubtes('sub-a1', DateTime.now().add(const Duration(minutes: 10)));
    await examRepo.simpanJawaban('sub-a1', 'qa1', 'A');
    await examRepo.setRagu('sub-a1', 'qa1', true);
    await examRepo.selesaikanSubtes('sub-a1');

    // Jalankan dan simpan progres di Tes B
    await examRepo.mulaiSubtes('sub-b1', DateTime.now().add(const Duration(minutes: 10)));
    await examRepo.simpanJawaban('sub-b1', 'qb1', 'B');
    await examRepo.setRagu('sub-b1', 'qb1', true);
    await examRepo.selesaikanSubtes('sub-b1');

    // Verifikasi kedua tes telah selesai
    var listTes = await contentRepo.watchTesByKategori('kat-all').first;
    expect(listTes.firstWhere((t) => t.tes.id == 'tes-a').status, TesStatus.selesai);
    expect(listTes.firstWhere((t) => t.tes.id == 'tes-b').status, TesStatus.selesai);

    // Lakukan ulangiTes hanya untuk Tes A
    await examRepo.ulangiTes('tes-a');

    // Verifikasi: Progres Tes A telah terhapus total
    final progressA = await examRepo.getProgresSubtes('sub-a1');
    expect(progressA, isNull);

    final jawabanA = await (db.select(db.jawaban)..where((tbl) => tbl.subtesId.equals('sub-a1'))).get();
    expect(jawabanA, isEmpty);

    final raguA = await (db.select(db.ragu)..where((tbl) => tbl.subtesId.equals('sub-a1'))).get();
    expect(raguA, isEmpty);

    listTes = await contentRepo.watchTesByKategori('kat-all').first;
    expect(listTes.firstWhere((t) => t.tes.id == 'tes-a').status, TesStatus.belumMulai);

    // Verifikasi: Tes B TIDAK TERSENTUH sama sekali
    final progressB = await examRepo.getProgresSubtes('sub-b1');
    expect(progressB, isNotNull);
    expect(progressB!.attempt.status, SubtesStatus.selesai);
    expect(progressB.jawabanMap['qb1'], 'B');
    expect(progressB.raguSet.contains('qb1'), isTrue);
    expect(listTes.firstWhere((t) => t.tes.id == 'tes-b').status, TesStatus.selesai);
  });
}
