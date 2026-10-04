import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/models/catalog_models.dart';
import '../../../data/models/content_models.dart';
import '../controllers/packs_controller.dart';

class PacksView extends GetView<PacksController> {
  const PacksView({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Paket Tes'),
          elevation: 0.5,
          bottom: const TabBar(
            tabs: [
              Tab(
                icon: Icon(Icons.folder_outlined, size: 20),
                text: 'Terpasang',
              ),
              Tab(
                icon: Icon(Icons.cloud_download_outlined, size: 20),
                text: 'Tersedia',
              ),
            ],
          ),
        ),
        body: Stack(
          children: [
            TabBarView(
              children: [
                // TAB 1: PAKET TERPASANG (LOKAL)
                _buildTerpasangTab(context),

                // TAB 2: PAKET TERSEDIA (KATALOG ONLINE)
                _buildTersediaTab(context),
              ],
            ),

            // OVERLAY LOADING: IMPOR ATAU UNDUHAN SEDANG BERLANGSUNG
            Obx(() {
              final isBusy = controller.isImporting.value || controller.downloadingPackId.value.isNotEmpty;
              if (!isBusy) return const SizedBox.shrink();

              final message = controller.isImporting.value
                  ? controller.importProgressMessage.value
                  : controller.downloadProgressMessage.value;

              return Container(
                color: Colors.black45,
                alignment: Alignment.center,
                child: Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const CircularProgressIndicator(),
                        const SizedBox(height: 16),
                        Text(
                          message.isNotEmpty ? message : 'Memproses...',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Harap tunggu, proses ini tidak memakan waktu lama...',
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ],
        ),
        floatingActionButton: Obx(() {
          final isBusy = controller.isImporting.value || controller.downloadingPackId.value.isNotEmpty;
          return FloatingActionButton.extended(
            onPressed: isBusy ? null : () => controller.pilihDanImporFile(context),
            icon: const Icon(Icons.file_upload_outlined),
            label: const Text('Impor dari File'),
            tooltip: 'Impor paket soal dari file .json',
          );
        }),
      ),
    );
  }

  // =========================================================================
  // TAB TERPASANG (LOKAL)
  // =========================================================================

  Widget _buildTerpasangTab(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if (controller.paketList.isEmpty) {
        return _buildEmptyState(
          context,
          icon: Icons.inventory_2_outlined,
          title: 'Belum Ada Paket Terpasang',
          message: 'Gunakan tab "Tersedia" untuk mengunduh paket dari katalog, atau tombol "Impor dari File" di bawah.',
        );
      }

      return ListView.separated(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 88),
        itemCount: controller.paketList.length,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final item = controller.paketList[index];
          return _buildInstalledPackCard(context, item);
        },
      );
    });
  }

  Widget _buildInstalledPackCard(BuildContext context, PaketItemSummary item) {
    final theme = Theme.of(context);
    final p = item.paket;

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
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        p.nama,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'ID: ${p.packId}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                          fontFamily: 'monospace',
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'v${p.packVersion}',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onPrimaryContainer,
                    ),
                  ),
                ),
              ],
            ),
            const Divider(height: 20),

            Row(
              children: [
                Icon(Icons.quiz_outlined, size: 16, color: Colors.blueGrey.shade700),
                const SizedBox(width: 4),
                Text(
                  '${item.jumlahTes} Tes',
                  style: TextStyle(fontSize: 13, color: Colors.grey.shade800),
                ),
                const SizedBox(width: 16),
                Icon(Icons.format_list_numbered_rounded, size: 16, color: Colors.blueGrey.shade700),
                const SizedBox(width: 4),
                Text(
                  '${item.jumlahSoal} Soal',
                  style: TextStyle(fontSize: 13, color: Colors.grey.shade800),
                ),
              ],
            ),
            const SizedBox(height: 8),

            Row(
              children: [
                Icon(Icons.calendar_today_outlined, size: 15, color: Colors.grey.shade600),
                const SizedBox(width: 5),
                Expanded(
                  child: Text(
                    'Dipasang: ${controller.formatTanggal(p.tanggalPasang)}',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.delete_outline, color: Colors.red.shade400, size: 20),
                  tooltip: 'Hapus Paket',
                  visualDensity: VisualDensity.compact,
                  onPressed: () => controller.konfirmasiHapusPaket(context, item),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // =========================================================================
  // TAB TERSEDIA (KATALOG ONLINE)
  // =========================================================================

  Widget _buildTersediaTab(BuildContext context) {
    return Obx(() {
      if (controller.isLoadingCatalog.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if (controller.catalogErrorMessage.value.isNotEmpty) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.cloud_off_rounded, size: 56, color: Colors.red.shade400),
                const SizedBox(height: 16),
                Text(
                  controller.catalogErrorMessage.value,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 16),
                FilledButton.icon(
                  onPressed: controller.muatKatalog,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Coba Lagi'),
                ),
              ],
            ),
          ),
        );
      }

      if (controller.catalogList.isEmpty) {
        return _buildEmptyState(
          context,
          icon: Icons.cloud_outlined,
          title: 'Katalog Kosong',
          message: 'Saat ini belum ada paket baru yang tersedia di katalog.',
        );
      }

      return RefreshIndicator(
        onRefresh: controller.muatKatalog,
        child: ListView.separated(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 88),
          itemCount: controller.catalogList.length,
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final catalogItem = controller.catalogList[index];
            return _buildCatalogPackCard(context, catalogItem);
          },
        ),
      );
    });
  }

  Widget _buildCatalogPackCard(BuildContext context, CatalogPackItem item) {
    final theme = Theme.of(context);

    return Obx(() {
      final status = controller.getCatalogItemStatus(item);
      final isDownloadingThis = controller.downloadingPackId.value == item.packId;
      final isAnyBusy = controller.downloadingPackId.value.isNotEmpty || controller.isImporting.value;

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
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.nama,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'ID: ${item.packId}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                            fontFamily: 'monospace',
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'v${item.packVersion}',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade900,
                      ),
                    ),
                  ),
                ],
              ),
              const Divider(height: 20),

              Row(
                children: [
                  Icon(Icons.data_usage_outlined, size: 16, color: Colors.blueGrey.shade700),
                  const SizedBox(width: 4),
                  Text(
                    '${item.ukuranKb} KB',
                    style: TextStyle(fontSize: 13, color: Colors.grey.shade800),
                  ),
                  const Spacer(),

                  // TOMBOL STATUS: Unduh / Perbarui / "Terbaru"
                  _buildCatalogActionButton(
                    context: context,
                    item: item,
                    status: status,
                    isDownloading: isDownloadingThis,
                    disabled: isAnyBusy,
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildCatalogActionButton({
    required BuildContext context,
    required CatalogPackItem item,
    required CatalogItemStatus status,
    required bool isDownloading,
    required bool disabled,
  }) {
    if (isDownloading) {
      return const SizedBox(
        width: 24,
        height: 24,
        child: CircularProgressIndicator(strokeWidth: 2.5),
      );
    }

    switch (status) {
      case CatalogItemStatus.unduh:
        return FilledButton.icon(
          onPressed: disabled ? null : () => controller.unduhDanImporPaket(context, item),
          icon: const Icon(Icons.download_rounded, size: 18),
          label: const Text('Unduh'),
          style: FilledButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            visualDensity: VisualDensity.compact,
          ),
        );

      case CatalogItemStatus.perbarui:
        return FilledButton.tonalIcon(
          onPressed: disabled ? null : () => controller.unduhDanImporPaket(context, item),
          icon: const Icon(Icons.system_update_alt_rounded, size: 18),
          label: const Text('Perbarui'),
          style: FilledButton.styleFrom(
            backgroundColor: Colors.orange.shade50,
            foregroundColor: Colors.orange.shade900,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            visualDensity: VisualDensity.compact,
          ),
        );

      case CatalogItemStatus.terbaru:
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.green.shade50,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.green.shade200),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.check_circle_rounded, size: 16, color: Colors.green.shade700),
              const SizedBox(width: 4),
              Text(
                'Terbaru',
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.bold,
                  color: Colors.green.shade800,
                ),
              ),
            ],
          ),
        );
    }
  }

  Widget _buildEmptyState(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String message,
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
          ],
        ),
      ),
    );
  }
}

