import 'package:flutter/material.dart';
import '../meta_colors.dart';
import '../meta_radius.dart';
import '../meta_spacing.dart';
import '../meta_typography.dart';

class MetaProductFeatureCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;

  const MetaProductFeatureCard({
    super.key,
    required this.child,
    this.padding,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? const EdgeInsets.all(MetaSpacing.xxl),
      decoration: BoxDecoration(
        color: MetaColors.canvas,
        borderRadius: BorderRadius.circular(MetaRadius.xxxl),
        border: Border.all(color: MetaColors.hairlineSoft),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(MetaRadius.xxxl),
          child: child,
        ),
      ),
    );
  }
}

class MetaPhotoCard extends StatelessWidget {
  final Widget child;

  const MetaPhotoCard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(MetaRadius.xxxl),
      child: child,
    );
  }
}

class MetaIconFeatureCard extends StatelessWidget {
  final Widget icon;
  final String title;
  final String subtitle;

  const MetaIconFeatureCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(MetaSpacing.xl),
      decoration: BoxDecoration(
        color: MetaColors.canvas,
        borderRadius: BorderRadius.circular(MetaRadius.xl),
        border: Border.all(color: MetaColors.hairlineSoft),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          icon,
          const SizedBox(height: MetaSpacing.md),
          Text(title, style: MetaTypography.subtitleLg),
          const SizedBox(height: MetaSpacing.xs),
          Text(subtitle, style: MetaTypography.bodySm),
        ],
      ),
    );
  }
}

class MetaListingCard extends StatelessWidget {
  final String? imageUrl;
  final String title;
  final String price;
  final String? subtitle;
  final VoidCallback? onTap;

  const MetaListingCard({
    super.key,
    this.imageUrl,
    required this.title,
    required this.price,
    this.subtitle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: MetaColors.canvas,
          borderRadius: BorderRadius.circular(MetaRadius.xxl),
          border: Border.all(color: MetaColors.hairlineSoft),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: imageUrl != null
                  ? Image.network(
                      imageUrl!,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => _imagePlaceholder(),
                    )
                  : _imagePlaceholder(),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(MetaSpacing.xs),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: MetaTypography.bodySmBold,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      price,
                      style: MetaTypography.bodyMdBold.copyWith(
                        color: MetaColors.inkDeep,
                      ),
                    ),
                    const Spacer(),
                    if (subtitle != null)
                      Text(
                        subtitle!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: MetaTypography.caption.copyWith(
                          color: MetaColors.steel,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _imagePlaceholder() {
    return Container(
      color: MetaColors.surfaceSoft,
      child: const Center(
        child: Icon(Icons.image, size: 40, color: MetaColors.steel),
      ),
    );
  }
}

class MetaCheckoutSummaryCard extends StatelessWidget {
  final Widget child;

  const MetaCheckoutSummaryCard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(MetaSpacing.xl),
      decoration: BoxDecoration(
        color: MetaColors.canvas,
        borderRadius: BorderRadius.circular(MetaRadius.xl),
        border: Border.all(color: MetaColors.hairlineSoft),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(20, 22, 26, 0.3),
            offset: Offset(0, 1),
            blurRadius: 4,
          ),
        ],
      ),
      child: child,
    );
  }
}
