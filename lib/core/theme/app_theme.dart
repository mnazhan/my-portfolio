import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// AppTheme
///
/// Design tokens extracted directly from Stitch screens:
///   • "My webpage"  (desktop) — project 15698149139411655749
///   • "Nazhan"      (mobile)  — project 13565701411040274404
///
/// Shared design language:
///   Font        : Space Grotesk (Google Fonts)
///   Color mode  : Dark
///   Primary     : #25D1F4  (cyan-blue accent — desktop screen)
///   Secondary   : #0DF2F2  (teal-cyan accent — mobile screens)
///   Background  : #090E13  (deep navy-black)
///   Surface     : #111820  (card / glass surface)
///   On-surface  : #E2EAF0  (primary text on dark)
///   Subtle text : #6B8398  (muted / caption text)
///   Border      : #1C2B38  (dividers / stroke)
///   Roundness   : 12 px default (ROUND_TWELVE), 100 px pill (ROUND_FULL)
class AppTheme {
  AppTheme._();

  // ─── Color Palette ────────────────────────────────────────────────────────

  /// Cyan-blue primary — desktop "My webpage" screen accent
  static const Color primary = Color(0xFF25D1F4);

  /// Teal-cyan secondary — mobile "Nazhan" screen accent
  static const Color secondary = Color(0xFF0DF2F2);

  /// Deep navy-black canvas (page background)
  static const Color background = Color(0xFF090E13);

  /// Elevated card / glass-panel surface
  static const Color surface = Color(0xFF111820);

  /// Slightly lighter surface layer (nested cards)
  static const Color surfaceVariant = Color(0xFF182330);

  /// Primary text on dark backgrounds
  static const Color onBackground = Color(0xFFE2EAF0);

  /// Text on primary/accent buttons
  static const Color onPrimary = Color(0xFF090E13);

  /// Muted / caption / placeholder text
  static const Color textSubtle = Color(0xFF6B8398);

  /// Dividers, borders, and strokes
  static const Color border = Color(0xFF1C2B38);

  /// Destructive / error state
  static const Color error = Color(0xFFFF5C6E);

  // ─── Radius Tokens ────────────────────────────────────────────────────────

  /// Default card / container radius (matches ROUND_TWELVE)
  static const double radiusDefault = 12.0;

  /// Large radius for modals, bottom sheets
  static const double radiusLarge = 20.0;

  /// Full pill radius (matches ROUND_FULL)
  static const double radiusPill = 100.0;

  static const BorderRadius borderRadiusDefault =
      BorderRadius.all(Radius.circular(radiusDefault));
  static const BorderRadius borderRadiusPill =
      BorderRadius.all(Radius.circular(radiusPill));

  // ─── Typography ───────────────────────────────────────────────────────────

  /// Space Grotesk — base text theme applied via [GoogleFonts.spaceGroteskTextTheme]
  static TextTheme get _baseTextTheme =>
      GoogleFonts.spaceGroteskTextTheme(_darkTextTheme);

  static const TextTheme _darkTextTheme = TextTheme(
    // Display — Hero / landing statement
    displayLarge: TextStyle(
      fontSize: 57,
      fontWeight: FontWeight.w700,
      letterSpacing: -1.5,
      color: onBackground,
      height: 1.1,
    ),
    displayMedium: TextStyle(
      fontSize: 45,
      fontWeight: FontWeight.w700,
      letterSpacing: -1.0,
      color: onBackground,
      height: 1.15,
    ),
    displaySmall: TextStyle(
      fontSize: 36,
      fontWeight: FontWeight.w600,
      letterSpacing: -0.5,
      color: onBackground,
      height: 1.2,
    ),

    // Headline — Section titles  (e.g. "Project Hub", "Tech Stack")
    headlineLarge: TextStyle(
      fontSize: 32,
      fontWeight: FontWeight.w700,
      letterSpacing: -0.5,
      color: onBackground,
    ),
    headlineMedium: TextStyle(
      fontSize: 26,
      fontWeight: FontWeight.w600,
      letterSpacing: -0.25,
      color: onBackground,
    ),
    headlineSmall: TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.w600,
      color: onBackground,
    ),

    // Title — Card titles, nav labels
    titleLarge: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      letterSpacing: 0,
      color: onBackground,
    ),
    titleMedium: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.1,
      color: onBackground,
    ),
    titleSmall: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.1,
      color: onBackground,
    ),

    // Body — Paragraph / description text
    bodyLarge: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.15,
      color: onBackground,
      height: 1.6,
    ),
    bodyMedium: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.25,
      color: onBackground,
      height: 1.6,
    ),
    bodySmall: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.4,
      color: textSubtle,
      height: 1.5,
    ),

    // Label — Badges, tags, overlines
    labelLarge: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.5,
      color: onBackground,
    ),
    labelMedium: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.5,
      color: textSubtle,
    ),
    labelSmall: TextStyle(
      fontSize: 10,
      fontWeight: FontWeight.w500,
      letterSpacing: 1.0,
      color: textSubtle,
    ),
  );

  // ─── ThemeData ─────────────────────────────────────────────────────────────

  static ThemeData get darkTheme {
    final colorScheme = ColorScheme.dark(
      primary: primary,
      onPrimary: onPrimary,
      secondary: secondary,
      onSecondary: onPrimary,
      error: error,
      surface: surface,
      onSurface: onBackground,
      surfaceContainerHighest: surfaceVariant,
      outline: border,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: background,
      textTheme: _baseTextTheme,

      // ── AppBar ──────────────────────────────────────────────────────────
      appBarTheme: AppBarTheme(
        backgroundColor: background,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: _baseTextTheme.titleLarge,
        iconTheme: const IconThemeData(color: onBackground),
      ),

      // ── Card ────────────────────────────────────────────────────────────
      cardTheme: CardThemeData(
        color: surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: borderRadiusDefault,
          side: const BorderSide(color: border, width: 1),
        ),
        margin: EdgeInsets.zero,
      ),

      // ── Elevated Button ─────────────────────────────────────────────────
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: onPrimary,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: const StadiumBorder(),
          textStyle: _baseTextTheme.labelLarge,
        ),
      ),

      // ── Outlined Button ─────────────────────────────────────────────────
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primary,
          side: const BorderSide(color: primary, width: 1.5),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: const StadiumBorder(),
          textStyle: _baseTextTheme.labelLarge,
        ),
      ),

      // ── Text Button ─────────────────────────────────────────────────────
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primary,
          textStyle: _baseTextTheme.labelLarge,
        ),
      ),

      // ── Input / TextField ────────────────────────────────────────────────
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceVariant,
        hintStyle: _baseTextTheme.bodyMedium?.copyWith(color: textSubtle),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: borderRadiusDefault,
          borderSide: const BorderSide(color: border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: borderRadiusDefault,
          borderSide: const BorderSide(color: border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: borderRadiusDefault,
          borderSide: const BorderSide(color: primary, width: 1.5),
        ),
      ),

      // ── Divider ──────────────────────────────────────────────────────────
      dividerTheme: const DividerThemeData(
        color: border,
        thickness: 1,
        space: 1,
      ),

      // ── BottomNavigationBar ──────────────────────────────────────────────
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: surface,
        selectedItemColor: primary,
        unselectedItemColor: textSubtle,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        selectedLabelStyle: _baseTextTheme.labelSmall,
        unselectedLabelStyle: _baseTextTheme.labelSmall,
      ),

      // ── Chip ─────────────────────────────────────────────────────────────
      chipTheme: ChipThemeData(
        backgroundColor: surfaceVariant,
        labelStyle: _baseTextTheme.labelMedium,
        side: const BorderSide(color: border),
        shape: const StadiumBorder(),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      ),

      // ── FloatingActionButton ─────────────────────────────────────────────
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: primary,
        foregroundColor: onPrimary,
        elevation: 4,
        shape: CircleBorder(),
      ),
    );
  }
}
