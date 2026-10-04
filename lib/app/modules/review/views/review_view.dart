import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../widgets/stimulus_panel.dart';
import '../controllers/review_controller.dart';

class ReviewView extends GetView<ReviewController> {
  const ReviewView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(() {
          final namaSubtes = controller.subtes.value?.nama ?? 'Pembahasan';
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Pembahasan',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text(
                namaSubtes,
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
              ),
            ],
          );
        }),
        actions: [
          Obx(() {
            if (controller.isLoading.value || controller.soalList.isEmpty) {
              return const SizedBox.shrink();
            }
            return Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildHeaderScoreBadge(
                    icon: Icons.check_circle_rounded,
                    color: Colors.green.shade700,
                    label: '${controller.totalBenar}',
                    tooltip: 'Total Benar',
                  ),
                  const SizedBox(width: 8),
                  _buildHeaderScoreBadge(
                    icon: Icons.cancel_rounded,
                    color: Colors.red.shade700,
                    label: '${controller.totalSalah}',
                    tooltip: 'Total Salah',
                  ),
                  const SizedBox(width: 8),
                  _buildHeaderScoreBadge(
                    icon: Icons.remove_circle_rounded,
                    color: Colors.grey.shade700,
                    label: '${controller.totalKosong}',
                    tooltip: 'Total Tidak Dijawab',
                  ),
                ],
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
                    onPressed: controller.loadReviewData,
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
              'Tidak ada soal untuk ditampilkan.',
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
                        return _buildReviewQuestionArea(context);
                      }

                      if (isWide) {
                        // Layar lebar / tablet: 2 kolom berdampingan
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
                                child: _buildReviewQuestionArea(context),
                              ),
                            ],
                          ),
                        );
                      }

                      // Portrait: panel wacana di atas, soal di bawah
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
                              child: _buildReviewQuestionArea(context),
                            ),
                          ],
                        ),
                      );
                    });
                  },
                ),
              ),

              // Bilah Navigasi Bawah
              _buildBottomControlBar(context),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildHeaderScoreBadge({
    required IconData icon,
    required Color color,
    required String label,
    required String tooltip,
  }) {
    return Tooltip(
      message: tooltip,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: color),
            const SizedBox(width: 3),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Area tampilan nomor soal, status jawaban, teks soal, opsi read-only, dan pembahasan
  Widget _buildReviewQuestionArea(BuildContext context) {
    return Obx(() {
      final theme = Theme.of(context);
      final soal = controller.currentSoal;
      if (soal == null) return const SizedBox.shrink();

      final noSoal = controller.currentIndex.value + 1;
      final totalSoal = controller.soalList.length;
      final opsiMap = soal.opsi;
      final sortedKeys = opsiMap.keys.toList()..sort();
      final status = controller.currentSoalStatus;

      return Scrollbar(
        controller: controller.questionScrollController,
        child: SingleChildScrollView(
          controller: controller.questionScrollController,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          physics: const ClampingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Nomor Soal & Badge Evaluasi
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
                  _buildEvaluationBadge(status),
                ],
              ),
              const SizedBox(height: 14),

              // Teks Soal
              SelectableText(
                soal.teks,
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontSize: 16,
                  height: 1.5,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 18),

              // Daftar Opsi Jawaban (Read-Only)
              Column(
                children: sortedKeys.map((key) {
                  final text = opsiMap[key] ?? '';
                  final userAns = controller.currentSoalUserAnswer;
                  final isUserAnswer = (userAns?.toUpperCase() == key.toUpperCase());
                  final isCorrectKey =
                      (key.toUpperCase() == soal.jawabanBenar.toUpperCase());

                  return _buildReviewOptionCard(
                    context: context,
                    huruf: key,
                    teksOpsi: text,
                    isUserAnswer: isUserAnswer,
                    isCorrectKey: isCorrectKey,
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),

              // Kotak Penjelasan / Pembahasan
              _buildPembahasanCard(context, soal.pembahasan),
              const SizedBox(height: 24),
            ],
          ),
        ),
      );
    });
  }

  /// Badge status evaluasi soal (Benar / Salah / Tidak Dijawab)
  Widget _buildEvaluationBadge(ReviewItemStatus status) {
    Color bgColor;
    Color textColor;
    IconData icon;
    String text;

    switch (status) {
      case ReviewItemStatus.benar:
        bgColor = Colors.green.shade50;
        textColor = Colors.green.shade800;
        icon = Icons.check_circle_rounded;
        text = 'BENAR';
        break;
      case ReviewItemStatus.salah:
        bgColor = Colors.red.shade50;
        textColor = Colors.red.shade800;
        icon = Icons.cancel_rounded;
        text = 'SALAH';
        break;
      case ReviewItemStatus.kosong:
        bgColor = Colors.grey.shade100;
        textColor = Colors.grey.shade700;
        icon = Icons.remove_circle_outline_rounded;
        text = 'TIDAK DIJAWAB';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: textColor.withValues(alpha: 0.4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 15, color: textColor),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }

  /// Kartu opsi jawaban read-only dengan indikator jawaban user & kunci jawaban
  Widget _buildReviewOptionCard({
    required BuildContext context,
    required String huruf,
    required String teksOpsi,
    required bool isUserAnswer,
    required bool isCorrectKey,
  }) {
    Color cardBg;
    Color borderColor;
    Color circleBg;
    Color circleTextColor;
    Widget? indicatorBadge;

    if (isUserAnswer && isCorrectKey) {
      // Jawaban user benar
      cardBg = Colors.green.shade50;
      borderColor = Colors.green.shade600;
      circleBg = Colors.green.shade600;
      circleTextColor = Colors.white;
      indicatorBadge = _buildOptionBadge(
        label: 'Jawaban Anda (Benar)',
        bgColor: Colors.green.shade100,
        textColor: Colors.green.shade900,
        icon: Icons.check_circle_rounded,
      );
    } else if (isUserAnswer && !isCorrectKey) {
      // Jawaban user salah
      cardBg = Colors.red.shade50;
      borderColor = Colors.red.shade600;
      circleBg = Colors.red.shade600;
      circleTextColor = Colors.white;
      indicatorBadge = _buildOptionBadge(
        label: 'Jawaban Anda (Salah)',
        bgColor: Colors.red.shade100,
        textColor: Colors.red.shade900,
        icon: Icons.cancel_rounded,
      );
    } else if (!isUserAnswer && isCorrectKey) {
      // Kunci jawaban (user memilih opsi lain atau tidak menjawab)
      cardBg = Colors.green.shade50.withValues(alpha: 0.6);
      borderColor = Colors.green.shade500;
      circleBg = Colors.green.shade500;
      circleTextColor = Colors.white;
      indicatorBadge = _buildOptionBadge(
        label: 'Kunci Jawaban',
        bgColor: Colors.green.shade100,
        textColor: Colors.green.shade900,
        icon: Icons.check_rounded,
      );
    } else {
      // Opsi netral
      cardBg = Colors.white;
      borderColor = Colors.grey.shade300;
      circleBg = Colors.grey.shade200;
      circleTextColor = Colors.black87;
      indicatorBadge = null;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: borderColor,
          width: (isUserAnswer || isCorrectKey) ? 1.8 : 1.0,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Lingkaran Huruf Opsi
              Container(
                width: 30,
                height: 30,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: circleBg,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  huruf,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: circleTextColor,
                  ),
                ),
              ),
              const SizedBox(width: 12),

              // Teks Opsi Jawaban
              Expanded(
                child: SelectableText(
                  teksOpsi,
                  style: const TextStyle(
                    fontSize: 15,
                    height: 1.4,
                    color: Colors.black87,
                  ),
                ),
              ),
            ],
          ),

          // Badge Keterangan (jika relevan)
          if (indicatorBadge != null) ...[
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.only(left: 42),
              child: indicatorBadge,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildOptionBadge({
    required String label,
    required Color bgColor,
    required Color textColor,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: textColor),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }

  /// Kotak Pembahasan Soal
  Widget _buildPembahasanCard(BuildContext context, String? pembahasan) {
    final isi = (pembahasan == null || pembahasan.trim().isEmpty)
        ? 'Belum ada penjelasan khusus untuk soal ini.'
        : pembahasan;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.blue.shade50.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.blue.shade200),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.lightbulb_rounded, size: 20, color: Colors.amber.shade800),
              const SizedBox(width: 8),
              Text(
                'Pembahasan',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade900,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          SelectableText(
            isi,
            style: TextStyle(
              fontSize: 14.5,
              height: 1.5,
              color: Colors.blueGrey.shade900,
            ),
          ),
        ],
      ),
    );
  }

  /// Bilah Kontrol Bawah (Sebelumnya, Berikutnya, Daftar Soal)
  Widget _buildBottomControlBar(BuildContext context) {
    final isNarrow = MediaQuery.of(context).size.width < 380;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: isNarrow ? 8 : 16, vertical: 10),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        border: Border(top: BorderSide(color: Colors.grey.shade200)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 6,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Obx(() {
        final btnPadding = EdgeInsets.symmetric(horizontal: isNarrow ? 6 : 12);

        return Row(
          children: [
            // Tombol Sebelumnya
            Expanded(
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
            SizedBox(width: isNarrow ? 6 : 12),

            // Tombol Berikutnya
            Expanded(
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
            SizedBox(width: isNarrow ? 6 : 12),

            // Tombol Daftar Soal (Modal BottomSheet)
            IconButton.filledTonal(
              onPressed: () => _showDaftarSoalBottomSheet(context),
              icon: const Icon(Icons.grid_view_rounded, size: 20),
              tooltip: 'Daftar Nomor Soal',
              visualDensity: VisualDensity.compact,
            ),
          ],
        );
      }),
    );
  }

  /// BottomSheet Daftar Nomor Soal (Warna: Benar, Salah, Kosong)
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

                  // Legenda Warna (Benar, Salah, Kosong)
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
                          final isCurrent = controller.currentIndex.value == index;
                          final status = controller.getStatusAtIndex(index);

                          Color bgColor;
                          Color textColor;
                          Border? border;

                          switch (status) {
                            case ReviewItemStatus.benar:
                              bgColor = Colors.green.shade600;
                              textColor = Colors.white;
                              break;
                            case ReviewItemStatus.salah:
                              bgColor = Colors.red.shade600;
                              textColor = Colors.white;
                              break;
                            case ReviewItemStatus.kosong:
                              bgColor = Colors.grey.shade200;
                              textColor = Colors.black87;
                              break;
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildLegendaItem(color: Colors.green.shade600, label: 'Benar'),
        _buildLegendaItem(color: Colors.red.shade600, label: 'Salah'),
        _buildLegendaItem(color: Colors.grey.shade300, label: 'Kosong'),
      ],
    );
  }

  Widget _buildLegendaItem({required Color color, required String label}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}
