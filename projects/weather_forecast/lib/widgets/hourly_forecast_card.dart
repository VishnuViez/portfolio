import 'dart:ui';
import 'package:flutter/material.dart';
import '../models/weather.dart';
import '../utils/weather_utils.dart';
import 'weather_icon.dart';

/// Horizontal scrollable list of hourly forecast items.
class HourlyForecastCard extends StatelessWidget {
  final List<HourlyForecast> hours;
  final bool celsius;

  const HourlyForecastCard({
    super.key,
    required this.hours,
    required this.celsius,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.2),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'HOURLY FORECAST',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Colors.white70,
                    letterSpacing: 1,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 120,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  itemCount: hours.length,
                  itemBuilder: (context, index) {
                    final hour = hours[index];
                    final isNow = index == 0;
                    return _HourItem(
                      hour: hour,
                      isNow: isNow,
                      celsius: celsius,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HourItem extends StatelessWidget {
  final HourlyForecast hour;
  final bool isNow;
  final bool celsius;

  const _HourItem({
    required this.hour,
    required this.isNow,
    required this.celsius,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 64,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      decoration: BoxDecoration(
        color: isNow
            ? Colors.white.withValues(alpha: 0.2)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            isNow ? 'Now' : formatTime(hour.time),
            style: TextStyle(
              fontSize: 12,
              fontWeight: isNow ? FontWeight.w600 : FontWeight.w400,
              color: Colors.white,
            ),
          ),
          WeatherIcon(iconCode: hour.iconCode, size: 28),
          Text(
            formatTemperature(hour.temperature, celsius: celsius),
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          if (hour.precipProbability > 0)
            Text(
              '${hour.precipProbability}%',
              style: const TextStyle(
                fontSize: 10,
                color: Color(0xFF4FC3F7),
              ),
            ),
        ],
      ),
    );
  }
}
