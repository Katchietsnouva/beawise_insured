import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:insured/app_2/core/services/location_service.dart';
import 'package:insured/app_2/core/widgets/custom_text.dart';
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
      final locationService = ref.read(locationServiceProvider);

      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() {
          _locationInfo = 'Location services disabled';
          _loading = false;
        });
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
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        setState(() {
          _locationInfo = 'Location permission permanently denied';
          _loading = false;
        });
        return;
      }

      final position = await Geolocator.getCurrentPosition();
      final description = await locationService.getLocationDescription(
        position,
      );
      setState(() {
        _locationInfo = description;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _locationInfo = 'Unable to get location';
        _loading = false;
      });
      print('Location service err: ${e.toString()}');
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
                  const CustomText(
                    'Current Location',
                    type: CustomTextType.paragraph,
                  ),
                  const SizedBox(height: 4),
                  CustomText(
                    _loading ? 'Updating...' : _locationInfo,
                    type: CustomTextType.paragraph,
                  ),
                ],
              ),
            ),
            IconButton(
              icon: Icon(
                Icons.refresh,
                color: Theme.of(context).colorScheme.onSurface,
              ),
              onPressed: _fetchLocation,
            ),
          ],
        ),
      ),
    );
  }
}
