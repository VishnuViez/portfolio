import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/weather.dart';
import '../utils/constants.dart';

/// Service that communicates with the OpenWeatherMap REST API.
///
/// Uses the free-tier endpoints:
///   - /weather          (current)
///   - /forecast          (5-day / 3-hour)
///   - /geo/1.0/direct    (city search)
///
/// For OneCall 3.0 (paid), set [useOneCall] to true.
class WeatherApiService {
  final http.Client _client;
  final bool useOneCall;

  WeatherApiService({http.Client? client, this.useOneCall = false})
      : _client = client ?? http.Client();

  // ── Public API ──────────────────────────────────────────────

  /// Fetch weather by geographic coordinates.
  Future<WeatherData> getWeatherByCoordinates(double lat, double lon) async {
    if (useOneCall) {
      return _fetchOneCall(lat, lon);
    }
    return _fetchLegacy(lat, lon);
  }

  /// Fetch weather by city name.
  Future<WeatherData> getWeatherByCity(String cityName) async {
    // First geocode the city to get coordinates
    final geoUrl = Uri.parse(
      '${AppConstants.geoUrl}/direct?q=$cityName&limit=1&appid=${AppConstants.apiKey}',
    );
    final geoResp = await _client.get(geoUrl);
    _checkResponse(geoResp);

    final geoList = jsonDecode(geoResp.body) as List<dynamic>;
    if (geoList.isEmpty) {
      throw WeatherApiException('City "$cityName" not found');
    }

    final geo = geoList.first as Map<String, dynamic>;
    final lat = (geo['lat'] as num).toDouble();
    final lon = (geo['lon'] as num).toDouble();

    return getWeatherByCoordinates(lat, lon);
  }

  /// Search cities by query string. Returns a list of matching locations.
  Future<List<Location>> searchCities(String query) async {
    if (query.trim().isEmpty) return [];

    final url = Uri.parse(
      '${AppConstants.geoUrl}/direct?q=$query&limit=5&appid=${AppConstants.apiKey}',
    );
    final response = await _client.get(url);
    _checkResponse(response);

    final list = jsonDecode(response.body) as List<dynamic>;
    return list
        .map((e) => Location.fromGeoJson(e as Map<String, dynamic>))
        .toList();
  }

  // ── Private helpers ─────────────────────────────────────────

  /// OneCall 3.0 — requires subscription.
  Future<WeatherData> _fetchOneCall(double lat, double lon) async {
    final url = Uri.parse(
      '${AppConstants.oneCallUrl}?lat=$lat&lon=$lon'
      '&exclude=minutely,alerts&units=metric&appid=${AppConstants.apiKey}',
    );
    final response = await _client.get(url);
    _checkResponse(response);

    final json = jsonDecode(response.body) as Map<String, dynamic>;

    // Reverse-geocode for city name
    final cityName = await _reverseGeocode(lat, lon);

    return WeatherData.fromOneCallJson(
      json,
      cityName: cityName,
      countryName: '',
    );
  }

  /// Legacy endpoints — free tier.
  Future<WeatherData> _fetchLegacy(double lat, double lon) async {
    final currentUrl = Uri.parse(
      '${AppConstants.baseUrl}/weather?lat=$lat&lon=$lon'
      '&units=metric&appid=${AppConstants.apiKey}',
    );
    final forecastUrl = Uri.parse(
      '${AppConstants.baseUrl}/forecast?lat=$lat&lon=$lon'
      '&units=metric&appid=${AppConstants.apiKey}',
    );

    final results = await Future.wait([
      _client.get(currentUrl),
      _client.get(forecastUrl),
    ]);

    _checkResponse(results[0]);
    _checkResponse(results[1]);

    final currentJson = jsonDecode(results[0].body) as Map<String, dynamic>;
    final forecastJson = jsonDecode(results[1].body) as Map<String, dynamic>;

    return WeatherData.fromLegacyJson(currentJson, forecastJson);
  }

  Future<String> _reverseGeocode(double lat, double lon) async {
    try {
      final url = Uri.parse(
        '${AppConstants.geoUrl}/reverse?lat=$lat&lon=$lon&limit=1&appid=${AppConstants.apiKey}',
      );
      final resp = await _client.get(url);
      if (resp.statusCode == 200) {
        final list = jsonDecode(resp.body) as List<dynamic>;
        if (list.isNotEmpty) {
          return (list.first as Map<String, dynamic>)['name'] as String? ?? '';
        }
      }
    } catch (_) {}
    return '';
  }

  void _checkResponse(http.Response response) {
    if (response.statusCode != 200) {
      final body = jsonDecode(response.body) as Map<String, dynamic>?;
      final message = body?['message'] as String? ?? 'Unknown error';
      throw WeatherApiException('API error ${response.statusCode}: $message');
    }
  }

  void dispose() => _client.close();
}

class WeatherApiException implements Exception {
  final String message;
  const WeatherApiException(this.message);
  @override
  String toString() => message;
}
