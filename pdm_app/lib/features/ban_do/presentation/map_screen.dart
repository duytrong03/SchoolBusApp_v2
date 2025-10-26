import 'dart:async';
import 'package:flutter/material.dart';
import 'package:maplibre_gl/maplibre_gl.dart';
import 'package:geolocator/geolocator.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  MapLibreMapController? _mapController;
  StreamSubscription<Position>? _positionStream;
  LatLng? _currentLocation;
  bool _isFollowing = true;

  @override
  void initState() {
    super.initState();
    _initLocation();
  }

  @override
  void dispose() {
    _positionStream?.cancel();
    super.dispose();
  }

  // --- Bước 1: Kiểm tra quyền và khởi tạo GPS ---
  Future<void> _initLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Kiểm tra dịch vụ GPS có bật chưa
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return;
    }

    // Kiểm tra quyền
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Ứng dụng cần quyền truy cập vị trí!')),
        );
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Quyền vị trí bị từ chối vĩnh viễn.')),
      );
      return;
    }

    // --- Bước 2: Lấy vị trí hiện tại ---
    final position = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.best,
      ),
    );

    print('Tọa độ hiện tại: ${position.latitude}, ${position.longitude}');

    setState(() {
      _currentLocation = LatLng(position.latitude, position.longitude);
    });

    // --- Bước 3: Theo dõi vị trí liên tục ---
    _positionStream = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.best,
        distanceFilter: 5, // cập nhật mỗi khi di chuyển trên 5m
      ),
    ).listen((Position pos) {
      setState(() {
        _currentLocation = LatLng(pos.latitude, pos.longitude);
      });

      if (_isFollowing && _mapController != null) {
        _mapController!.animateCamera(
          CameraUpdate.newLatLng(_currentLocation!),
        );
      }
    });
  }

  // --- Bước 4: Khi bản đồ tạo xong ---
  void _onMapCreated(MapLibreMapController controller) {
    _mapController = controller;
  }

  // --- Bước 5: Bật / tắt theo dõi ---
  void _toggleFollow() {
    setState(() {
      _isFollowing = !_isFollowing;
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentLatLng =
        _currentLocation ?? const LatLng(21.0285, 105.8542); // fallback: Hà Nội

    return Scaffold(
      appBar: AppBar(
        title: const Text("Theo dõi GPS (MapLibre)"),
        backgroundColor: Colors.blueAccent,
      ),
      body: Stack(
        children: [
          MapLibreMap(
            styleString:
                "https://api.maptiler.com/maps/streets/style.json?key=pUBUuP2WfgOr936olMQR",
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: currentLatLng,
              zoom: 15,
            ),
            myLocationEnabled: true,
            compassEnabled: true,
            rotateGesturesEnabled: true,
            scrollGesturesEnabled: true,
            tiltGesturesEnabled: true,
            zoomGesturesEnabled: true,
          ),

          // Hiển thị marker nhỏ tại vị trí hiện tại
          if (_currentLocation != null)
            Center(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  color: Colors.blueAccent,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white, width: 3),
                ),
              ),
            ),

          // Nút bật/tắt chế độ theo dõi
          Positioned(
            bottom: 20,
            right: 20,
            child: FloatingActionButton(
              backgroundColor:
                  _isFollowing ? Colors.blueAccent : Colors.grey.shade600,
              onPressed: _toggleFollow,
              child: Icon(
                _isFollowing ? Icons.gps_fixed : Icons.gps_not_fixed,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
