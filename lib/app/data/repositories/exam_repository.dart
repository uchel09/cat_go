import '../models/exam_models.dart';

abstract class ExamRepository {
  /// Mengambil snapshot progres subtes (attempt, jawaban tersimpan, dan soal ragu).
  Future<SubtestProgress?> getProgresSubtes(String subtesId);

  /// Memantau perubahan progres subtes secara reaktif (Stream).
  Stream<SubtestProgress?> watchProgresSubtes(String subtesId);

  /// Memulai pengerjaan subtes dengan batas waktu deadline tertentu (endTime).
  Future<void> mulaiSubtes(String subtesId, DateTime endTime);

  /// Menyimpan atau memperbarui jawaban soal pada subtes.
  Future<void> simpanJawaban(String subtesId, String soalId, String opsi);

  /// Menandai atau menghapus status ragu-ragu pada soal subtes.
  Future<void> setRagu(String subtesId, String soalId, bool isRagu);

  /// Menyelesaikan subtes: menghitung skor secara otomatis (benar, salah, kosong, totalSoal)
  /// dan menyimpan snapshot ke tabel attempt_subtes.
  Future<SubtestScoreResult> selesaikanSubtes(String subtesId);

  /// Menghapus seluruh progres (attempt, jawaban, ragu) pada semua subtes
  /// dari tes tertentu dalam satu transaksi atomik.
  Future<void> ulangiTes(String tesId);
}
