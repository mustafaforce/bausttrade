import 'package:flutter/material.dart';
import '../design/meta_colors.dart';
import '../design/meta_radius.dart';
import '../design/meta_spacing.dart';
import '../design/meta_typography.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      fontFamily: 'Montserrat',
      scaffoldBackgroundColor: MetaColors.canvas,
      colorScheme: const ColorScheme.light(
        primary: MetaColors.primary,
        onPrimary: MetaColors.onPrimary,
        secondary: MetaColors.primary,
        surface: MetaColors.canvas,
        error: MetaColors.critical,
      ),
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        elevation: 0,
        backgroundColor: MetaColors.canvas,
        foregroundColor: MetaColors.inkDeep,
        surfaceTintColor: MetaColors.canvas,
      ),
      inputDecorationTheme: InputDecorationTheme(
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
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: MetaColors.inkButton,
          foregroundColor: MetaColors.onInkButton,
          disabledBackgroundColor: MetaColors.disabledText,
          disabledForegroundColor: MetaColors.canvas,
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 30),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(MetaRadius.full),
          ),
          textStyle: MetaTypography.buttonMd,
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: MetaColors.primary,
          foregroundColor: MetaColors.onPrimary,
          disabledBackgroundColor: MetaColors.disabledText,
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 30),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(MetaRadius.full),
          ),
          textStyle: MetaTypography.buttonMd,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: MetaColors.inkDeep,
          side: const BorderSide(color: MetaColors.inkDeep, width: 2),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 28),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(MetaRadius.full),
          ),
          textStyle: MetaTypography.buttonMd,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: MetaColors.ink,
          textStyle: MetaTypography.linkMd,
        ),
      ),
      cardTheme: CardThemeData(
        color: MetaColors.canvas,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(MetaRadius.xl),
          side: const BorderSide(color: MetaColors.hairlineSoft),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: MetaColors.hairlineSoft,
        thickness: 1,
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(MetaRadius.lg),
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: MetaColors.canvas,
        elevation: 0,
      ),
      drawerTheme: const DrawerThemeData(
        backgroundColor: MetaColors.canvas,
      ),
      dialogTheme: DialogThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(MetaRadius.xl),
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: MetaColors.inkButton,
        foregroundColor: MetaColors.onInkButton,
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: MetaColors.primary,
      ),
    );
  }
}
