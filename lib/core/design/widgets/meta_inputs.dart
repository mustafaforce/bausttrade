import 'package:flutter/material.dart';
import '../meta_colors.dart';
import '../meta_radius.dart';
import '../meta_spacing.dart';
import '../meta_typography.dart';

class MetaTextInput extends StatelessWidget {
  final TextEditingController controller;
  final String? labelText;
  final String? hintText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool obscureText;
  final TextInputType? keyboardType;
  final TextCapitalization textCapitalization;
  final String? Function(String?)? validator;
  final int? maxLines;

  const MetaTextInput({
    super.key,
    required this.controller,
    this.labelText,
    this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.keyboardType,
    this.textCapitalization = TextCapitalization.none,
    this.validator,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      textCapitalization: textCapitalization,
      maxLines: maxLines,
      style: MetaTypography.bodyMd.copyWith(color: MetaColors.ink),
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: MetaColors.canvas,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: MetaSpacing.md,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(MetaRadius.lg),
          borderSide: const BorderSide(color: MetaColors.hairline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(MetaRadius.lg),
          borderSide: const BorderSide(color: MetaColors.hairline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(MetaRadius.lg),
          borderSide: const BorderSide(color: MetaColors.fbBlue, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(MetaRadius.lg),
          borderSide: const BorderSide(color: MetaColors.criticalStrong),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(MetaRadius.lg),
          borderSide: const BorderSide(color: MetaColors.criticalStrong, width: 2),
        ),
        labelStyle: MetaTypography.bodyMd.copyWith(color: MetaColors.charcoal),
        hintStyle: MetaTypography.bodyMd.copyWith(color: MetaColors.steel),
      ),
      validator: validator,
    );
  }
}

class MetaSearchPill extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback? onTap;
  final ValueChanged<String>? onSubmitted;

  const MetaSearchPill({
    super.key,
    required this.controller,
    this.onTap,
    this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: MetaColors.surfaceSoft,
        borderRadius: BorderRadius.circular(MetaRadius.full),
      ),
      child: TextField(
        controller: controller,
        onTap: onTap,
        onSubmitted: onSubmitted,
        style: MetaTypography.bodySm.copyWith(color: MetaColors.steel),
        decoration: InputDecoration(
          hintText: 'Search',
          hintStyle: MetaTypography.bodySm.copyWith(color: MetaColors.steel),
          prefixIcon: const Icon(Icons.search, size: 18, color: MetaColors.steel),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: MetaSpacing.md,
            vertical: 10,
          ),
        ),
      ),
    );
  }
}

class MetaDropdownField extends StatelessWidget {
  final String? value;
  final String labelText;
  final List<DropdownMenuItem<String>> items;
  final ValueChanged<String?>? onChanged;
  final Widget? prefixIcon;
  final String? Function(String?)? validator;

  const MetaDropdownField({
    super.key,
    this.value,
    required this.labelText,
    required this.items,
    this.onChanged,
    this.prefixIcon,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: prefixIcon,
        filled: true,
        fillColor: MetaColors.canvas,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: MetaSpacing.md,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(MetaRadius.lg),
          borderSide: const BorderSide(color: MetaColors.hairline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(MetaRadius.lg),
          borderSide: const BorderSide(color: MetaColors.hairline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(MetaRadius.lg),
          borderSide: const BorderSide(color: MetaColors.fbBlue, width: 2),
        ),
        labelStyle: MetaTypography.bodyMd.copyWith(color: MetaColors.charcoal),
      ),
      items: items,
      onChanged: onChanged,
      validator: validator,
      style: MetaTypography.bodyMd.copyWith(color: MetaColors.ink),
    );
  }
}
