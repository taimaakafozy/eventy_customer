import 'dart:async';

import 'package:eventy_customer/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

class PickLocationPage extends StatefulWidget {
  /// إحداثيات ابتدائية اختيارية (مثلاً موقع سبق للمستخدم أن حدده)
  /// تُستخدم بدل الاعتماد الإجباري على GPS الجهاز الحالي
  final LatLng? initialLocation;

  const PickLocationPage({super.key, this.initialLocation});

  @override  
  State<PickLocationPage> createState() => _PickLocationPageState();
}

class _PickLocationPageState extends State<PickLocationPage> {
  final MapController _mapController = MapController();

  LatLng? _center;
  String? _addressPreview;

  bool _isLoadingLocation = true;
  bool _isResolvingAddress = false;

  Timer? _debounce;

  @override
  void initState() {
    super.initState();

    if (widget.initialLocation != null) {
      _center = widget.initialLocation;
      _isLoadingLocation = false;
      _resolveAddress(_center!);
    } else {
      _getCurrentLocation();
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  Future<void> _getCurrentLocation() async {
    setState(() => _isLoadingLocation = true);

    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) throw Exception("Location services are disabled");

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
        throw Exception("Location permission denied");
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
      );

      _center = LatLng(position.latitude, position.longitude);

      if (mounted) {
        _mapController.move(_center!, 15);
        setState(() => _isLoadingLocation = false);
      }

      await _resolveAddress(_center!);
    } catch (e) {
      _center ??= const LatLng(31.9539, 35.9106); // Amman كموقع افتراضي عند الفشل

      if (mounted) {
        setState(() => _isLoadingLocation = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Couldn't get your current location: $e")),
        );
      }

      await _resolveAddress(_center!);
    }
  }

  void _onMapEvent(camera, hasGesture) {
    _center = camera.center;

    if (!hasGesture) return;

    /// Debounce: ننتظر توقف حركة الخريطة قبل عمل reverse geocoding
    /// تجنبًا لإطلاق طلبات كثيرة أثناء السحب المستمر
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 600), () {
      _resolveAddress(camera.center);
    });
  }

  Future<void> _resolveAddress(LatLng point) async {
    if (!mounted) return;
    setState(() => _isResolvingAddress = true);

    try {
      final placemarks = await placemarkFromCoordinates(point.latitude, point.longitude);

      String name = "";
      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        name = [place.locality, place.country]
            .where((e) => e != null && e.trim().isNotEmpty)
            .join(", ");
      }

      if (mounted) {
        setState(() {
          _addressPreview = name.isEmpty ? "Unknown location" : name;
          _isResolvingAddress = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _addressPreview = null;
          _isResolvingAddress = false;
        });
      }
    }
  }

  void _confirmLocation() {
    if (_center == null) return;

    Navigator.pop(context, {
      'locationName': _addressPreview ?? "",
      'latitude': _center!.latitude,
      'longitude': _center!.longitude,
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (_isLoadingLocation || _center == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Choose Location")),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _center!,
              initialZoom: 15,
              onPositionChanged: _onMapEvent,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.eventy_customer',
                errorTileCallback: (tile, error, stackTrace) {
                  /// نتجاهل أخطاء تحميل التبليطات الفردية بصمت (مشكلة شبكة مؤقتة)
                  /// حتى لا تتعطل الواجهة — المستخدم يبقى قادرًا على تحديد الموقع
                  /// حتى لو لم تظهر بعض تبليطات الخريطة
                },
              ),
            ],
          ),

          /// Pin مركزي ثابت — الخريطة تتحرك تحته
          IgnorePointer(
            child: Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 36),
                child: Icon(Icons.location_on, size: 46, color: AppColors.gold),
              ),
            ),
          ),

          /// معاينة العنوان
          Positioned(
            top: 16,
            left: 16,
            right: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(.08), blurRadius: 10, offset: const Offset(0, 4)),
                ],
              ),
              child: Row(
                children: [
                  Icon(Icons.place_rounded, size: 18, color: theme.primaryColor),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _isResolvingAddress ? "Locating address..." : (_addressPreview ?? "Move the map to select"),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
          ),

          /// زر إعادة التمركز على موقع الجهاز الحالي
          Positioned(
            bottom: 100,
            right: 16,
            child: FloatingActionButton(
              heroTag: "locate_me",
              backgroundColor: theme.cardColor,
              foregroundColor: theme.primaryColor,
              onPressed: _getCurrentLocation,
              child: const Icon(Icons.my_location_rounded),
            ),
          ),

          Positioned(
            bottom: 25,
            left: 20,
            right: 20,
            child: ElevatedButton(
              onPressed: _confirmLocation,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: AppColors.primary,
              ),
              child: const Text("Confirm Location"),
            ),
          ),
        ],
      ),
    );
  }
}