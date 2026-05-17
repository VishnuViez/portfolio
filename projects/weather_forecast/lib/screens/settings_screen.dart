import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/weather_provider.dart';
import '../providers/theme_provider.dart';
import '../models/saved_location.dart';
import '../widgets/gradient_background.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final weatherProvider = context.watch<WeatherProvider>();
    final themeProvider = context.watch<ThemeProvider>();
    final condition =
        weatherProvider.currentWeather?.current.description ?? 'clear';
    final isDay = weatherProvider.currentWeather?.current.isDayTime ?? true;

    return GradientBackground(
      weatherCondition: condition,
      isDay: isDay,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(title: const Text('Settings')),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // ── Temperature Unit ──
            _SectionHeader(title: 'UNITS'),
            _SettingsTile(
              icon: Icons.thermostat,
              title: 'Temperature Unit',
              trailing: SegmentedButton<bool>(
                segments: const [
                  ButtonSegment(value: true, label: Text('°C')),
                  ButtonSegment(value: false, label: Text('°F')),
                ],
                selected: {weatherProvider.isCelsius},
                onSelectionChanged: (_) =>
                    weatherProvider.toggleTemperatureUnit(),
                style: ButtonStyle(
                  foregroundColor: WidgetStateProperty.all(Colors.white),
                  backgroundColor:
                      WidgetStateProperty.resolveWith((states) {
                    if (states.contains(WidgetState.selected)) {
                      return Colors.white.withValues(alpha: 0.3);
                    }
                    return Colors.white.withValues(alpha: 0.1);
                  }),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // ── Theme ──
            _SectionHeader(title: 'APPEARANCE'),
            _SettingsTile(
              icon: Icons.palette_outlined,
              title: 'Theme',
              trailing: DropdownButton<ThemeMode>(
                value: themeProvider.themeMode,
                dropdownColor: const Color(0xFF1A237E),
                style: const TextStyle(color: Colors.white),
                underline: const SizedBox.shrink(),
                items: const [
                  DropdownMenuItem(
                    value: ThemeMode.system,
                    child: Text('Auto'),
                  ),
                  DropdownMenuItem(
                    value: ThemeMode.light,
                    child: Text('Light'),
                  ),
                  DropdownMenuItem(
                    value: ThemeMode.dark,
                    child: Text('Dark'),
                  ),
                ],
                onChanged: (mode) {
                  if (mode != null) themeProvider.setThemeMode(mode);
                },
              ),
            ),

            const SizedBox(height: 24),

            // ── Saved Locations ──
            _SectionHeader(title: 'SAVED LOCATIONS'),
            if (weatherProvider.savedLocations.isEmpty)
              const Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  'No saved locations yet.\nSearch for a city and tap the bookmark icon.',
                  style: TextStyle(color: Colors.white54),
                  textAlign: TextAlign.center,
                ),
              )
            else
              ...weatherProvider.savedLocations.map(
                (loc) => _SettingsTile(
                  icon: Icons.location_on_outlined,
                  title: loc.city,
                  subtitle: loc.country,
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline,
                        color: Colors.white70),
                    onPressed: () => weatherProvider.removeSavedLocation(loc),
                  ),
                ),
              ),

            const SizedBox(height: 24),

            // ── About ──
            _SectionHeader(title: 'ABOUT'),
            _SettingsTile(
              icon: Icons.info_outline,
              title: 'Weather Forecast App',
              subtitle: 'v1.0.0 • Powered by OpenWeatherMap',
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: Colors.white54,
          letterSpacing: 1.5,
        ),
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? trailing;

  const _SettingsTile({
    required this.icon,
    required this.title,
    this.subtitle,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        leading: Icon(icon, color: Colors.white70),
        title: Text(
          title,
          style: const TextStyle(color: Colors.white, fontSize: 15),
        ),
        subtitle: subtitle != null
            ? Text(
                subtitle!,
                style: const TextStyle(color: Colors.white54, fontSize: 12),
              )
            : null,
        trailing: trailing,
      ),
    );
  }
}
