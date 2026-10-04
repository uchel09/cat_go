import '../local/app_database.dart';

export '../local/app_database.dart' show AttemptSubtesData;

/// Progres pengerjaan subtes: status attempt, jawaban yang sudah dipilih, dan tanda ragu.
class SubtestProgress {
  final AttemptSubtesData attempt;
  final Map<String, String> jawabanMap;
  final Set<String> raguSet;

  const SubtestProgress({
    required this.attempt,
    required this.jawabanMap,
    required this.raguSet,
  });
}

/// Snapshot skor hasil pengerjaan subtes.
class SubtestScoreResult {
  final int benar;
  final int salah;
  final int kosong;
  final int totalSoal;

  const SubtestScoreResult({
    required this.benar,
    required this.salah,
    required this.kosong,
    required this.totalSoal,
  });
}
