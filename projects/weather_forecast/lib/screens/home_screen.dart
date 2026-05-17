import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../providers/weather_provider.dart';
import '../utils/weather_utils.dart';
import '../widgets/gradient_background.dart';
import '../widgets/weather_icon.dart';
import '../widgets/weather_card.dart';
import '../widgets/hourly_forecast_card.dart';
import '../widgets/daily_forecast_item.dart';
import 'search_screen.dart';
import 'settings_screen.dart';
import 'forecast_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<WeatherProvider>().init();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WeatherProvider>(
      builder: (context, provider, _) {
        final weather = provider.currentWeather;
        final condition = weather?.current.description ?? 'clear';
        final isDay = weather?.current.isDayTime ?? true;

        return GradientBackground(
          weatherCondition: condition,
          isDay: isDay,
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: _buildAppBar(context, provider),
            body: _buildBody(context, provider),
          ),
        );
      },
    );
  }

  PreferredSizeWidget _buildAppBar(
      BuildContext context, WeatherProvider provider) {
    final city = provider.currentWeather?.location.city ?? 'Weather';
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.my_location),
        onPressed: () => provider.fetchWeatherForCurrentLocation(),
      ),
      title: Text(city),
      actions: [
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const SearchScreen()),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.settings),
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const SettingsScreen()),
          ),
        ),
      ],
    );
  }

  Widget _buildBody(BuildContext context, WeatherProvider provider) {
    if (provider.isLoading && provider.currentWeather == null) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.white),
      );
    }

    if (provider.errorMessage != null && provider.currentWeather == null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.cloud_off, size: 64, color: Colors.white54),
              const SizedBox(height: 16),
              Text(
                provider.errorMessage!,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white70, fontSize: 16),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () => provider.refreshWeather(),
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white.withValues(alpha: 0.2),
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
      );
    }

    final weather = provider.currentWeather!;
    final celsius = provider.isCelsius;

    return RefreshIndicator(
      onRefresh: () => provider.refreshWeather(),
      color: Colors.white,
      backgroundColor: Colors.white.withValues(alpha: 0.2),
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          const SizedBox(height: 16),
          // ── Current weather hero ──
          _CurrentWeatherSection(weather: weather, celsius: celsius)
              .animate()
              .fadeIn(duration: 500.ms)
              .slideY(begin: 0.1, end: 0),
          const SizedBox(height: 24),
          // ── Weather detail cards (2×2 grid) ──
          _DetailCardsGrid(weather: weather, celsius: celsius)
              .animate()
              .fadeIn(delay: 200.ms, duration: 500.ms)
              .slideY(begin: 0.1, end: 0),
          const SizedBox(height: 24),
          // ── Hourly forecast ──
          if (weather.hourly.isNotEmpty)
            HourlyForecastCard(hours: weather.hourly, celsius: celsius)
                .animate()
                .fadeIn(delay: 300.ms, duration: 500.ms)
                .slideY(begin: 0.1, end: 0),
          const SizedBox(height: 24),
          // ── Daily forecast ──
          if (weather.daily.isNotEmpty) ...[
            _DailyForecastSection(
              daily: weather.daily,
              celsius: celsius,
            ).animate().fadeIn(delay: 400.ms, duration: 500.ms).slideY(
                  begin: 0.1,
                  end: 0,
                ),
          ],
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

// ── Current weather hero section ──────────────────────────────

class _CurrentWeatherSection extends StatelessWidget {
  final dynamic weather;
  final bool celsius;

  const _CurrentWeatherSection({
    required this.weather,
    required this.celsius,
  });

  @override
  Widget build(BuildContext context) {
    final current = weather.current;
    return Column(
      children: [
        WeatherIcon(iconCode: current.iconCode, size: 64),
        const SizedBox(height: 8),
        Text(
          formatTemperature(current.temperature, celsius: celsius),
          style: const TextStyle(
            fontSize: 72,
            fontWeight: FontWeight.w200,
            color: Colors.white,
          ),
        ),
        Text(
          current.description[0].toUpperCase() +
              current.description.substring(1),
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w400,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Feels like ${formatTemperature(current.feelsLike, celsius: celsius)}',
          style: TextStyle(
            fontSize: 14,
            color: Colors.white.withValues(alpha: 0.7),
          ),
        ),
      ],
    );
  }
}

// ── Detail cards grid ─────────────────────────────────────────

class _DetailCardsGrid extends StatelessWidget {
  final dynamic weather;
  final bool celsius;

  const _DetailCardsGrid({required this.weather, required this.celsius});

  @override
  Widget build(BuildContext context) {
    final current = weather.current;
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.4,
      children: [
        WeatherCard(
          icon: Icons.water_drop_outlined,
          label: 'Humidity',
          value: '${current.humidity}%',
        ),
        WeatherCard(
          icon: Icons.air,
          label: 'Wind',
          value: '${current.windSpeed.toStringAsFixed(1)} m/s',
          subtitle: getWindDirection(current.windDeg),
        ),
        WeatherCard(
          icon: Icons.compress,
          label: 'Pressure',
          value: '${current.pressure} hPa',
        ),
        WeatherCard(
          icon: Icons.visibility_outlined,
          label: 'Visibility',
          value: formatVisibility(current.visibility),
        ),
      ],
    );
  }
}

// ── Daily forecast section ────────────────────────────────────

class _DailyForecastSection extends StatelessWidget {
  final List daily;
  final bool celsius;

  const _DailyForecastSection({
    required this.daily,
    required this.celsius,
  });

  @override
  Widget build(BuildContext context) {
    final weekMin = daily
        .map((d) => d.tempMin as double)
        .reduce((a, b) => a < b ? a : b);
    final weekMax = daily
        .map((d) => d.tempMax as double)
        .reduce((a, b) => a > b ? a : b);

    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
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
                padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Text(
                  '7-DAY FORECAST',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Colors.white70,
                    letterSpacing: 1,
                  ),
                ),
              ),
              ...daily.map((day) {
                return DailyForecastItem(
                  day: day,
                  weekMinTemp: weekMin,
                  weekMaxTemp: weekMax,
                  celsius: celsius,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ForecastDetailScreen(
                        daily: List.from(daily),
                        celsius: celsius,
                      ),
                    ),
                  ),
                );
              }),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}
