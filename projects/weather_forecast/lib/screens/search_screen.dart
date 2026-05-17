import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/weather.dart';
import '../models/saved_location.dart';
import '../providers/weather_provider.dart';
import '../widgets/gradient_background.dart';
import '../widgets/search_bar.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _controller = TextEditingController();
  List<Location> _results = [];
  List<String> _recentSearches = [];
  Timer? _debounce;
  bool _searching = false;

  @override
  void initState() {
    super.initState();
    _loadRecent();
  }

  Future<void> _loadRecent() async {
    final provider = context.read<WeatherProvider>();
    // Load from storage via provider (recent searches held in storage service)
    // For simplicity, we keep some local state
    setState(() {});
  }

  void _onQueryChanged(String query) {
    _debounce?.cancel();
    if (query.trim().isEmpty) {
      setState(() {
        _results = [];
        _searching = false;
      });
      return;
    }
    setState(() => _searching = true);
    _debounce = Timer(const Duration(milliseconds: 500), () async {
      final provider = context.read<WeatherProvider>();
      final results = await provider.searchCities(query);
      if (mounted) {
        setState(() {
          _results = results;
          _searching = false;
        });
      }
    });
  }

  void _selectCity(Location location) {
    final provider = context.read<WeatherProvider>();
    provider.fetchWeatherByCoordinates(location.latitude, location.longitude);
    Navigator.pop(context);
  }

  void _searchCity(String city) {
    if (city.trim().isEmpty) return;
    final provider = context.read<WeatherProvider>();
    provider.fetchWeatherByCity(city.trim());
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<WeatherProvider>();
    final condition =
        provider.currentWeather?.current.description ?? 'clear';
    final isDay = provider.currentWeather?.current.isDayTime ?? true;

    return GradientBackground(
      weatherCondition: condition,
      isDay: isDay,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text('Search City'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              WeatherSearchBar(
                controller: _controller,
                autofocus: true,
                onChanged: _onQueryChanged,
                onSubmitted: _searchCity,
              ),
              const SizedBox(height: 16),
              // ── Saved locations ──
              if (_controller.text.isEmpty &&
                  provider.savedLocations.isNotEmpty) ...[
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'SAVED LOCATIONS',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Colors.white70,
                      letterSpacing: 1,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                ...provider.savedLocations.map(
                  (loc) => ListTile(
                    leading: const Icon(Icons.bookmark, color: Colors.white70),
                    title: Text(
                      loc.city,
                      style: const TextStyle(color: Colors.white),
                    ),
                    subtitle: Text(
                      loc.country,
                      style: const TextStyle(color: Colors.white54),
                    ),
                    onTap: () {
                      provider.fetchWeatherByCoordinates(
                          loc.latitude, loc.longitude);
                      Navigator.pop(context);
                    },
                  ),
                ),
                const SizedBox(height: 16),
              ],
              // ── Search results ──
              if (_searching)
                const Padding(
                  padding: EdgeInsets.all(32),
                  child: CircularProgressIndicator(color: Colors.white),
                )
              else
                Expanded(
                  child: ListView.builder(
                    itemCount: _results.length,
                    itemBuilder: (context, index) {
                      final loc = _results[index];
                      return ListTile(
                        leading: const Icon(
                          Icons.location_on_outlined,
                          color: Colors.white70,
                        ),
                        title: Text(
                          loc.city,
                          style: const TextStyle(color: Colors.white),
                        ),
                        subtitle: Text(
                          loc.country,
                          style: const TextStyle(color: Colors.white54),
                        ),
                        trailing: IconButton(
                          icon: Icon(
                            provider.isLocationSaved(loc.city)
                                ? Icons.bookmark
                                : Icons.bookmark_border,
                            color: Colors.white70,
                          ),
                          onPressed: () {
                            final saved = provider.isLocationSaved(loc.city);
                            if (saved) {
                              provider.removeSavedLocation(
                                provider.savedLocations.firstWhere(
                                    (s) => s.city == loc.city),
                              );
                            } else {
                              provider.addSavedLocation(
                                SavedLocation(
                                  city: loc.city,
                                  country: loc.country,
                                  latitude: loc.latitude,
                                  longitude: loc.longitude,
                                ),
                              );
                            }
                          },
                        ),
                        onTap: () => _selectCity(loc),
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
