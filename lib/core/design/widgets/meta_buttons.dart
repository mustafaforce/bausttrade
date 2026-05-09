import 'package:flutter/material.dart';
import '../meta_colors.dart';
import '../meta_radius.dart';
import '../meta_typography.dart';

class MetaPrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final Widget? icon;

  const MetaPrimaryButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: TextButton(
        onPressed: isLoading ? null : onPressed,
        style: TextButton.styleFrom(
          backgroundColor: MetaColors.inkButton,
          foregroundColor: MetaColors.onInkButton,
          disabledBackgroundColor: MetaColors.disabledText,
          disabledForegroundColor: MetaColors.canvas,
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 30),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(MetaRadius.full),
          ),
        ),
        child: isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: MetaColors.canvas,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (icon != null) ...[icon!, const SizedBox(width: 8)],
                  Text(label, style: MetaTypography.buttonMd),
                ],
              ),
      ),
    );
  }
}

class MetaBuyCtaButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final Widget? icon;

  const MetaBuyCtaButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: TextButton(
        onPressed: isLoading ? null : onPressed,
        style: TextButton.styleFrom(
          backgroundColor: MetaColors.primary,
          foregroundColor: MetaColors.onPrimary,
          disabledBackgroundColor: MetaColors.disabledText,
          disabledForegroundColor: MetaColors.canvas,
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 30),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(MetaRadius.full),
          ),
        ),
        child: isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: MetaColors.canvas,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (icon != null) ...[icon!, const SizedBox(width: 8)],
                  Text(label, style: MetaTypography.buttonMd),
                ],
              ),
      ),
    );
  }
}

class MetaSecondaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;

  const MetaSecondaryButton({
    super.key,
    required this.label,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: MetaColors.inkDeep,
          side: const BorderSide(color: MetaColors.inkDeep, width: 2),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 28),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(MetaRadius.full),
          ),
        ),
        child: Text(label, style: MetaTypography.buttonMd),
      ),
    );
  }
}

class MetaGhostButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;

  const MetaGhostButton({
    super.key,
    required this.label,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: MetaColors.inkDeep,
          side: BorderSide(
            color: MetaColors.inkDeep.withValues(alpha: 0.12),
            width: 2,
          ),
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 22),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(MetaRadius.full),
          ),
        ),
        child: Text(label, style: MetaTypography.buttonMd),
      ),
    );
  }
}

class MetaPillTab extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback? onTap;

  const MetaPillTab({
    super.key,
    required this.label,
    this.isActive = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? MetaColors.inkDeep : MetaColors.canvas,
          borderRadius: BorderRadius.circular(MetaRadius.full),
          border: isActive
              ? null
              : Border.all(color: MetaColors.hairline),
        ),
        child: Text(
          label,
          style: MetaTypography.bodySmBold.copyWith(
            color: isActive ? MetaColors.canvas : MetaColors.ink,
          ),
        ),
      ),
    );
  }
}

class MetaIconCircularButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final Color? iconColor;

  const MetaIconCircularButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.backgroundColor,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: const BoxDecoration(
        color: MetaColors.canvas,
        shape: BoxShape.circle,
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(icon),
        color: iconColor ?? MetaColors.ink,
        iconSize: 20,
        padding: EdgeInsets.zero,
      ),
    );
  }
}
