import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  // ── Colours ─────────────────────────────────────────────────
  static const Color _lightPrimary = Color(0xFF4FC3F7);
  static const Color _darkPrimary = Color(0xFF1A237E);

  // ── Light Theme ─────────────────────────────────────────────
  static ThemeData get light => ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorScheme: ColorScheme.fromSeed(
          seedColor: _lightPrimary,
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: Colors.transparent,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          foregroundColor: Colors.white,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
          iconTheme: IconThemeData(color: Colors.white),
        ),
        cardTheme: CardThemeData(
          color: Colors.white.withValues(alpha: 0.2),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        textTheme: _buildTextTheme(Brightness.light),
        iconTheme: const IconThemeData(color: Colors.white),
      );

  // ── Dark Theme ──────────────────────────────────────────────
  static ThemeData get dark => ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: _darkPrimary,
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: Colors.transparent,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          foregroundColor: Colors.white,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
          iconTheme: IconThemeData(color: Colors.white),
        ),
        cardTheme: CardThemeData(
          color: Colors.white.withValues(alpha: 0.1),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        textTheme: _buildTextTheme(Brightness.dark),
        iconTheme: const IconThemeData(color: Colors.white70),
      );

  static TextTheme _buildTextTheme(Brightness brightness) {
    final color =
        brightness == Brightness.light ? Colors.white : Colors.white;
    return TextTheme(
      displayLarge: TextStyle(
        fontSize: 72,
        fontWeight: FontWeight.w200,
        color: color,
      ),
      displayMedium: TextStyle(
        fontSize: 48,
        fontWeight: FontWeight.w300,
        color: color,
      ),
      headlineMedium: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: color,
      ),
      titleLarge: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w500,
        color: color,
      ),
      bodyLarge: TextStyle(fontSize: 16, color: color),
      bodyMedium: TextStyle(
        fontSize: 14,
        color: color.withValues(alpha: 0.85),
      ),
      labelLarge: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: color.withValues(alpha: 0.7),
      ),
    );
  }

  // ── Weather-condition gradient presets ──────────────────────
  static List<Color> sunnyGradient = const [
    Color(0xFFFFA726),
    Color(0xFFFFCC02),
    Color(0xFF4FC3F7),
  ];

  static List<Color> rainyGradient = const [
    Color(0xFF37474F),
    Color(0xFF546E7A),
    Color(0xFF78909C),
  ];

  static List<Color> nightGradient = const [
    Color(0xFF1A237E),
    Color(0xFF4A148C),
    Color(0xFF0D0D2B),
  ];

  static List<Color> cloudyGradient = const [
    Color(0xFF78909C),
    Color(0xFF90A4AE),
    Color(0xFFB0BEC5),
  ];
}
