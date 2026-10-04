import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/models/content_models.dart';
import '../controllers/subtes_controller.dart';

class SubtesView extends GetView<SubtesController> {
  const SubtesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: controller.backToListTes,
          tooltip: 'Kembali ke List Tes',
        ),
        title: Obx(
          () => Text(
            controller.tesNama.value.isEmpty ? 'Daftar Subtes' : controller.tesNama.value,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
        ),
        elevation: 0.5,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.subtesList.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.inventory_2_outlined, size: 64, color: Colors.grey.shade400),
                  const SizedBox(height: 16),
                  const Text(
                    'Belum Ada Subtes',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Paket tes ini belum memiliki daftar subtes.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                  ),
                ],
              ),
            ),
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: controller.subtesList.length,
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final item = controller.subtesList[index];
            return _buildSubtesCard(context, item);
          },
        );
      }),
    );
  }

  Widget _buildSubtesCard(BuildContext context, SubtesItem item) {
    final theme = Theme.of(context);
    final statusConfig = _getStatusConfig(item.status);

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade300, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Baris Judul Subtes & Badge Status
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    item.subtes.nama,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusConfig.backgroundColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(statusConfig.icon, size: 14, color: statusConfig.textColor),
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

            // Baris Metadata: Jumlah Soal Aktif & Durasi
            Row(
              children: [
                Icon(Icons.quiz_outlined, size: 16, color: Colors.grey.shade700),
                const SizedBox(width: 6),
                Text(
                  '${item.totalSoalAktif} Soal',
                  style: TextStyle(fontSize: 13, color: Colors.grey.shade800),
                ),
                const SizedBox(width: 16),
                Icon(Icons.timer_outlined, size: 16, color: Colors.grey.shade700),
                const SizedBox(width: 6),
                Text(
                  '${item.subtes.durasiMenit} Menit',
                  style: TextStyle(fontSize: 13, color: Colors.grey.shade800),
                ),
              ],
            ),

            // Jika status selesai dan memiliki snapshot hasil, tampilkan ringkasan skor
            if (item.status == SubtesStatus.selesai && item.attempt != null) ...[
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Hasil: ${item.attempt?.benar ?? 0} Benar • ${item.attempt?.salah ?? 0} Salah • ${item.attempt?.kosong ?? 0} Kosong',
                  style: TextStyle(fontSize: 12, color: Colors.green.shade900, fontWeight: FontWeight.w500),
                ),
              ),
            ],

            const SizedBox(height: 14),

            // Tombol Aksi berdasarkan status
            SizedBox(
              width: double.infinity,
              child: _buildActionButton(item),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(SubtesItem item) {
    switch (item.status) {
      case SubtesStatus.belumMulai:
        return FilledButton.icon(
          onPressed: () => controller.mulaiSubtes(item),
          icon: const Icon(Icons.play_arrow, size: 18),
          label: const Text('Mulai'),
        );
      case SubtesStatus.berjalan:
        return FilledButton.tonalIcon(
          onPressed: () => controller.lanjutkanSubtes(item),
          icon: const Icon(Icons.arrow_forward, size: 18),
          label: const Text('Lanjutkan'),
        );
      case SubtesStatus.selesai:
        return Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => controller.lihatHasil(item),
                icon: const Icon(Icons.analytics_outlined, size: 18),
                label: const Text('Lihat Hasil'),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: FilledButton.tonalIcon(
                onPressed: () => controller.lihatPembahasan(item),
                icon: const Icon(Icons.menu_book, size: 18),
                label: const Text('Pembahasan'),
              ),
            ),
          ],
        );
    }
  }

  _StatusConfig _getStatusConfig(SubtesStatus status) {
    switch (status) {
      case SubtesStatus.belumMulai:
        return _StatusConfig(
          label: 'Belum mulai',
          textColor: Colors.blueGrey.shade800,
          backgroundColor: Colors.blueGrey.shade50,
          icon: Icons.radio_button_unchecked,
        );
      case SubtesStatus.berjalan:
        return _StatusConfig(
          label: 'Berjalan',
          textColor: Colors.orange.shade900,
          backgroundColor: Colors.orange.shade50,
          icon: Icons.timelapse,
        );
      case SubtesStatus.selesai:
        return _StatusConfig(
          label: 'Selesai',
          textColor: Colors.green.shade900,
          backgroundColor: Colors.green.shade50,
          icon: Icons.check_circle_outline,
        );
    }
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
