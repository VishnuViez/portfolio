import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// ============================================================
// Weather Utility Functions
// ============================================================

/// Returns a gradient pair based on the weather condition and time of day.
List<Color> getWeatherGradient(String condition, bool isDay) {
  final c = condition.toLowerCase();
  if (!isDay) {
    return const [Color(0xFF1A237E), Color(0xFF4A148C), Color(0xFF0D0D2B)];
  }
  if (c.contains('clear') || c.contains('sunny')) {
    return const [Color(0xFFFFA726), Color(0xFFFFCC02), Color(0xFF4FC3F7)];
  }
  if (c.contains('cloud')) {
    return const [Color(0xFF78909C), Color(0xFF90A4AE), Color(0xFFB0BEC5)];
  }
  if (c.contains('rain') || c.contains('drizzle')) {
    return const [Color(0xFF37474F), Color(0xFF546E7A), Color(0xFF78909C)];
  }
  if (c.contains('thunder') || c.contains('storm')) {
    return const [Color(0xFF1A1A2E), Color(0xFF16213E), Color(0xFF0F3460)];
  }
  if (c.contains('snow')) {
    return const [Color(0xFFCFD8DC), Color(0xFFECEFF1), Color(0xFFFFFFFF)];
  }
  if (c.contains('mist') || c.contains('fog') || c.contains('haze')) {
    return const [Color(0xFF9E9E9E), Color(0xFFBDBDBD), Color(0xFFE0E0E0)];
  }
  // Default — pleasant sky
  return const [Color(0xFF4FC3F7), Color(0xFF81D4FA), Color(0xFFB3E5FC)];
}

/// Format temperature with unit symbol.
String formatTemperature(double temp, {bool celsius = true}) {
  final value = celsius ? temp : (temp * 9 / 5) + 32;
  return '${value.round()}°${celsius ? 'C' : 'F'}';
}

/// Convert wind bearing in degrees to a compass direction string.
String getWindDirection(double degrees) {
  const directions = [
    'N', 'NNE', 'NE', 'ENE', 'E', 'ESE', 'SE', 'SSE',
    'S', 'SSW', 'SW', 'WSW', 'W', 'WNW', 'NW', 'NNW',
  ];
  final index = ((degrees % 360) / 22.5).round() % 16;
  return directions[index];
}

/// Format a DateTime to a short time string e.g. "3 PM".
String formatTime(DateTime dt) => DateFormat.j().format(dt);

/// Format a DateTime to a day name e.g. "Mon".
String formatDay(DateTime dt) => DateFormat.E().format(dt);

/// Format a DateTime to full date e.g. "Mon, Mar 20".
String formatFullDate(DateTime dt) => DateFormat('E, MMM d').format(dt);

/// UV Index level description.
String getUvLevel(double index) {
  if (index <= 2) return 'Low';
  if (index <= 5) return 'Moderate';
  if (index <= 7) return 'High';
  if (index <= 10) return 'Very High';
  return 'Extreme';
}

/// Air Quality Index level description.
String getAqiLevel(int aqi) {
  switch (aqi) {
    case 1:
      return 'Good';
    case 2:
      return 'Fair';
    case 3:
      return 'Moderate';
    case 4:
      return 'Poor';
    case 5:
      return 'Very Poor';
    default:
      return 'Unknown';
  }
}

/// Visibility in human-readable form.
String formatVisibility(int meters) {
  if (meters >= 1000) {
    return '${(meters / 1000).toStringAsFixed(1)} km';
  }
  return '$meters m';
}
