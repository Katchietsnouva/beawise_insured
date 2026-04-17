// lib/app_2/features/settings/settings/widgets/location_info_card.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:insured/app_2/core/services/location_service.dart';
import 'package:insured/app_2/core/widgets/glass_card.dart';

class LocationInfoCard extends ConsumerStatefulWidget {
  const LocationInfoCard({super.key});

  @override
  ConsumerState<LocationInfoCard> createState() => _LocationInfoCardState();
}

class _LocationInfoCardState extends ConsumerState<LocationInfoCard> {
  String _locationInfo = 'Detecting...';
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _fetchLocation();
  }

  Future<void> _fetchLocation() async {
    setState(() => _loading = true);
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() {
          _locationInfo = 'Location services disabled';
          _loading = false;
        });
        print('Location service serviceEnabled : ${serviceEnabled}');
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() {
            _locationInfo = 'Location permission denied';
            _loading = false;
          });
          print('Location service permission : ${permission}');
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        setState(() {
          _locationInfo = 'Location permission permanently denied';
          _loading = false;
        });
        print('Location service permission : ${permission}');
        return;
      }

      final position = await Geolocator.getCurrentPosition();
      print("Here is the position from _fetchLocation fxn: $position");
      final placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      print("Here is the placemarks from _fetchLocation fxn: $placemarks");

      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        final city = place.locality ?? place.administrativeArea ?? '';
        final country = place.country ?? place.isoCountryCode ?? '';
        setState(() {
          _locationInfo = '$city, $country'.trim().replaceAll(', ', ',');
          if (_locationInfo.isEmpty || _locationInfo == ',') {
            _locationInfo =
                '${position.latitude.toStringAsFixed(2)}, ${position.longitude.toStringAsFixed(2)}';
          }
          _loading = false;
        });
        print('Location service : ${placemarks}');
      } else {
        setState(() {
          _locationInfo = 'Location found (no address)';
          _loading = false;
          print('Location service : ${_locationInfo}');
        });
      }
    } catch (e) {
      setState(() {
        _locationInfo = 'Error: $e';
        _loading = false;
        print('Location service err: ${e.toString()}');
      });
    }
  }

  Future<void> _fetchLocation_() async {
    setState(() => _loading = true);
    try {
      // Use the service from the provider
      final locationService = ref.read(locationServiceProvider);

      final position = await locationService.getCurrentPosition();

      if (position == null) {
        setState(() {
          _locationInfo = 'Location access denied';
          _loading = false;
        });
        return;
      }

      // Use our new web-safe display method
      final displayString = await locationService.getLocationDisplayString(
        position,
      );

      setState(() {
        _locationInfo = displayString;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _locationInfo = 'Error: $e';
        _loading = false;
      });
      debugPrint('UI Location Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            const Icon(Icons.location_on, color: Colors.orange),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Current Location',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _loading ? 'Updating...' : _locationInfo,
                    style: const TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.refresh, color: Colors.white70),
              onPressed: _fetchLocation,
            ),
          ],
        ),
      ),
    );
  }
}
