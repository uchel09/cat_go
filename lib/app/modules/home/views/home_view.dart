import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/models/content_models.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'CAT Go',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            Text(
              'Simulasi Ujian Offline',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.inventory_2_outlined),
            tooltip: 'Paket Tes',
            onPressed: () => Get.toNamed('/packs'),
          ),
        ],
        elevation: 0.5,
      ),
      body: Obx(() {
        // 1. Loading state saat inisialisasi awal
        if (controller.isLoading.value) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircularProgressIndicator(),
                const SizedBox(height: 16),
                Text(
                  controller.loadingMessage.value,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.grey.shade700,
                  ),
                ),
              ],
            ),
          );
        }

        // 2. Empty state jika belum ada kategori sama sekali
        if (controller.kategoriList.isEmpty) {
          return _buildEmptyState(
            context,
            icon: Icons.folder_open_outlined,
            title: 'Belum Ada Kategori',
            message: 'Paket soal simulasi belum terpasang di perangkat.',
            action: FilledButton.icon(
              onPressed: () => Get.toNamed('/packs'),
              icon: const Icon(Icons.inventory_2_outlined),
              label: const Text('Kelola Paket Soal'),
            ),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Bar navigasi kategori di atas (ChoiceChip horizontal)
            _buildCategorySelector(context),
            const Divider(height: 1),

            // Daftar kartu tes kategori aktif
            Expanded(child: _buildTesContent(context)),
          ],
        );
      }),
    );
  }

  /// Widget pemilih kategori horizontal
  Widget _buildCategorySelector(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.surface,
      width: double.infinity,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          children: controller.kategoriList.map((kat) {
            final isSelected = controller.selectedKategoriId.value == kat.id;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: ChoiceChip(
                label: Text(
                  kat.nama,
                  style: TextStyle(
                    fontWeight: isSelected
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                ),
                selected: isSelected,
                onSelected: (selected) {
                  if (selected) {
                    controller.selectKategori(kat.id);
                  }
                },
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  /// Konten tes kategori aktif
  Widget _buildTesContent(BuildContext context) {
    if (controller.isLoadingTes.value) {
      return const Center(child: CircularProgressIndicator());
    }

    if (controller.tesList.isEmpty) {
      return _buildEmptyState(
        context,
        icon: Icons.quiz_outlined,
        title: 'Belum Ada Tes',
        message: 'Tidak ada paket tes yang tersedia untuk kategori ini.',
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: controller.tesList.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final summary = controller.tesList[index];
        return _buildTesCard(context, summary);
      },
    );
  }

  /// Kartu tes responsif dan modern
  Widget _buildTesCard(BuildContext context, TesSummary summary) {
    final theme = Theme.of(context);
    final statusConfig = _getStatusConfig(summary.status);

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade300, width: 1),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => controller.navigateToSubtest(summary.tes.id),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Baris judul & status badge
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      summary.tes.nama,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: statusConfig.backgroundColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          statusConfig.icon,
                          size: 14,
                          color: statusConfig.textColor,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          statusConfig.label,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: statusConfig.textColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Baris metadata: jumlah subtes & total durasi
              Row(
                children: [
                  Icon(
                    Icons.layers_outlined,
                    size: 16,
                    color: Colors.grey.shade700,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '${summary.jumlahSubtes} Subtes',
                    style: TextStyle(fontSize: 13, color: Colors.grey.shade800),
                  ),
                  const SizedBox(width: 16),
                  Icon(
                    Icons.schedule_outlined,
                    size: 16,
                    color: Colors.grey.shade700,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '${summary.totalDurasiMenit} Menit',
                    style: TextStyle(fontSize: 13, color: Colors.grey.shade800),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // Area Tombol Aksi
              if (summary.status == TesStatus.selesai) ...[
                const Divider(),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () =>
                            controller.lihatPembahasanTes(summary.tes.id),
                        icon: const Icon(Icons.menu_book, size: 16),
                        label: const Text('Pembahasan'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () =>
                            controller.konfirmasiUlangiTes(context, summary),
                        icon: const Icon(Icons.refresh, size: 16),
                        label: const Text('Ulangi Tes'),
                      ),
                    ),
                  ],
                ),
              ] else if (summary.status == TesStatus.berjalan) ...[
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.tonalIcon(
                    onPressed: () =>
                        controller.navigateToSubtest(summary.tes.id),
                    icon: const Icon(Icons.arrow_forward, size: 18),
                    label: const Text('Lanjutkan'),
                  ),
                ),
              ] else ...[
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: () =>
                        controller.navigateToSubtest(summary.tes.id),
                    icon: const Icon(Icons.play_arrow, size: 18),
                    label: const Text('Mulai Tes'),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  /// Konfigurasi tampilan status kartu tes
  _StatusConfig _getStatusConfig(TesStatus status) {
    switch (status) {
      case TesStatus.belumMulai:
        return _StatusConfig(
          label: 'Belum dikerjakan',
          textColor: Colors.blueGrey.shade800,
          backgroundColor: Colors.blueGrey.shade50,
          icon: Icons.radio_button_unchecked,
        );
      case TesStatus.berjalan:
        return _StatusConfig(
          label: 'Sedang dikerjakan',
          textColor: Colors.orange.shade900,
          backgroundColor: Colors.orange.shade50,
          icon: Icons.timelapse,
        );
      case TesStatus.selesai:
        return _StatusConfig(
          label: 'Selesai',
          textColor: Colors.green.shade900,
          backgroundColor: Colors.green.shade50,
          icon: Icons.check_circle_outline,
        );
    }
  }

  /// Tampilan state kosong
  Widget _buildEmptyState(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String message,
    Widget? action,
  }) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 64, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
            ),
            if (action != null) ...[
              const SizedBox(height: 20),
              action,
            ],
          ],
        ),
      ),
    );
  }
}

class _StatusConfig {
  final String label;
  final Color textColor;
  final Color backgroundColor;
  final IconData icon;

  const _StatusConfig({
    required this.label,
    required this.textColor,
    required this.backgroundColor,
    required this.icon,
  });
}
