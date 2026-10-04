import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../widgets/stimulus_panel.dart';
import '../controllers/exam_controller.dart';

class ExamView extends GetView<ExamController> {
  const ExamView({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        _showExitConfirmationDialog(context);
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            tooltip: 'Kembali',
            onPressed: () => _showExitConfirmationDialog(context),
          ),
          title: Obx(() {
            final namaSubtes = controller.subtes.value?.nama ?? 'Ujian';
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  namaSubtes,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                _buildTimerChip(context),
              ],
            );
          }),
          actions: [
            Obx(() {
              if (controller.isLoading.value) return const SizedBox.shrink();
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: FilledButton.tonal(
                  onPressed: controller.isSubmitting.value
                      ? null
                      : () => _showSelesaiConfirmationDialog(context),
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.green.shade50,
                    foregroundColor: Colors.green.shade900,
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  ),
                  child: const Text(
                    'Selesai',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              );
            }),
          ],
          elevation: 0.5,
        ),
        body: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          if (controller.errorMessage.value.isNotEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, size: 56, color: Colors.red.shade400),
                    const SizedBox(height: 16),
                    Text(
                      controller.errorMessage.value,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 15),
                    ),
                    const SizedBox(height: 16),
                    FilledButton(
                      onPressed: controller.loadData,
                      child: const Text('Coba Lagi'),
                    ),
                  ],
                ),
              ),
            );
          }

          if (controller.soalList.isEmpty) {
            return const Center(
              child: Text(
                'Tidak ada soal aktif pada subtes ini.',
                style: TextStyle(fontSize: 16),
              ),
            );
          }

          return SafeArea(
            child: Column(
              children: [
                // Area Soal & Wacana Responsif
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final isWide = constraints.maxWidth >= 600;
                      return Obx(() {
                        final currentStimulus = controller.currentStimulus;
                        final hasStimulus = currentStimulus != null;

                        if (!hasStimulus) {
                          // Soal tanpa wacana: memakai seluruh layar
                          return _buildQuestionArea(context);
                        }

                        if (isWide) {
                          // Layar lebar / landscape: 2 kolom berdampingan
                          return Padding(
                            padding: const EdgeInsets.all(12),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Expanded(
                                  flex: 5,
                                  child: StimulusPanel(
                                    stimulus: currentStimulus,
                                    soalRangeLabel: controller.currentStimulusRangeLabel,
                                    isCollapsed: false,
                                    isTwoColumn: true,
                                    onToggleCollapse: () {},
                                    scrollController: controller.stimulusScrollController,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  flex: 6,
                                  child: _buildQuestionArea(context),
                                ),
                              ],
                            ),
                          );
                        }

                        // Portrait: wacana di atas (bisa diciutkan), soal di bawah
                        return Padding(
                          padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
                          child: Column(
                            children: [
                              StimulusPanel(
                                stimulus: currentStimulus,
                                soalRangeLabel: controller.currentStimulusRangeLabel,
                                isCollapsed: controller.isStimulusCollapsed.value,
                                maxHeight: constraints.maxHeight * 0.40,
                                onToggleCollapse: controller.toggleStimulusCollapse,
                                scrollController: controller.stimulusScrollController,
                              ),
                              const SizedBox(height: 8),
                              Expanded(
                                child: _buildQuestionArea(context),
                              ),
                            ],
                          ),
                        );
                      });
                    },
                  ),
                ),

                // Bilah Navigasi Bawah (Prev, Ragu, Next, Daftar Soal)
                _buildBottomControlBar(context),
              ],
            ),
          );
        }),
      ),
    );
  }

  /// Chip timer hitung mundur dengan indikator warna merah saat <= 1 menit.
  Widget _buildTimerChip(BuildContext context) {
    return Obx(() {
      final isUrgent = controller.isTimerUrgent;
      final timerText = controller.formattedTimer;

      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.timer_outlined,
            size: 13,
            color: isUrgent ? Colors.red.shade700 : Colors.blueGrey.shade700,
          ),
          const SizedBox(width: 4),
          Text(
            timerText,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: isUrgent ? Colors.red.shade700 : Colors.blueGrey.shade800,
            ),
          ),
        ],
      );
    });
  }

  /// Area tampilan soal dan opsi jawaban dengan scroll mandiri.
  Widget _buildQuestionArea(BuildContext context) {
    return Obx(() {
      final theme = Theme.of(context);
      final soal = controller.currentSoal;
      if (soal == null) return const SizedBox.shrink();

      final noSoal = controller.currentIndex.value + 1;
      final totalSoal = controller.soalList.length;
      final opsiMap = soal.opsi;
      final sortedKeys = opsiMap.keys.toList()..sort();

      return Scrollbar(
        controller: controller.questionScrollController,
        child: SingleChildScrollView(
          controller: controller.questionScrollController,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          physics: const ClampingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Baris Header Nomor Soal & Status Ragu
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'Soal $noSoal dari $totalSoal',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onPrimaryContainer,
                      ),
                    ),
                  ),
                  const Spacer(),
                  if (controller.isCurrentRagu)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.amber.shade100,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.amber.shade700),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.flag_rounded, size: 14, color: Colors.amber.shade900),
                          const SizedBox(width: 4),
                          Text(
                            'Ragu-ragu',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.amber.shade900,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 14),

              // Teks Soal
              SelectableText(
                soal.teks,
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontSize: 15.5,
                  height: 1.5,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 18),

              // Opsi Jawaban (A, B, C, D, E)
              ...sortedKeys.map((key) {
                final text = opsiMap[key]?.toString() ?? '';
                final isSelected = controller.currentAnswer == key;
                return _buildOptionTile(
                  context: context,
                  optionKey: key,
                  optionText: text,
                  isSelected: isSelected,
                  onTap: () => controller.pilihOpsi(key),
                );
              }),
              const SizedBox(height: 16),
            ],
          ),
        ),
      );
    });
  }

  /// Item satu pilihan jawaban (A-E)
  Widget _buildOptionTile({
    required BuildContext context,
    required String optionKey,
    required String optionText,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isSelected ? theme.colorScheme.primary.withValues(alpha: 0.08) : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? theme.colorScheme.primary : Colors.grey.shade300,
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 32,
                height: 32,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected ? theme.colorScheme.primary : Colors.grey.shade100,
                  border: Border.all(
                    color: isSelected ? theme.colorScheme.primary : Colors.grey.shade400,
                  ),
                ),
                child: Text(
                  optionKey,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: isSelected ? Colors.white : Colors.black87,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    optionText,
                    style: TextStyle(
                      fontSize: 14.5,
                      height: 1.4,
                      color: isSelected ? theme.colorScheme.primary : Colors.black87,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Baris kontrol navigasi bawah (Prev, Ragu, Next, Daftar Soal)
  Widget _buildBottomControlBar(BuildContext context) {
    final isNarrow = MediaQuery.of(context).size.width < 380;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: isNarrow ? 8 : 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 6,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Obx(() {
        final btnPadding = EdgeInsets.symmetric(horizontal: isNarrow ? 4 : 8);

        return Row(
          children: [
            // Tombol Sebelumnya
            Expanded(
              flex: 3,
              child: OutlinedButton.icon(
                onPressed: controller.isFirstQuestion ? null : controller.prevQuestion,
                icon: const Icon(Icons.chevron_left_rounded, size: 18),
                label: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(isNarrow ? 'Prev' : 'Sebelumnya'),
                ),
                style: OutlinedButton.styleFrom(
                  padding: btnPadding,
                  visualDensity: VisualDensity.compact,
                ),
              ),
            ),
            SizedBox(width: isNarrow ? 4 : 8),

            // Tombol Ragu-ragu (Toggle)
            Expanded(
              flex: 3,
              child: FilledButton.tonalIcon(
                onPressed: controller.toggleRagu,
                icon: Icon(
                  controller.isCurrentRagu ? Icons.flag_rounded : Icons.outlined_flag_rounded,
                  size: 16,
                  color: controller.isCurrentRagu ? Colors.amber.shade900 : null,
                ),
                label: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    'Ragu',
                    style: TextStyle(
                      color: controller.isCurrentRagu ? Colors.amber.shade900 : null,
                      fontWeight: controller.isCurrentRagu ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ),
                style: FilledButton.styleFrom(
                  padding: btnPadding,
                  visualDensity: VisualDensity.compact,
                  backgroundColor:
                      controller.isCurrentRagu ? Colors.amber.shade100 : Colors.grey.shade100,
                ),
              ),
            ),
            SizedBox(width: isNarrow ? 4 : 8),

            // Tombol Berikutnya
            Expanded(
              flex: 3,
              child: FilledButton.icon(
                onPressed: controller.isLastQuestion ? null : controller.nextQuestion,
                icon: const Icon(Icons.chevron_right_rounded, size: 18),
                label: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(isNarrow ? 'Next' : 'Berikutnya'),
                ),
                style: FilledButton.styleFrom(
                  padding: btnPadding,
                  visualDensity: VisualDensity.compact,
                ),
              ),
            ),
            SizedBox(width: isNarrow ? 4 : 8),

            // Tombol Daftar Soal
            IconButton.filledTonal(
              onPressed: () => _showDaftarSoalBottomSheet(context),
              icon: const Icon(Icons.grid_view_rounded, size: 20),
              tooltip: 'Daftar Soal',
              visualDensity: VisualDensity.compact,
            ),
          ],
        );
      }),
    );
  }

  /// BottomSheet Daftar Nomor Soal (GridView)
  void _showDaftarSoalBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return DraggableScrollableSheet(
          initialChildSize: 0.6,
          minChildSize: 0.4,
          maxChildSize: 0.9,
          expand: false,
          builder: (context, scrollController) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
              child: Column(
                children: [
                  // Handle Bar
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Daftar Nomor Soal',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),

                  // Legenda Warna
                  _buildLegendaRow(),
                  const Divider(height: 24),

                  // Grid Nomor Soal
                  Expanded(
                    child: Obx(() {
                      final total = controller.soalList.length;
                      return GridView.builder(
                        controller: scrollController,
                        itemCount: total,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 5,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          childAspectRatio: 1.1,
                        ),
                        itemBuilder: (context, index) {
                          final s = controller.soalList[index];
                          final isCurrent = controller.currentIndex.value == index;
                          final isAnswered = controller.jawabanMap.containsKey(s.id);
                          final isRagu = controller.raguSet.contains(s.id);

                          Color bgColor;
                          Color textColor;
                          Border? border;

                          if (isRagu) {
                            bgColor = Colors.amber.shade500;
                            textColor = Colors.white;
                          } else if (isAnswered) {
                            bgColor = Colors.green.shade600;
                            textColor = Colors.white;
                          } else {
                            bgColor = Colors.grey.shade100;
                            textColor = Colors.black87;
                          }

                          if (isCurrent) {
                            border = Border.all(color: Colors.blue.shade900, width: 2.5);
                          }

                          return InkWell(
                            onTap: () {
                              controller.goToQuestion(index);
                              Navigator.pop(ctx);
                            },
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: bgColor,
                                borderRadius: BorderRadius.circular(10),
                                border: border,
                              ),
                              child: Text(
                                '${index + 1}',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: textColor,
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    }),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildLegendaRow() {
    return Wrap(
      spacing: 12,
      runSpacing: 8,
      alignment: WrapAlignment.center,
      children: [
        _buildLegendaItem(Colors.green.shade600, 'Sudah Dijawab'),
        _buildLegendaItem(Colors.amber.shade500, 'Ragu-ragu'),
        _buildLegendaItem(Colors.grey.shade200, 'Belum Dijawab', textColor: Colors.black87),
        _buildLegendaItem(
          Colors.white,
          'Sedang Dibuka',
          textColor: Colors.blue.shade900,
          border: Border.all(color: Colors.blue.shade900, width: 2),
        ),
      ],
    );
  }

  Widget _buildLegendaItem(Color color, String label, {Color? textColor, BoxBorder? border}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
            border: border ?? Border.all(color: Colors.grey.shade400, width: 0.5),
          ),
        ),
        const SizedBox(width: 5),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: textColor ?? Colors.grey.shade800,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  /// Dialog konfirmasi selesai ujian
  void _showSelesaiConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Kumpulkan Ujian?'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Pastikan seluruh jawaban Anda telah diperiksa sebelum mengumpulkan.'),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    _buildStatRow('Terjawab', '${controller.totalTerjawab}', Colors.green.shade800),
                    const Divider(height: 14),
                    _buildStatRow('Ragu-ragu', '${controller.totalRagu}', Colors.amber.shade900),
                    const Divider(height: 14),
                    _buildStatRow('Belum Dijawab', '${controller.totalKosong}', Colors.red.shade800),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Lanjut Mengerjakan'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(ctx);
                controller.submitSubtes();
              },
              style: FilledButton.styleFrom(
                backgroundColor: Colors.green.shade700,
              ),
              child: const Text('Ya, Selesaikan'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildStatRow(String label, String value, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 13, color: Colors.black87)),
        Text(
          value,
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: color),
        ),
      ],
    );
  }

  /// Dialog konfirmasi pencegatan tombol back (PopScope)
  void _showExitConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Tinggalkan Ujian?'),
          content: const Text(
            'Waktu ujian akan tetap berjalan meskipun Anda meninggalkan halaman ini.\n\n'
            'Anda dapat melanjutkan kembali subtes ini dari daftar subtes selama batas waktu belum berakhir.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Tetap di Sini'),
            ),
            FilledButton.tonal(
              onPressed: () {
                Navigator.pop(ctx);
                Get.back();
              },
              child: const Text('Keluar'),
            ),
          ],
        );
      },
    );
  }
}
