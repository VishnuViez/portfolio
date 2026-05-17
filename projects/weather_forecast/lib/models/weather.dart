// ============================================================
// Weather Data Models — maps from OpenWeatherMap 3.0 OneCall API
// ============================================================

class WeatherData {
  final Location location;
  final CurrentWeather current;
  final List<HourlyForecast> hourly;
  final List<DailyForecast> daily;
  final AirQuality? airQuality;

  const WeatherData({
    required this.location,
    required this.current,
    required this.hourly,
    required this.daily,
    this.airQuality,
  });

  factory WeatherData.fromOneCallJson(
    Map<String, dynamic> json, {
    required String cityName,
    required String countryName,
  }) {
    return WeatherData(
      location: Location(
        city: cityName,
        country: countryName,
        latitude: (json['lat'] as num).toDouble(),
        longitude: (json['lon'] as num).toDouble(),
      ),
      current: CurrentWeather.fromJson(json['current'] as Map<String, dynamic>),
      hourly: (json['hourly'] as List<dynamic>?)
              ?.take(24)
              .map((e) => HourlyForecast.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      daily: (json['daily'] as List<dynamic>?)
              ?.take(7)
              .map((e) => DailyForecast.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      airQuality: null, // Populated separately if needed
    );
  }

  /// Build from the legacy /weather + /forecast endpoints as a fallback.
  factory WeatherData.fromLegacyJson(
    Map<String, dynamic> currentJson,
    Map<String, dynamic> forecastJson,
  ) {
    final sys = currentJson['sys'] as Map<String, dynamic>? ?? {};
    final weather =
        (currentJson['weather'] as List<dynamic>?)?.first as Map<String, dynamic>? ?? {};
    final main = currentJson['main'] as Map<String, dynamic>? ?? {};
    final wind = currentJson['wind'] as Map<String, dynamic>? ?? {};
    final coord = currentJson['coord'] as Map<String, dynamic>? ?? {};

    final forecastList = forecastJson['list'] as List<dynamic>? ?? [];

    return WeatherData(
      location: Location(
        city: currentJson['name'] as String? ?? '',
        country: sys['country'] as String? ?? '',
        latitude: (coord['lat'] as num?)?.toDouble() ?? 0,
        longitude: (coord['lon'] as num?)?.toDouble() ?? 0,
      ),
      current: CurrentWeather(
        temperature: (main['temp'] as num?)?.toDouble() ?? 0,
        feelsLike: (main['feels_like'] as num?)?.toDouble() ?? 0,
        description: weather['description'] as String? ?? '',
        iconCode: weather['icon'] as String? ?? '01d',
        humidity: (main['humidity'] as num?)?.toInt() ?? 0,
        windSpeed: (wind['speed'] as num?)?.toDouble() ?? 0,
        windDeg: (wind['deg'] as num?)?.toDouble() ?? 0,
        pressure: (main['pressure'] as num?)?.toInt() ?? 0,
        visibility: (currentJson['visibility'] as num?)?.toInt() ?? 10000,
        uvIndex: 0,
        sunrise: DateTime.fromMillisecondsSinceEpoch(
          ((sys['sunrise'] as num?)?.toInt() ?? 0) * 1000,
        ),
        sunset: DateTime.fromMillisecondsSinceEpoch(
          ((sys['sunset'] as num?)?.toInt() ?? 0) * 1000,
        ),
      ),
      hourly: forecastList.take(8).map((e) {
        final f = e as Map<String, dynamic>;
        final fWeather =
            (f['weather'] as List<dynamic>?)?.first as Map<String, dynamic>? ?? {};
        final fMain = f['main'] as Map<String, dynamic>? ?? {};
        return HourlyForecast(
          time: DateTime.fromMillisecondsSinceEpoch(
            ((f['dt'] as num?)?.toInt() ?? 0) * 1000,
          ),
          temperature: (fMain['temp'] as num?)?.toDouble() ?? 0,
          iconCode: fWeather['icon'] as String? ?? '01d',
          precipProbability: ((f['pop'] as num?)?.toDouble() ?? 0 * 100).round(),
          description: fWeather['description'] as String? ?? '',
        );
      }).toList(),
      daily: _buildDailyFromForecast(forecastList),
    );
  }

  static List<DailyForecast> _buildDailyFromForecast(List<dynamic> forecastList) {
    final Map<String, List<Map<String, dynamic>>> grouped = {};
    for (final item in forecastList) {
      final f = item as Map<String, dynamic>;
      final dt = DateTime.fromMillisecondsSinceEpoch(
        ((f['dt'] as num?)?.toInt() ?? 0) * 1000,
      );
      final key = '${dt.year}-${dt.month}-${dt.day}';
      grouped.putIfAbsent(key, () => []).add(f);
    }

    return grouped.entries.take(7).map((entry) {
      final items = entry.value;
      double minTemp = double.infinity;
      double maxTemp = double.negativeInfinity;
      double totalHumidity = 0;
      double totalWind = 0;
      double totalPop = 0;
      String icon = '01d';
      String desc = '';

      for (final f in items) {
        final main = f['main'] as Map<String, dynamic>? ?? {};
        final wind = f['wind'] as Map<String, dynamic>? ?? {};
        final weather =
            (f['weather'] as List<dynamic>?)?.first as Map<String, dynamic>? ?? {};
        final temp = (main['temp'] as num?)?.toDouble() ?? 0;
        if (temp < minTemp) minTemp = temp;
        if (temp > maxTemp) maxTemp = temp;
        totalHumidity += (main['humidity'] as num?)?.toDouble() ?? 0;
        totalWind += (wind['speed'] as num?)?.toDouble() ?? 0;
        totalPop += (f['pop'] as num?)?.toDouble() ?? 0;
        icon = weather['icon'] as String? ?? icon;
        desc = weather['description'] as String? ?? desc;
      }

      final count = items.length;
      final dt = DateTime.fromMillisecondsSinceEpoch(
        ((items.first['dt'] as num?)?.toInt() ?? 0) * 1000,
      );

      return DailyForecast(
        date: dt,
        tempMin: minTemp == double.infinity ? 0 : minTemp,
        tempMax: maxTemp == double.negativeInfinity ? 0 : maxTemp,
        iconCode: icon,
        description: desc,
        humidity: (totalHumidity / count).round(),
        windSpeed: totalWind / count,
        precipProbability: ((totalPop / count) * 100).round(),
      );
    }).toList();
  }
}

// ── Location ──────────────────────────────────────────────────

class Location {
  final String city;
  final String country;
  final double latitude;
  final double longitude;

  const Location({
    required this.city,
    required this.country,
    required this.latitude,
    required this.longitude,
  });

  factory Location.fromGeoJson(Map<String, dynamic> json) {
    return Location(
      city: json['name'] as String? ?? '',
      country: json['country'] as String? ?? '',
      latitude: (json['lat'] as num).toDouble(),
      longitude: (json['lon'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
        'city': city,
        'country': country,
        'latitude': latitude,
        'longitude': longitude,
      };

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      city: json['city'] as String? ?? '',
      country: json['country'] as String? ?? '',
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
    );
  }
}

// ── Current Weather ──────────────────────────────────────────

class CurrentWeather {
  final double temperature;
  final double feelsLike;
  final String description;
  final String iconCode;
  final int humidity;
  final double windSpeed;
  final double windDeg;
  final int pressure;
  final int visibility;
  final double uvIndex;
  final DateTime sunrise;
  final DateTime sunset;

  const CurrentWeather({
    required this.temperature,
    required this.feelsLike,
    required this.description,
    required this.iconCode,
    required this.humidity,
    required this.windSpeed,
    required this.windDeg,
    required this.pressure,
    required this.visibility,
    required this.uvIndex,
    required this.sunrise,
    required this.sunset,
  });

  factory CurrentWeather.fromJson(Map<String, dynamic> json) {
    final weather =
        (json['weather'] as List<dynamic>?)?.first as Map<String, dynamic>? ?? {};
    return CurrentWeather(
      temperature: (json['temp'] as num?)?.toDouble() ?? 0,
      feelsLike: (json['feels_like'] as num?)?.toDouble() ?? 0,
      description: weather['description'] as String? ?? '',
      iconCode: weather['icon'] as String? ?? '01d',
      humidity: (json['humidity'] as num?)?.toInt() ?? 0,
      windSpeed: (json['wind_speed'] as num?)?.toDouble() ?? 0,
      windDeg: (json['wind_deg'] as num?)?.toDouble() ?? 0,
      pressure: (json['pressure'] as num?)?.toInt() ?? 0,
      visibility: (json['visibility'] as num?)?.toInt() ?? 10000,
      uvIndex: (json['uvi'] as num?)?.toDouble() ?? 0,
      sunrise: DateTime.fromMillisecondsSinceEpoch(
        ((json['sunrise'] as num?)?.toInt() ?? 0) * 1000,
      ),
      sunset: DateTime.fromMillisecondsSinceEpoch(
        ((json['sunset'] as num?)?.toInt() ?? 0) * 1000,
      ),
    );
  }

  bool get isDayTime {
    final now = DateTime.now();
    return now.isAfter(sunrise) && now.isBefore(sunset);
  }
}

// ── Hourly Forecast ──────────────────────────────────────────

class HourlyForecast {
  final DateTime time;
  final double temperature;
  final String iconCode;
  final int precipProbability;
  final String description;

  const HourlyForecast({
    required this.time,
    required this.temperature,
    required this.iconCode,
    required this.precipProbability,
    required this.description,
  });

  factory HourlyForecast.fromJson(Map<String, dynamic> json) {
    final weather =
        (json['weather'] as List<dynamic>?)?.first as Map<String, dynamic>? ?? {};
    return HourlyForecast(
      time: DateTime.fromMillisecondsSinceEpoch(
        ((json['dt'] as num?)?.toInt() ?? 0) * 1000,
      ),
      temperature: (json['temp'] as num?)?.toDouble() ?? 0,
      iconCode: weather['icon'] as String? ?? '01d',
      precipProbability: ((json['pop'] as num?)?.toDouble() ?? 0 * 100).round(),
      description: weather['description'] as String? ?? '',
    );
  }
}

// ── Daily Forecast ───────────────────────────────────────────

class DailyForecast {
  final DateTime date;
  final double tempMin;
  final double tempMax;
  final String iconCode;
  final String description;
  final int humidity;
  final double windSpeed;
  final int precipProbability;

  const DailyForecast({
    required this.date,
    required this.tempMin,
    required this.tempMax,
    required this.iconCode,
    required this.description,
    required this.humidity,
    required this.windSpeed,
    required this.precipProbability,
  });

  factory DailyForecast.fromJson(Map<String, dynamic> json) {
    final weather =
        (json['weather'] as List<dynamic>?)?.first as Map<String, dynamic>? ?? {};
    final temp = json['temp'] as Map<String, dynamic>? ?? {};
    return DailyForecast(
      date: DateTime.fromMillisecondsSinceEpoch(
        ((json['dt'] as num?)?.toInt() ?? 0) * 1000,
      ),
      tempMin: (temp['min'] as num?)?.toDouble() ?? 0,
      tempMax: (temp['max'] as num?)?.toDouble() ?? 0,
      iconCode: weather['icon'] as String? ?? '01d',
      description: weather['description'] as String? ?? '',
      humidity: (json['humidity'] as num?)?.toInt() ?? 0,
      windSpeed: (json['wind_speed'] as num?)?.toDouble() ?? 0,
      precipProbability: ((json['pop'] as num?)?.toDouble() ?? 0 * 100).round(),
    );
  }
}

// ── Air Quality ──────────────────────────────────────────────

class AirQuality {
  final int aqi;
  final String level;

  const AirQuality({required this.aqi, required this.level});

  factory AirQuality.fromJson(Map<String, dynamic> json) {
    final list = json['list'] as List<dynamic>?;
    if (list == null || list.isEmpty) {
      return const AirQuality(aqi: 0, level: 'Unknown');
    }
    final main = (list.first as Map<String, dynamic>)['main'] as Map<String, dynamic>? ?? {};
    final aqi = (main['aqi'] as num?)?.toInt() ?? 0;
    const levels = {1: 'Good', 2: 'Fair', 3: 'Moderate', 4: 'Poor', 5: 'Very Poor'};
    return AirQuality(aqi: aqi, level: levels[aqi] ?? 'Unknown');
  }
}
