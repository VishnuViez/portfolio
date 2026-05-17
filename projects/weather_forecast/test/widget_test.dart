import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:weather_forecast/main.dart';
import 'package:weather_forecast/providers/weather_provider.dart';
import 'package:weather_forecast/providers/theme_provider.dart';

void main() {
  testWidgets('WeatherApp smoke test — renders without crashing',
      (WidgetTester tester) async {
    await tester.pumpWidget(const WeatherApp());
    // The splash screen should render
    expect(find.text('Weather'), findsOneWidget);
    expect(find.text('Forecast'), findsOneWidget);
  });
}
