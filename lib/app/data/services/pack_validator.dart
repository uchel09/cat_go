/// Hasil validasi paket soal JSON.
class ValidationResult {
  final bool isValid;
  final List<String> errors;
  final List<String> warnings;

  const ValidationResult({
    required this.isValid,
    this.errors = const [],
    this.warnings = const [],
  });

  bool get hasWarnings => warnings.isNotEmpty;
}

/// Validator integritas struktur paket soal JSON (schemaVersion 1).
class PackValidator {
  static const int currentSchemaVersion = 1;

  ValidationResult validate(Map<String, dynamic> json) {
    final List<String> errors = [];
    final List<String> warnings = [];
    final Set<String> seenIds = {};

    void checkId(dynamic id, String context) {
      if (id == null || id.toString().trim().isEmpty) {
        errors.add('$context: ID wajib diisi dan tidak boleh kosong.');
        return;
      }
      final idStr = id.toString();
      if (seenIds.contains(idStr)) {
        errors.add('$context: ID duplikat ditemukan "$idStr".');
      } else {
        seenIds.add(idStr);
      }
    }

    // 1. Validasi schemaVersion
    final schemaVersion = json['schemaVersion'];
    if (schemaVersion == null) {
      errors.add('Header: field "schemaVersion" wajib ada.');
    } else if (schemaVersion is! int || schemaVersion != currentSchemaVersion) {
      errors.add(
        'Header: schemaVersion "$schemaVersion" tidak didukung (didukung: $currentSchemaVersion).',
      );
    }

    // 2. Validasi field utama paket
    final packId = json['packId'];
    if (packId == null || packId.toString().trim().isEmpty) {
      errors.add('Header: field "packId" wajib diisi.');
    } else {
      checkId(packId, 'Paket');
    }

    final packVersion = json['packVersion'];
    if (packVersion == null || packVersion is! int || packVersion < 1) {
      errors.add(
        'Header: field "packVersion" harus berupa integer positif (>= 1).',
      );
    }

    final nama = json['nama'];
    if (nama == null || nama.toString().trim().isEmpty) {
      errors.add('Header: field "nama" paket wajib diisi.');
    }

    // 3. Validasi kategori
    final kategori = json['kategori'];
    if (kategori == null || kategori is! Map<String, dynamic>) {
      errors.add('Kategori: field "kategori" wajib berupa objek.');
    } else {
      final katId = kategori['id'];
      final katNama = kategori['nama'];
      if (katId == null || katId.toString().trim().isEmpty) {
        errors.add('Kategori: field "id" kategori wajib diisi.');
      } else {
        checkId(katId, 'Kategori');
      }
      if (katNama == null || katNama.toString().trim().isEmpty) {
        errors.add('Kategori: field "nama" kategori wajib diisi.');
      }
    }

    // 4. Validasi tes
    final tesList = json['tes'];
    if (tesList == null || tesList is! List || tesList.isEmpty) {
      errors.add(
        'Tes: paket harus memiliki minimal satu tes dalam array "tes".',
      );
      return ValidationResult(
        isValid: errors.isEmpty,
        errors: errors,
        warnings: warnings,
      );
    }

    for (int tIdx = 0; tIdx < tesList.length; tIdx++) {
      final tesItem = tesList[tIdx];
      final tesContext = 'Tes ke-${tIdx + 1}';
      if (tesItem is! Map<String, dynamic>) {
        errors.add('$tesContext: harus berupa objek.');
        continue;
      }

      checkId(tesItem['id'], tesContext);

      if (tesItem['nama'] == null ||
          tesItem['nama'].toString().trim().isEmpty) {
        errors.add('$tesContext: field "nama" wajib diisi.');
      }

      // Validasi subtes
      final subtesList = tesItem['subtes'];
      if (subtesList == null || subtesList is! List || subtesList.isEmpty) {
        errors.add(
          '$tesContext: harus memiliki minimal satu subtes dalam "subtes".',
        );
        continue;
      }

      for (int sIdx = 0; sIdx < subtesList.length; sIdx++) {
        final subtesItem = subtesList[sIdx];
        final subtesContext = '$tesContext -> Subtes ke-${sIdx + 1}';
        if (subtesItem is! Map<String, dynamic>) {
          errors.add('$subtesContext: harus berupa objek.');
          continue;
        }

        final subtesId = subtesItem['id'];
        checkId(subtesId, subtesContext);

        if (subtesItem['nama'] == null ||
            subtesItem['nama'].toString().trim().isEmpty) {
          errors.add('$subtesContext: field "nama" wajib diisi.');
        }

        final durasiMenit = subtesItem['durasiMenit'];
        if (durasiMenit == null || durasiMenit is! int || durasiMenit < 1) {
          errors.add(
            '$subtesContext: field "durasiMenit" harus berupa integer positif.',
          );
        }

        // Validasi stimulus di subtes ini
        final stimulusList = subtesItem['stimulus'];
        final Set<String> subtesStimulusIds = {};
        if (stimulusList != null && stimulusList is List) {
          for (int stIdx = 0; stIdx < stimulusList.length; stIdx++) {
            final stItem = stimulusList[stIdx];
            final stimContext = '$subtesContext -> Stimulus ke-${stIdx + 1}';
            if (stItem is! Map<String, dynamic>) {
              errors.add('$stimContext: harus berupa objek.');
              continue;
            }
            final stimId = stItem['id']?.toString();
            checkId(stimId, stimContext);
            if (stimId != null && stimId.trim().isNotEmpty) {
              subtesStimulusIds.add(stimId);
            }
            if (stItem['isi'] == null ||
                stItem['isi'].toString().trim().isEmpty) {
              errors.add('$stimContext: field "isi" wacana wajib diisi.');
            }
          }
        }

        // Validasi soal di subtes ini
        final soalList = subtesItem['soal'];
        if (soalList == null || soalList is! List || soalList.isEmpty) {
          errors.add(
            '$subtesContext: harus memiliki minimal satu soal dalam "soal".',
          );
          continue;
        }

        final Set<String> referencedStimulusIds = {};
        String? activeStimulusId;
        final Set<String> finishedStimulusIds = {};

        for (int qIdx = 0; qIdx < soalList.length; qIdx++) {
          final soalItem = soalList[qIdx];
          final soalContext = '$subtesContext -> Soal ke-${qIdx + 1}';
          if (soalItem is! Map<String, dynamic>) {
            errors.add('$soalContext: harus berupa objek.');
            continue;
          }

          final soalId = soalItem['id'];
          checkId(soalId, soalContext);

          if (soalItem['teks'] == null ||
              soalItem['teks'].toString().trim().isEmpty) {
            errors.add('$soalContext ($soalId): field "teks" wajib diisi.');
          }

          final opsi = soalItem['opsi'];
          if (opsi == null || opsi is! Map || opsi.isEmpty) {
            errors.add(
              '$soalContext ($soalId): field "opsi" wajib berupa Map pilihan dan tidak boleh kosong.',
            );
          }

          final jawabanBenar = soalItem['jawabanBenar']?.toString();
          if (jawabanBenar == null || jawabanBenar.trim().isEmpty) {
            errors.add(
              '$soalContext ($soalId): field "jawabanBenar" wajib diisi.',
            );
          } else if (opsi is Map && !opsi.containsKey(jawabanBenar)) {
            errors.add(
              '$soalContext ($soalId): jawabanBenar "$jawabanBenar" tidak ada di opsi (${opsi.keys.join(', ')}).',
            );
          }

          // Cek relasi stimulusId
          final stimulusId = soalItem['stimulusId']?.toString();
          if (stimulusId != null && stimulusId.trim().isNotEmpty) {
            if (!subtesStimulusIds.contains(stimulusId)) {
              errors.add(
                '$soalContext ($soalId): stimulusId "$stimulusId" tidak ditemukan pada subtes yang sama ($subtesId).',
              );
            } else {
              referencedStimulusIds.add(stimulusId);
            }

            // Validasi: Soal yang memakai wacana yang sama harus berurutan
            if (stimulusId != activeStimulusId) {
              if (finishedStimulusIds.contains(stimulusId)) {
                errors.add(
                  '$soalContext ($soalId): memakai stimulusId "$stimulusId" yang terputus / tidak berurutan dengan soal sebelumnya yang memakai wacana ini.',
                );
              }
              if (activeStimulusId != null) {
                finishedStimulusIds.add(activeStimulusId);
              }
              activeStimulusId = stimulusId;
            }
          } else {
            if (activeStimulusId != null) {
              finishedStimulusIds.add(activeStimulusId);
              activeStimulusId = null;
            }
          }
        }

        // Peringatan: wacana tanpa soal
        for (final stId in subtesStimulusIds) {
          if (!referencedStimulusIds.contains(stId)) {
            warnings.add(
              '$subtesContext: stimulus "$stId" tidak digunakan oleh soal mana pun.',
            );
          }
        }
      }
    }

    return ValidationResult(
      isValid: errors.isEmpty,
      errors: errors,
      warnings: warnings,
    );
  }
}
