// ============================================================
// Weather Forecast App — Constants
// ============================================================

class AppConstants {
  AppConstants._();

  // ── OpenWeatherMap API ──────────────────────────────────────
  // Replace with your own free API key from https://openweathermap.org/api
  static const String apiKey = 'YOUR_API_KEY_HERE';
  static const String baseUrl = 'https://api.openweathermap.org/data/2.5';
  static const String oneCallUrl = 'https://api.openweathermap.org/data/3.0/onecall';
  static const String geoUrl = 'https://api.openweathermap.org/geo/1.0';
  static const String iconUrl = 'https://openweathermap.org/img/wn';

  // ── Defaults ────────────────────────────────────────────────
  static const String defaultCity = 'London';
  static const double defaultLat = 51.5074;
  static const double defaultLon = -0.1278;

  // ── SharedPreferences keys ─────────────────────────────────
  static const String prefUnit = 'temperature_unit';
  static const String prefTheme = 'theme_mode';
  static const String prefSavedLocations = 'saved_locations';
  static const String prefLastCity = 'last_city';
  static const String prefRecentSearches = 'recent_searches';
}
