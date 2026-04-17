// lib/app_2/core/services/location_service.dart
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

final locationServiceProvider = Provider<LocationService>((ref) {
  return LocationService();
});

class LocationService {
  // Request permission and get current position
  Future<Position?> getCurrentPosition() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return null;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return null;
    }
    if (permission == LocationPermission.deniedForever) return null;

    return await Geolocator.getCurrentPosition();
  }

  /// Get country code from coordinates (using Nominatim on web, geocoding on mobile)
  Future<String?> getCountryCodeFromPosition(Position position) async {
    if (kIsWeb) {
      try {
        final url = Uri.parse(
          'https://nominatim.openstreetmap.org/reverse?format=json&lat=${position.latitude}&lon=${position.longitude}&zoom=10&addressdetails=1',
        );
        final response = await http.get(
          url,
          headers: {'User-Agent': 'InsuredApp_Flutter_Web'},
        );
        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          return data['address']?['country_code']?.toString().toUpperCase();
        }
      } catch (e) {
        debugPrint('Web Geocoding error: $e');
      }
      return null;
    } else {
      try {
        List<Placemark> placemarks = await placemarkFromCoordinates(
          position.latitude,
          position.longitude,
        );
        return placemarks.isNotEmpty ? placemarks.first.isoCountryCode : null;
      } catch (e) {
        debugPrint('Native Geocoding error: $e');
        return null;
      }
    }
  }

  /// Get a human-readable location description (e.g., "City, Country")
  Future<String> getLocationDescription(Position position) async {
    try {
      if (kIsWeb) {
        final url = Uri.parse(
          'https://nominatim.openstreetmap.org/reverse?format=json&lat=${position.latitude}&lon=${position.longitude}&zoom=10&addressdetails=1',
        );
        final response = await http.get(
          url,
          headers: {'User-Agent': 'InsuredApp_Flutter_Web'},
        );
        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          final address = data['address'] ?? {};
          final city =
              address['city'] ??
              address['town'] ??
              address['village'] ??
              address['suburb'] ??
              '';
          final country = address['country'] ?? '';
          if (country.isNotEmpty) {
            return city.isNotEmpty ? '$city, $country' : country;
          }
        }
      } else {
        List<Placemark> placemarks = await placemarkFromCoordinates(
          position.latitude,
          position.longitude,
        );
        if (placemarks.isNotEmpty) {
          final place = placemarks.first;
          final city = place.locality ?? place.administrativeArea ?? '';
          final country = place.country ?? place.isoCountryCode ?? '';
          if (country.isNotEmpty) {
            return city.isNotEmpty ? '$city, $country' : country;
          }
        }
      }
    } catch (e) {
      debugPrint('Error in getLocationDescription: $e');
    }
    // Fallback to coordinates
    return '${position.latitude.toStringAsFixed(2)}, ${position.longitude.toStringAsFixed(2)}';
  }

  // Map country code to language name (as before)
  String? languageFromCountryCode(String countryCode) {
    switch (countryCode.toUpperCase()) {
      case 'KE':
      case 'TZ':
      case 'UG':
        return 'sw';
      case 'FR':
        return 'fr';
      case 'DE':
        return 'de';
      case 'IT':
        return 'it';
      case 'US':
      case 'GB':
      case 'CA':
      case 'AU':
        return 'en';
      case 'RU':
        return 'ru';
      case 'CN':
        return 'zh';
      default:
        return null;
    }
  }

  // One-shot: get language automatically
  Future<String?> detectLanguageFromLocation() async {
    final position = await getCurrentPosition();
    print("detectLanguageFromLocation fxn yoooo position is $position");
    if (position == null) return null;
    final countryCode = await getCountryCodeFromPosition(position);
    print("detectLanguageFromLocation fxn yoooo countryCode is $countryCode");
    if (countryCode == null) return null;
    return languageFromCountryCode(countryCode);
  }
}
