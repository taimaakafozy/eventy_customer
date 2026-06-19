import 'package:eventy_customer/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

class PickLocationPage extends StatefulWidget {
  const PickLocationPage({super.key});

  @override
  State<PickLocationPage> createState() => _PickLocationPageState();
}

class _PickLocationPageState extends State<PickLocationPage> {
  final MapController _mapController = MapController();

  LatLng? selectedLocation;

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

      if (!serviceEnabled) {
        throw Exception("Location services are disabled");
      }

      LocationPermission permission =
          await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        throw Exception("Location permission denied");
      }

      final position = await Geolocator.getCurrentPosition(
  locationSettings: const LocationSettings(
    accuracy: LocationAccuracy.high,
  ),
);
print("LAT: ${position.latitude}");
print("LNG: ${position.longitude}");
      selectedLocation = LatLng(
        position.latitude,
        position.longitude,
      );

      setState(() {
        isLoading = false;
      });
    } catch (e) {
  print("LOCATION ERROR: $e");

  setState(() {
    isLoading = false;
    selectedLocation = const LatLng(33.5138, 36.2765);
  });

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text("Location Error: $e"),
    ),
  );
}
  }

  Future<void> _confirmLocation() async {
    if (selectedLocation == null) return;

    try {
      final placemarks = await placemarkFromCoordinates(
        selectedLocation!.latitude,
        selectedLocation!.longitude,
      );

      String locationName = "";

      if (placemarks.isNotEmpty) {
        final place = placemarks.first;

        locationName =
            "${place.locality ?? ""}, ${place.country ?? ""}";
      }

      Navigator.pop(
        context,
        {
          'locationName': locationName,
          'latitude': selectedLocation!.latitude,
          'longitude': selectedLocation!.longitude,
        },
      );
    } catch (e) {
      Navigator.pop(
        context,
        {
          'locationName': "",
          'latitude': selectedLocation!.latitude,
          'longitude': selectedLocation!.longitude,
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading || selectedLocation == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Choose Location"),
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: selectedLocation!,
              initialZoom: 15,
              onPositionChanged: (position, hasGesture) {
                selectedLocation = position.center;
              },
            ),
            children: [
              TileLayer(
                urlTemplate:
                    'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName:
                    'com.example.eventy_customer',
              ),

              MarkerLayer(
                markers: [
                  Marker(
                    point: selectedLocation!,
                    width: 60,
                    height: 60,
                    child: Icon(
                      Icons.location_on,
                      size: 45,
                      color: AppColors.gold,
                    ),
                  ),
                ],
              ),
            ],
          ),

          Positioned(
            bottom: 25,
            left: 20,
            right: 20,
            child: ElevatedButton(
              onPressed: _confirmLocation,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  vertical: 16,
                ),
                backgroundColor: AppColors.primary,
              ),
              child: const Text(
                "Confirm Location",
              ),
            ),
          ),
        ],
      ),
    );
  }
}