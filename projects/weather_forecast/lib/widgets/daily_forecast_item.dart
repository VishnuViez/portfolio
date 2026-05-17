import 'package:flutter/material.dart';
import '../models/weather.dart';
import '../utils/weather_utils.dart';
import 'weather_icon.dart';

/// A single row in the 7-day daily forecast list.
class DailyForecastItem extends StatelessWidget {
  final DailyForecast day;
  final double weekMinTemp;
  final double weekMaxTemp;
  final bool celsius;
  final VoidCallback? onTap;

  const DailyForecastItem({
    super.key,
    required this.day,
    required this.weekMinTemp,
    required this.weekMaxTemp,
    required this.celsius,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final range = weekMaxTemp - weekMinTemp;
    final barStart = range == 0 ? 0.0 : (day.tempMin - weekMinTemp) / range;
    final barEnd = range == 0 ? 1.0 : (day.tempMax - weekMinTemp) / range;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          children: [
            // Day name
            SizedBox(
              width: 44,
              child: Text(
                formatDay(day.date),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ),
            // Weather icon
            WeatherIcon(iconCode: day.iconCode, size: 24),
            const SizedBox(width: 8),
            // Precipitation probability
            SizedBox(
              width: 36,
              child: day.precipProbability > 0
                  ? Text(
                      '${day.precipProbability}%',
                      style: const TextStyle(
                        fontSize: 11,
                        color: Color(0xFF4FC3F7),
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
            // Min temp
            SizedBox(
              width: 36,
              child: Text(
                formatTemperature(day.tempMin, celsius: celsius),
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.white.withValues(alpha: 0.6),
                ),
              ),
            ),
            const SizedBox(width: 8),
            // Temperature range bar
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: SizedBox(
                  height: 6,
                  child: CustomPaint(
                    painter: _TempBarPainter(
                      start: barStart,
                      end: barEnd,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            // Max temp
            SizedBox(
              width: 36,
              child: Text(
                formatTemperature(day.tempMax, celsius: celsius),
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TempBarPainter extends CustomPainter {
  final double start;
  final double end;

  _TempBarPainter({required this.start, required this.end});

  @override
  void paint(Canvas canvas, Size size) {
    // Background track
    final bgPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.15)
      ..style = PaintingStyle.fill;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.width, size.height),
        const Radius.circular(4),
      ),
      bgPaint,
    );

    // Gradient bar segment
    final left = start * size.width;
    final right = end * size.width;
    final gradient = LinearGradient(
      colors: const [Color(0xFF4FC3F7), Color(0xFFFFA726)],
    );
    final barPaint = Paint()
      ..shader = gradient.createShader(
        Rect.fromLTWH(left, 0, right - left, size.height),
      );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(left, 0, right - left, size.height),
        const Radius.circular(4),
      ),
      barPaint,
    );
  }

  @override
  bool shouldRepaint(_TempBarPainter old) =>
      old.start != start || old.end != end;
}
