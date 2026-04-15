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
    print(" In getCurrentPosition fxn ");
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      print(
        " in getCurrentPosition fxn serviceEnabled not enabled $serviceEnabled",
      );
      return null;
    }
    print(" in getCurrentPosition fxn serviceEnabled  status $serviceEnabled");

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return null;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return null;
    }

    return await Geolocator.getCurrentPosition();
  }

  // Get country code from coordinates
  Future<String?> getCountryCodeFromPosition_(Position position) async {
    print('getCountryCodeFromPosition fxn $position');
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      print(
        'getCountryCodeFromPosition_placemarks fxn This is the url: ${placemarks}',
      );

      if (placemarks.isNotEmpty) {
        return placemarks.first.isoCountryCode;
      }
    } catch (e) {
      print('Error getting country code: ${e.toString()}');
    }
    return null;
  }

  Future<String?> getCountryCodeFromPosition(Position position) async {
    if (kIsWeb) {
      // Web implementation using Nominatim (OpenStreetMap)
      try {
        final url = Uri.parse(
          'https://nominatim.openstreetmap.org/reverse?format=json&lat=${position.latitude}&lon=${position.longitude}&zoom=10&addressdetails=1',
        );
        print('getCountryCodeFromPosition fxn This is the url: ${url}');

        final response = await http.get(
          url,
          headers: {
            'User-Agent':
                'InsuredApp_Flutter_Web', // Nominatim requires a User-Agent
          },
        );

        print(
          'getCountryCodeFromPosition fxn this is the response body ${response.body}',
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
      // Native Mobile implementation using the geocoding package
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

  Future<String> getLocationDisplayString(Position position) async {
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
          final address = data['address'];
          // Web usually gives 'city', 'town', or 'village'
          final city =
              address['city'] ??
              address['town'] ??
              address['village'] ??
              address['suburb'] ??
              'Unknown City';
          final country = address['country'] ?? 'Unknown Country';
          return '$city, $country';
        }
      } catch (e) {
        debugPrint('Web Display String Error: $e');
      }
      return '${position.latitude.toStringAsFixed(2)}, ${position.longitude.toStringAsFixed(2)}';
    } else {
      // Native Mobile
      try {
        List<Placemark> placemarks = await placemarkFromCoordinates(
          position.latitude,
          position.longitude,
        );
        if (placemarks.isNotEmpty) {
          final place = placemarks.first;
          return '${place.locality ?? place.administrativeArea}, ${place.country}';
        }
      } catch (e) {
        debugPrint('Native Display String Error: $e');
      }
      return '${position.latitude.toStringAsFixed(2)}, ${position.longitude.toStringAsFixed(2)}';
    }
  }

  // Get language code from country code (ISO 3166-1 alpha-2 to language)
  String? languageFromCountryCode(String countryCode) {
    // Map common country codes to language codes
    switch (countryCode.toUpperCase()) {
      case 'KE':
      case 'TZ':
      case 'UG':
        return 'sw'; // Swahili for East Africa
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
      default:
        return null; // fallback to current setting
    }
  }

  // One-shot: get language automatically
  Future<String?> detectLanguageFromLocation() async {
    final position = await getCurrentPosition();
    if (position == null) return null;
    final countryCode = await getCountryCodeFromPosition(position);
    if (countryCode == null) return null;
    return languageFromCountryCode(countryCode);
  }
}
