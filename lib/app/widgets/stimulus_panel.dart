import 'package:flutter/material.dart';

import '../data/models/content_models.dart';

/// Widget panel wacana/stimulus yang dapat diciutkan dan di-scroll secara mandiri.
/// Dirancang untuk digunakan ulang baik pada lembar pengerjaan ujian maupun pembahasan.
class StimulusPanel extends StatelessWidget {
  final StimulusData stimulus;
  final String soalRangeLabel;
  final bool isCollapsed;
  final VoidCallback onToggleCollapse;
  final ScrollController scrollController;
  final double? maxHeight;
  final bool isTwoColumn;

  const StimulusPanel({
    super.key,
    required this.stimulus,
    required this.soalRangeLabel,
    required this.isCollapsed,
    required this.onToggleCollapse,
    required this.scrollController,
    this.maxHeight,
    this.isTwoColumn = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasJudul = stimulus.judul != null && stimulus.judul!.trim().isNotEmpty;

    return Container(
      height: isTwoColumn
          ? double.infinity
          : (isCollapsed ? null : maxHeight),
      decoration: BoxDecoration(
        color: Colors.blueGrey.shade50.withValues(alpha: 0.5),
        border: Border.all(color: Colors.blueGrey.shade200),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: isTwoColumn ? MainAxisSize.max : (isCollapsed ? MainAxisSize.min : MainAxisSize.max),
        children: [
          // Header Baris: Label Wacana, Judul (opsional), dan Tombol Ciutkan/Perluas
          InkWell(
            onTap: isTwoColumn ? null : onToggleCollapse,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.blueGrey.shade100.withValues(alpha: 0.7),
                borderRadius: isCollapsed && !isTwoColumn
                    ? BorderRadius.circular(12)
                    : const BorderRadius.vertical(top: Radius.circular(12)),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.menu_book_rounded,
                    size: 18,
                    color: Colors.blueGrey.shade800,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          soalRangeLabel,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.blueGrey.shade900,
                          ),
                        ),
                        if (hasJudul) ...[
                          const SizedBox(height: 2),
                          Text(
                            stimulus.judul!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Colors.blueGrey.shade800,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  if (!isTwoColumn) ...[
                    IconButton(
                      icon: Icon(
                        isCollapsed ? Icons.expand_more_rounded : Icons.expand_less_rounded,
                        color: Colors.blueGrey.shade800,
                      ),
                      tooltip: isCollapsed ? 'Perluas Wacana' : 'Ciutkan Wacana',
                      onPressed: onToggleCollapse,
                      visualDensity: VisualDensity.compact,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ],
              ),
            ),
          ),

          // Konten Teks Wacana (Scroll Mandiri)
          if (!isCollapsed || isTwoColumn)
            Expanded(
              child: Scrollbar(
                controller: scrollController,
                thumbVisibility: true,
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(14),
                  physics: const ClampingScrollPhysics(),
                  child: SelectableText(
                    stimulus.isi,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontSize: 14.5,
                      height: 1.6,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
