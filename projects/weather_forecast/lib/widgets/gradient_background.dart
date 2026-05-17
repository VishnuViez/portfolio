import 'package:flutter/material.dart';
import '../utils/weather_utils.dart';

/// Animated gradient background that changes based on weather and time of day.
class GradientBackground extends StatelessWidget {
  final String weatherCondition;
  final bool isDay;
  final Widget child;

  const GradientBackground({
    super.key,
    required this.weatherCondition,
    required this.isDay,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final colors = getWeatherGradient(weatherCondition, isDay);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: colors,
        ),
      ),
      child: child,
    );
  }
}
