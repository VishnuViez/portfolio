import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

/// Wraps the geolocator & geocoding packages for device-level location.
class LocationService {
  /// Check whether location services are enabled and permissions granted.
  Future<bool> checkPermissions() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return false;

    final permission = await Geolocator.checkPermission();
    return permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse;
  }

  /// Request location permissions from the user.
  Future<LocationPermission> requestPermissions() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return LocationPermission.denied;
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    return permission;
  }

  /// Get the current device position.
  Future<Position> getCurrentLocation() async {
    final permission = await requestPermissions();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      throw LocationServiceException(
        'Location permission denied. Please enable in Settings.',
      );
    }

    return Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  /// Reverse-geocode coordinates to get a human-readable address.
  Future<String> getAddressFromCoordinates(double lat, double lon) async {
    try {
      final placemarks = await placemarkFromCoordinates(lat, lon);
      if (placemarks.isNotEmpty) {
        final p = placemarks.first;
        return [p.locality, p.country].where((e) => e != null && e.isNotEmpty).join(', ');
      }
    } catch (_) {}
    return '';
  }
}

class LocationServiceException implements Exception {
  final String message;
  const LocationServiceException(this.message);
  @override
  String toString() => message;
}
