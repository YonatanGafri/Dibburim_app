import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// ─── Color Palette ───
/// Warm, serene cream/gold/taupe palette for spiritual calm.
class AppColors {
  AppColors._();

  static bool isBlueTheme = false;

  static Color get background => isBlueTheme ? const Color(0xFFF0F8FD) : const Color(0xFFFDF8F0);
  static Color get surface => const Color(0xFFFFFFFF);
  static Color get surfaceDim => isBlueTheme ? const Color(0xFFE0F0F5) : const Color(0xFFF5EDE0);
  static Color get primary => isBlueTheme ? const Color(0xFF4A90E2) : const Color(0xFFC9A96E);
  static Color get primaryDark => isBlueTheme ? const Color(0xFF357ABD) : const Color(0xFFA8864A);
  static Color get secondary => isBlueTheme ? const Color(0xFF90B8D8) : const Color(0xFFB8A590);
  static Color get textPrimary => isBlueTheme ? const Color(0xFF26323A) : const Color(0xFF3A3226);
  static Color get textSecondary => isBlueTheme ? const Color(0xFF68707A) : const Color(0xFF7A7068);
  static Color get textOnPrimary => const Color(0xFFFFFFFF);
  static Color get success => isBlueTheme ? const Color(0xFF80B5A0) : const Color(0xFF8DB580);
  static Color get divider => isBlueTheme ? const Color(0xFFD2DFE8) : const Color(0xFFE8DFD2);
  static Color get shimmer => isBlueTheme ? const Color(0xFFB0D5E8) : const Color(0xFFE8D5B0);
  static Color get overlay => isBlueTheme ? const Color(0x99F0F8FD) : const Color(0x99FDF8F0);
}

/// ─── Theme ───
ThemeData buildAppTheme() {
  final baseTextTheme = GoogleFonts.heeboTextTheme();

  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.background,
    colorScheme: ColorScheme.light(
      primary: AppColors.primary,
      onPrimary: AppColors.textOnPrimary,
      secondary: AppColors.secondary,
      surface: AppColors.surface,
      onSurface: AppColors.textPrimary,
      outline: AppColors.divider,
    ),
    textTheme: baseTextTheme.copyWith(
      displayLarge: baseTextTheme.displayLarge?.copyWith(
        fontSize: 48,
        fontWeight: FontWeight.w300,
        color: AppColors.textPrimary,
        letterSpacing: 0,
      ),
      headlineMedium: baseTextTheme.headlineMedium?.copyWith(
        fontSize: 28,
        fontWeight: FontWeight.w500,
        color: AppColors.textPrimary,
        letterSpacing: 0,
      ),
      titleLarge: baseTextTheme.titleLarge?.copyWith(
        fontSize: 22,
        fontWeight: FontWeight.w500,
        color: AppColors.textPrimary,
        letterSpacing: 0,
      ),
      titleMedium: baseTextTheme.titleMedium?.copyWith(
        fontSize: 18,
        fontWeight: FontWeight.w500,
        color: AppColors.textPrimary,
        letterSpacing: 0,
      ),
      bodyLarge: baseTextTheme.bodyLarge?.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: AppColors.textPrimary,
        letterSpacing: 0,
        height: 1.6,
      ),
      bodyMedium: baseTextTheme.bodyMedium?.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: AppColors.textSecondary,
        letterSpacing: 0,
        height: 1.5,
      ),
      labelLarge: baseTextTheme.labelLarge?.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: AppColors.textOnPrimary,
        letterSpacing: 0,
      ),
      bodySmall: baseTextTheme.bodySmall?.copyWith(
        fontSize: 13,
        fontWeight: FontWeight.w400,
        color: AppColors.textSecondary,
        letterSpacing: 0,
      ),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: AppColors.surface,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: AppColors.secondary,
      type: BottomNavigationBarType.fixed,
      elevation: 8,
      selectedLabelStyle: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        letterSpacing: 0,
      ),
      unselectedLabelStyle: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        letterSpacing: 0,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textOnPrimary,
        elevation: 2,
        shadowColor: AppColors.primary.withAlpha(80),
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(28),
        ),
        textStyle: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w500,
          letterSpacing: 0,
        ),
      ),
    ),
    cardTheme: CardThemeData(
      color: AppColors.surface,
      elevation: 2,
      shadowColor: AppColors.secondary.withAlpha(40),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    ),
    dividerTheme: DividerThemeData(
      color: AppColors.divider,
      thickness: 1,
      space: 1,
    ),
    iconTheme: IconThemeData(
      color: AppColors.primary,
      size: 24,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.background,
      elevation: 0,
      scrolledUnderElevation: 0,
      iconTheme: IconThemeData(color: AppColors.primary),
      titleTextStyle: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w500,
        color: AppColors.textPrimary,
        letterSpacing: 0,
      ),
    ),
  );
}
