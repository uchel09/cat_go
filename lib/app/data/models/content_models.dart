import '../local/app_database.dart';
import '../local/tables/attempt_subtes_table.dart';

export '../local/app_database.dart'
    show
        KategoriData,
        TesData,
        SubtesData,
        StimulusData,
        SoalData,
        PaketTerpasangData,
        AttemptSubtesData;
export '../local/tables/attempt_subtes_table.dart' show SubtesStatus;

/// Status turunan pengerjaan paket tes secara keseluruhan.
enum TesStatus { belumMulai, berjalan, selesai }

/// Ringkasan paket tes dengan agregasi subtes, durasi, dan status turunan.
class TesSummary {
  final TesData tes;
  final int jumlahSubtes;
  final int totalDurasiMenit;
  final TesStatus status;

  const TesSummary({
    required this.tes,
    required this.jumlahSubtes,
    required this.totalDurasiMenit,
    required this.status,
  });
}

/// Item subtes dalam daftar beserta status pengerjaan, jumlah soal aktif, dan data attempt jika ada.
class SubtesItem {
  final SubtesData subtes;
  final int totalSoalAktif;
  final SubtesStatus status;
  final AttemptSubtesData? attempt;

  const SubtesItem({
    required this.subtes,
    this.totalSoalAktif = 0,
    required this.status,
    this.attempt,
  });
}

/// Konten lengkap pengerjaan subtes (metadata subtes, stimulus bacaan, dan soal aktif).
class SubtestContent {
  final SubtesData subtes;
  final List<StimulusData> stimuli;
  final List<SoalData> soalList;

  const SubtestContent({
    required this.subtes,
    required this.stimuli,
    required this.soalList,
  });
}

/// Ringkasan paket terpasang beserta jumlah tes dan total soal aktif.
class PaketItemSummary {
  final PaketTerpasangData paket;
  final int jumlahTes;
  final int jumlahSoal;

  const PaketItemSummary({
    required this.paket,
    required this.jumlahTes,
    required this.jumlahSoal,
  });
}
