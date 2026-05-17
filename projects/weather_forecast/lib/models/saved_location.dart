import 'dart:convert';

/// A user-saved / favourite location.
class SavedLocation {
  final String city;
  final String country;
  final double latitude;
  final double longitude;

  const SavedLocation({
    required this.city,
    required this.country,
    required this.latitude,
    required this.longitude,
  });

  Map<String, dynamic> toJson() => {
        'city': city,
        'country': country,
        'latitude': latitude,
        'longitude': longitude,
      };

  factory SavedLocation.fromJson(Map<String, dynamic> json) {
    return SavedLocation(
      city: json['city'] as String? ?? '',
      country: json['country'] as String? ?? '',
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
    );
  }

  String encode() => jsonEncode(toJson());

  static SavedLocation decode(String source) =>
      SavedLocation.fromJson(jsonDecode(source) as Map<String, dynamic>);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SavedLocation &&
          city == other.city &&
          country == other.country;

  @override
  int get hashCode => city.hashCode ^ country.hashCode;
}
