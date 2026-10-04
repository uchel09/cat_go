import 'dart:async';
import 'package:drift/drift.dart';

import '../local/app_database.dart';
import '../local/tables/attempt_subtes_table.dart';
import '../models/exam_models.dart';
import 'exam_repository.dart';

class ExamRepositoryDrift implements ExamRepository {
  final AppDatabase _db;

  ExamRepositoryDrift(this._db);

  @override
  Future<SubtestProgress?> getProgresSubtes(String subtesId) async {
    final attempt = await (_db.select(
      _db.attemptSubtes,
    )..where((tbl) => tbl.subtesId.equals(subtesId))).getSingleOrNull();
    if (attempt == null) return null;

    final answers = await (_db.select(
      _db.jawaban,
    )..where((tbl) => tbl.subtesId.equals(subtesId))).get();
    final doubts = await (_db.select(
      _db.ragu,
    )..where((tbl) => tbl.subtesId.equals(subtesId))).get();

    return SubtestProgress(
      attempt: attempt,
      jawabanMap: {for (final a in answers) a.soalId: a.opsi},
      raguSet: {for (final r in doubts) r.soalId},
    );
  }

  @override
  Stream<SubtestProgress?> watchProgresSubtes(String subtesId) {
    late StreamController<SubtestProgress?> controller;
    StreamSubscription? sub1;
    StreamSubscription? sub2;
    StreamSubscription? sub3;

    AttemptSubtesData? latestAttempt;
    bool hasAttempt = false;
    List<JawabanData> latestJawaban = [];
    List<RaguData> latestRagu = [];

    void emitLatest() {
      if (!controller.isClosed && hasAttempt) {
        if (latestAttempt == null) {
          controller.add(null);
        } else {
          final jMap = {for (final j in latestJawaban) j.soalId: j.opsi};
          final rSet = {for (final r in latestRagu) r.soalId};
          controller.add(
            SubtestProgress(
              attempt: latestAttempt!,
              jawabanMap: jMap,
              raguSet: rSet,
            ),
          );
        }
      }
    }

    controller = StreamController<SubtestProgress?>.broadcast(
      onListen: () {
        sub1 =
            (_db.select(_db.attemptSubtes)
                  ..where((tbl) => tbl.subtesId.equals(subtesId)))
                .watchSingleOrNull()
                .listen((att) {
                  latestAttempt = att;
                  hasAttempt = true;
                  emitLatest();
                });
        sub2 =
            (_db.select(_db.jawaban)
                  ..where((tbl) => tbl.subtesId.equals(subtesId)))
                .watch()
                .listen((list) {
                  latestJawaban = list;
                  emitLatest();
                });
        sub3 =
            (_db.select(_db.ragu)
                  ..where((tbl) => tbl.subtesId.equals(subtesId)))
                .watch()
                .listen((list) {
                  latestRagu = list;
                  emitLatest();
                });
      },
      onCancel: () {
        sub1?.cancel();
        sub2?.cancel();
        sub3?.cancel();
      },
    );

    return controller.stream;
  }

  @override
  Future<void> mulaiSubtes(String subtesId, DateTime endTime) async {
    final totalActiveSoal =
        await (_db.select(_db.soal)..where(
              (tbl) => tbl.subtesId.equals(subtesId) & tbl.aktif.equals(true),
            ))
            .get()
            .then((list) => list.length);

    final now = DateTime.now();
    await _db.into(_db.attemptSubtes).insertOnConflictUpdate(
      AttemptSubtesCompanion(
        subtesId: Value(subtesId),
        status: const Value(SubtesStatus.berjalan),
        endTime: Value(endTime),
        mulaiAt: Value(now),
        totalSoal: Value(totalActiveSoal),
      ),
    );
  }

  @override
  Future<void> simpanJawaban(
    String subtesId,
    String soalId,
    String opsi,
  ) async {
    await _db
        .into(_db.jawaban)
        .insertOnConflictUpdate(
          JawabanCompanion.insert(
            subtesId: subtesId,
            soalId: soalId,
            opsi: opsi,
          ),
        );
  }

  @override
  Future<void> setRagu(String subtesId, String soalId, bool isRagu) async {
    if (isRagu) {
      await _db
          .into(_db.ragu)
          .insertOnConflictUpdate(
            RaguCompanion.insert(subtesId: subtesId, soalId: soalId),
          );
    } else {
      await (_db.delete(_db.ragu)..where(
            (tbl) => tbl.subtesId.equals(subtesId) & tbl.soalId.equals(soalId),
          ))
          .go();
    }
  }

  @override
  Future<SubtestScoreResult> selesaikanSubtes(String subtesId) async {
    return await _db.transaction(() async {
      final soals =
          await (_db.select(_db.soal)..where(
                (tbl) => tbl.subtesId.equals(subtesId) & tbl.aktif.equals(true),
              ))
              .get();
      final answers = await (_db.select(
        _db.jawaban,
      )..where((tbl) => tbl.subtesId.equals(subtesId))).get();

      final answerMap = {for (final a in answers) a.soalId: a.opsi};

      int benar = 0;
      int salah = 0;
      int kosong = 0;

      for (final s in soals) {
        final userAns = answerMap[s.id];
        if (userAns == null || userAns.trim().isEmpty) {
          kosong++;
        } else if (userAns.trim().toUpperCase() ==
            s.jawabanBenar.trim().toUpperCase()) {
          benar++;
        } else {
          salah++;
        }
      }

      final total = soals.length;
      final now = DateTime.now();

      final existing = await (_db.select(
        _db.attemptSubtes,
      )..where((tbl) => tbl.subtesId.equals(subtesId))).getSingleOrNull();

      if (existing == null) {
        await _db
            .into(_db.attemptSubtes)
            .insert(
              AttemptSubtesCompanion.insert(
                subtesId: subtesId,
                status: SubtesStatus.selesai,
                selesaiAt: Value(now),
                benar: Value(benar),
                salah: Value(salah),
                kosong: Value(kosong),
                totalSoal: Value(total),
              ),
            );
      } else {
        await (_db.update(
          _db.attemptSubtes,
        )..where((tbl) => tbl.subtesId.equals(subtesId))).write(
          AttemptSubtesCompanion(
            status: const Value(SubtesStatus.selesai),
            selesaiAt: Value(now),
            benar: Value(benar),
            salah: Value(salah),
            kosong: Value(kosong),
            totalSoal: Value(total),
          ),
        );
      }

      return SubtestScoreResult(
        benar: benar,
        salah: salah,
        kosong: kosong,
        totalSoal: total,
      );
    });
  }

  @override
  Future<void> ulangiTes(String tesId) async {
    await _db.transaction(() async {
      final subtests = await (_db.select(
        _db.subtes,
      )..where((tbl) => tbl.tesId.equals(tesId))).get();
      final subtestIds = subtests.map((s) => s.id).toList();
      if (subtestIds.isEmpty) return;

      await (_db.delete(
        _db.jawaban,
      )..where((tbl) => tbl.subtesId.isIn(subtestIds))).go();
      await (_db.delete(
        _db.ragu,
      )..where((tbl) => tbl.subtesId.isIn(subtestIds))).go();
      await (_db.delete(
        _db.attemptSubtes,
      )..where((tbl) => tbl.subtesId.isIn(subtestIds))).go();
    });
  }
}
