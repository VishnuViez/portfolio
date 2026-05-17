import 'package:flutter/material.dart';

/// Maps OpenWeatherMap icon codes to Material icons with appropriate colours.
class WeatherIcon extends StatelessWidget {
  final String iconCode;
  final double size;

  const WeatherIcon({super.key, required this.iconCode, this.size = 48});

  @override
  Widget build(BuildContext context) {
    return Icon(_iconFor(iconCode), size: size, color: _colorFor(iconCode));
  }

  static IconData _iconFor(String code) {
    switch (code) {
      case '01d':
        return Icons.wb_sunny_rounded;
      case '01n':
        return Icons.nightlight_round;
      case '02d':
        return Icons.wb_cloudy;
      case '02n':
        return Icons.nights_stay_rounded;
      case '03d':
      case '03n':
        return Icons.cloud;
      case '04d':
      case '04n':
        return Icons.cloud_queue;
      case '09d':
      case '09n':
        return Icons.water_drop;
      case '10d':
      case '10n':
        return Icons.water_drop_outlined;
      case '11d':
      case '11n':
        return Icons.thunderstorm;
      case '13d':
      case '13n':
        return Icons.ac_unit;
      case '50d':
      case '50n':
        return Icons.foggy;
      default:
        return Icons.wb_sunny_rounded;
    }
  }

  static Color _colorFor(String code) {
    if (code.startsWith('01')) return const Color(0xFFFFA726);
    if (code.startsWith('02')) return const Color(0xFFFFCC80);
    if (code.startsWith('03') || code.startsWith('04')) {
      return const Color(0xFFB0BEC5);
    }
    if (code.startsWith('09') || code.startsWith('10')) {
      return const Color(0xFF4FC3F7);
    }
    if (code.startsWith('11')) return const Color(0xFFFFD54F);
    if (code.startsWith('13')) return const Color(0xFFE0E0E0);
    if (code.startsWith('50')) return const Color(0xFF90A4AE);
    return Colors.white;
  }
}
