import 'package:flutter/material.dart';

class AppTheme {
  static const _primary = Color(0xFF8FBFA0);
  static const _secondary = Color(0xFFC8B6E2);
  static const _background = Color(0xFFF7F7F5);
  static const _surface = Color(0xFFFFFFFF);
  static const _textPrimary = Color(0xFF2E2E2E);
  static const _textSecondary = Color(0xFF5E6662);
  static const softPillBackground = Color(0xFFF2F5F3);
  static const iconMuted = Color(0xFFA8AEAA);
  static const softPressedSplash = Color(0x338FBFA0);
  static const softPressedHighlight = Color(0x148FBFA0);
  static const textHint = Color(0xFFAAB0B3);
  static const textStrongSecondary = Color(0xFF404744);
  static const accentPrimary = Color(0xFF466557);
  static const panelSubtle = Color(0xFFF0F3F0);
  static const borderSubtle = Color(0xFFE6E9E7);
  static const fieldLabel = Color(0xFF4E5552);
  static const dividerSubtle = Color(0xFFEAEDEA);
  static const switchThumbActive = Color(0xFF9DBEAD);

  static Color adaptiveSoftPillBackground(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? const Color(0xFF353C39) : softPillBackground;
  }

  static Color adaptiveTileBackground(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? const Color(0xFF2F3532) : Colors.white;
  }

  /// Parlak gradient kartının içindeki küçük satırlar — düz beyaz yerine hafif şeffaf zemin.
  static Color adaptiveAmbientInnerTileBackground(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    if (isDark) {
      return const Color(0x8E2F3532);
    }
    return Colors.white.withValues(alpha: 0.48);
  }

  static Color adaptiveAmbientInnerTileBorder(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    if (isDark) {
      return const Color(0x5C444D48);
    }
    return const Color(0xFF2E2E2E).withValues(alpha: 0.08);
  }

  static Color adaptiveSubtleBorder(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? const Color(0xFF444D48) : const Color(0xFFE8ECE8);
  }

  static Color adaptiveReminderPanel(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? const Color(0xFF323936) : panelSubtle;
  }

  static Color adaptiveBottomBarBackground(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark
        ? const Color(0xE62A302D)
        : Colors.white.withValues(alpha: 0.92);
  }

  static Color adaptiveSuggestionBackground(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? const Color(0xFF2F3532) : Colors.white;
  }

  static Color adaptiveCardSurface(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? const Color(0xFF2A302D) : Colors.white;
  }

  static Color adaptiveStrongText(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? const Color(0xFFD9E2DD) : textStrongSecondary;
  }

  static ThemeData get lightTheme {
    final scheme = ColorScheme.fromSeed(
      seedColor: _primary,
      brightness: Brightness.light,
      surface: _surface,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme.copyWith(
        primary: _primary,
        secondary: _secondary,
        surface: _surface,
      ),
      scaffoldBackgroundColor: _background,
      appBarTheme: const AppBarTheme(
        backgroundColor: _background,
        elevation: 0,
        centerTitle: false,
      ),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w700,
          color: _textPrimary,
        ),
        headlineMedium: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: _textPrimary,
        ),
        titleMedium: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: _textPrimary,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          color: _textPrimary,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          color: _textSecondary,
        ),
        labelSmall: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: _textSecondary,
        ),
      ),
      cardTheme: const CardThemeData(
        color: _surface,
        elevation: 1,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: _primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          minimumSize: const Size.fromHeight(48),
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: _primary,
        foregroundColor: Colors.white,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFFF0F0EC),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    // Soft-dark palette: close to light theme character.
    const darkBackground = Color(0xFF202523);
    const darkSurface = Color(0xFF2A302D);
    const darkInput = Color(0xFF323835);
    const darkTextPrimary = Color(0xFFE5ECE8);
    const darkTextSecondary = Color(0xFFC0C9C4);

    final scheme = ColorScheme.fromSeed(
      seedColor: _primary,
      brightness: Brightness.dark,
      surface: darkSurface,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: scheme.copyWith(
        primary: _primary,
        secondary: _secondary,
        surface: darkSurface,
      ),
      scaffoldBackgroundColor: darkBackground,
      appBarTheme: const AppBarTheme(
        backgroundColor: darkBackground,
        elevation: 0,
        centerTitle: false,
      ),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w700,
          color: darkTextPrimary,
        ),
        headlineMedium: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: darkTextPrimary,
        ),
        titleMedium: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: darkTextPrimary,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          color: darkTextPrimary,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          color: darkTextSecondary,
        ),
        labelSmall: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: darkTextSecondary,
        ),
      ),
      cardTheme: const CardThemeData(
        color: darkSurface,
        elevation: 1,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: _primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          minimumSize: const Size.fromHeight(48),
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: _primary,
        foregroundColor: Colors.white,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: darkInput,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
