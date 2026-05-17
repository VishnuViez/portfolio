import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/weather.dart';
import '../utils/weather_utils.dart';
import '../widgets/gradient_background.dart';
import '../widgets/weather_icon.dart';

class ForecastDetailScreen extends StatelessWidget {
  final List<DailyForecast> daily;
  final bool celsius;

  const ForecastDetailScreen({
    super.key,
    required this.daily,
    required this.celsius,
  });

  @override
  Widget build(BuildContext context) {
    return GradientBackground(
      weatherCondition: daily.isNotEmpty ? daily.first.description : 'clear',
      isDay: true,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(title: const Text('7-Day Forecast')),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // ── Temperature chart ──
            _TemperatureChart(daily: daily, celsius: celsius),
            const SizedBox(height: 24),
            // ── Detailed daily cards ──
            ...daily.map((d) => _DetailDayCard(day: d, celsius: celsius)),
          ],
        ),
      ),
    );
  }
}

// ── Temperature line chart ────────────────────────────────────

class _TemperatureChart extends StatelessWidget {
  final List<DailyForecast> daily;
  final bool celsius;

  const _TemperatureChart({required this.daily, required this.celsius});

  double _convert(double temp) =>
      celsius ? temp : (temp * 9 / 5) + 32;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          height: 220,
          padding: const EdgeInsets.all(16),
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
              const Text(
                'TEMPERATURE TREND',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: Colors.white70,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: LineChart(
                  LineChartData(
                    gridData: const FlGridData(show: false),
                    titlesData: FlTitlesData(
                      leftTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, _) {
                            final idx = value.toInt();
                            if (idx < 0 || idx >= daily.length) {
                              return const SizedBox.shrink();
                            }
                            return Text(
                              formatDay(daily[idx].date),
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 10,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    borderData: FlBorderData(show: false),
                    lineBarsData: [
                      // Max temperature line
                      LineChartBarData(
                        spots: daily.asMap().entries.map((e) {
                          return FlSpot(
                            e.key.toDouble(),
                            _convert(e.value.tempMax),
                          );
                        }).toList(),
                        isCurved: true,
                        color: const Color(0xFFFFA726),
                        barWidth: 2,
                        dotData: const FlDotData(show: true),
                        belowBarData: BarAreaData(
                          show: true,
                          color: const Color(0xFFFFA726)
                              .withValues(alpha: 0.15),
                        ),
                      ),
                      // Min temperature line
                      LineChartBarData(
                        spots: daily.asMap().entries.map((e) {
                          return FlSpot(
                            e.key.toDouble(),
                            _convert(e.value.tempMin),
                          );
                        }).toList(),
                        isCurved: true,
                        color: const Color(0xFF4FC3F7),
                        barWidth: 2,
                        dotData: const FlDotData(show: true),
                        belowBarData: BarAreaData(
                          show: true,
                          color: const Color(0xFF4FC3F7)
                              .withValues(alpha: 0.15),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Detailed day card ─────────────────────────────────────────

class _DetailDayCard extends StatelessWidget {
  final DailyForecast day;
  final bool celsius;

  const _DetailDayCard({required this.day, required this.celsius});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: const EdgeInsets.all(16),
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
                // Header row
                Row(
                  children: [
                    Text(
                      formatFullDate(day.date),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    const Spacer(),
                    WeatherIcon(iconCode: day.iconCode, size: 32),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  day.description.isNotEmpty
                      ? day.description[0].toUpperCase() +
                          day.description.substring(1)
                      : '',
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 12),
                // Detail rows
                Row(
                  children: [
                    _miniInfo(Icons.thermostat, 'High',
                        formatTemperature(day.tempMax, celsius: celsius)),
                    _miniInfo(Icons.thermostat_outlined, 'Low',
                        formatTemperature(day.tempMin, celsius: celsius)),
                    _miniInfo(Icons.water_drop_outlined, 'Humidity',
                        '${day.humidity}%'),
                    _miniInfo(Icons.air, 'Wind',
                        '${day.windSpeed.toStringAsFixed(1)} m/s'),
                  ],
                ),
                if (day.precipProbability > 0) ...[
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.umbrella, size: 14, color: Color(0xFF4FC3F7)),
                      const SizedBox(width: 4),
                      Text(
                        '${day.precipProbability}% chance of precipitation',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF4FC3F7),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _miniInfo(IconData icon, String label, String value) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, size: 16, color: Colors.white60),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          Text(
            label,
            style: const TextStyle(fontSize: 10, color: Colors.white54),
          ),
        ],
      ),
    );
  }
}
