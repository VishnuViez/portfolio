import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/saved_location.dart';
import '../utils/constants.dart';

/// Persists user preferences and saved locations via SharedPreferences.
class StorageService {
  SharedPreferences? _prefs;

  Future<SharedPreferences> get _preferences async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs!;
  }

  // ── Temperature Unit ───────────────────────────────────────

  Future<bool> getUseCelsius() async {
    final prefs = await _preferences;
    return prefs.getString(AppConstants.prefUnit) != 'fahrenheit';
  }

  Future<void> saveUseCelsius(bool celsius) async {
    final prefs = await _preferences;
    await prefs.setString(
      AppConstants.prefUnit,
      celsius ? 'celsius' : 'fahrenheit',
    );
  }

  // ── Theme ──────────────────────────────────────────────────

  Future<String> getThemeMode() async {
    final prefs = await _preferences;
    return prefs.getString(AppConstants.prefTheme) ?? 'system';
  }

  Future<void> saveThemeMode(String mode) async {
    final prefs = await _preferences;
    await prefs.setString(AppConstants.prefTheme, mode);
  }

  // ── Saved (favourite) locations ────────────────────────────

  Future<List<SavedLocation>> getSavedLocations() async {
    final prefs = await _preferences;
    final raw = prefs.getStringList(AppConstants.prefSavedLocations) ?? [];
    return raw.map((e) => SavedLocation.decode(e)).toList();
  }

  Future<void> saveSavedLocations(List<SavedLocation> locations) async {
    final prefs = await _preferences;
    final raw = locations.map((e) => e.encode()).toList();
    await prefs.setStringList(AppConstants.prefSavedLocations, raw);
  }

  // ── Last searched city ─────────────────────────────────────

  Future<String?> getLastCity() async {
    final prefs = await _preferences;
    return prefs.getString(AppConstants.prefLastCity);
  }

  Future<void> saveLastCity(String city) async {
    final prefs = await _preferences;
    await prefs.setString(AppConstants.prefLastCity, city);
  }

  // ── Recent searches ────────────────────────────────────────

  Future<List<String>> getRecentSearches() async {
    final prefs = await _preferences;
    return prefs.getStringList(AppConstants.prefRecentSearches) ?? [];
  }

  Future<void> addRecentSearch(String city) async {
    final prefs = await _preferences;
    final list = prefs.getStringList(AppConstants.prefRecentSearches) ?? [];
    list.remove(city);
    list.insert(0, city);
    if (list.length > 10) list.removeLast();
    await prefs.setStringList(AppConstants.prefRecentSearches, list);
  }
}
