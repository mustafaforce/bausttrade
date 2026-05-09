import 'package:flutter/material.dart';
import '../meta_colors.dart';
import '../meta_radius.dart';
import '../meta_typography.dart';

class MetaBadge extends StatelessWidget {
  final String label;
  final MetaBadgeType type;

  const MetaBadge({
    super.key,
    required this.label,
    this.type = MetaBadgeType.promo,
  });

  @override
  Widget build(BuildContext context) {
    final (bg, fg) = switch (type) {
      MetaBadgeType.promo => (MetaColors.warning, MetaColors.inkDeep),
      MetaBadgeType.attention => (MetaColors.attention, MetaColors.canvas),
      MetaBadgeType.success => (MetaColors.success, MetaColors.canvas),
      MetaBadgeType.critical => (MetaColors.critical, MetaColors.canvas),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(MetaRadius.full),
      ),
      child: Text(
        label,
        style: MetaTypography.captionBold.copyWith(color: fg),
      ),
    );
  }
}

enum MetaBadgeType { promo, attention, success, critical }
