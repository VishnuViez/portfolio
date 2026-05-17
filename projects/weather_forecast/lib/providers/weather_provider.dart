import 'package:flutter/foundation.dart';
import '../models/weather.dart';
import '../models/saved_location.dart';
import '../services/weather_api_service.dart';
import '../services/location_service.dart';
import '../services/storage_service.dart';

enum TemperatureUnit { celsius, fahrenheit }

class WeatherProvider extends ChangeNotifier {
  final WeatherApiService _api;
  final LocationService _location;
  final StorageService _storage;

  WeatherData? _currentWeather;
  List<SavedLocation> _savedLocations = [];
  bool _isLoading = false;
  String? _errorMessage;
  TemperatureUnit _unit = TemperatureUnit.celsius;

  WeatherProvider({
    WeatherApiService? api,
    LocationService? location,
    StorageService? storage,
  })  : _api = api ?? WeatherApiService(),
        _location = location ?? LocationService(),
        _storage = storage ?? StorageService();

  // ── Getters ─────────────────────────────────────────────────

  WeatherData? get currentWeather => _currentWeather;
  List<SavedLocation> get savedLocations => _savedLocations;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  TemperatureUnit get unit => _unit;
  bool get isCelsius => _unit == TemperatureUnit.celsius;

  // ── Initialisation ──────────────────────────────────────────

  Future<void> init() async {
    final celsius = await _storage.getUseCelsius();
    _unit = celsius ? TemperatureUnit.celsius : TemperatureUnit.fahrenheit;
    _savedLocations = await _storage.getSavedLocations();
    notifyListeners();

    // Try loading the last city, otherwise use device location
    final lastCity = await _storage.getLastCity();
    if (lastCity != null && lastCity.isNotEmpty) {
      await fetchWeatherByCity(lastCity);
    } else {
      await fetchWeatherForCurrentLocation();
    }
  }

  // ── Fetch weather ───────────────────────────────────────────

  Future<void> fetchWeatherForCurrentLocation() async {
    _setLoading(true);
    try {
      final position = await _location.getCurrentLocation();
      _currentWeather = await _api.getWeatherByCoordinates(
        position.latitude,
        position.longitude,
      );
      _errorMessage = null;
      if (_currentWeather != null) {
        await _storage.saveLastCity(_currentWeather!.location.city);
      }
    } on LocationServiceException catch (e) {
      _errorMessage = e.message;
    } on WeatherApiException catch (e) {
      _errorMessage = e.message;
    } catch (e) {
      _errorMessage = 'Something went wrong. Please try again.';
    }
    _setLoading(false);
  }

  Future<void> fetchWeatherByCity(String city) async {
    _setLoading(true);
    try {
      _currentWeather = await _api.getWeatherByCity(city);
      _errorMessage = null;
      await _storage.saveLastCity(city);
      await _storage.addRecentSearch(city);
    } on WeatherApiException catch (e) {
      _errorMessage = e.message;
    } catch (e) {
      _errorMessage = 'Something went wrong. Please try again.';
    }
    _setLoading(false);
  }

  Future<void> fetchWeatherByCoordinates(double lat, double lon) async {
    _setLoading(true);
    try {
      _currentWeather = await _api.getWeatherByCoordinates(lat, lon);
      _errorMessage = null;
      if (_currentWeather != null) {
        await _storage.saveLastCity(_currentWeather!.location.city);
      }
    } on WeatherApiException catch (e) {
      _errorMessage = e.message;
    } catch (e) {
      _errorMessage = 'Something went wrong. Please try again.';
    }
    _setLoading(false);
  }

  Future<void> refreshWeather() async {
    if (_currentWeather != null) {
      await fetchWeatherByCoordinates(
        _currentWeather!.location.latitude,
        _currentWeather!.location.longitude,
      );
    } else {
      await fetchWeatherForCurrentLocation();
    }
  }

  // ── Search ──────────────────────────────────────────────────

  Future<List<Location>> searchCities(String query) async {
    try {
      return await _api.searchCities(query);
    } catch (_) {
      return [];
    }
  }

  // ── Temperature unit ────────────────────────────────────────

  Future<void> toggleTemperatureUnit() async {
    _unit = _unit == TemperatureUnit.celsius
        ? TemperatureUnit.fahrenheit
        : TemperatureUnit.celsius;
    await _storage.saveUseCelsius(isCelsius);
    notifyListeners();
  }

  // ── Saved locations ─────────────────────────────────────────

  Future<void> addSavedLocation(SavedLocation location) async {
    if (!_savedLocations.contains(location)) {
      _savedLocations.add(location);
      await _storage.saveSavedLocations(_savedLocations);
      notifyListeners();
    }
  }

  Future<void> removeSavedLocation(SavedLocation location) async {
    _savedLocations.remove(location);
    await _storage.saveSavedLocations(_savedLocations);
    notifyListeners();
  }

  bool isLocationSaved(String city) =>
      _savedLocations.any((l) => l.city == city);

  // ── Internal ────────────────────────────────────────────────

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
