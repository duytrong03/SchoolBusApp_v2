import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:maplibre_gl/maplibre_gl.dart';
import 'package:pdm_app/features/taixe/bando/map_controller.dart';

class MapScreenTaixe extends StatefulWidget {
  const MapScreenTaixe({super.key});

  @override
  State<MapScreenTaixe> createState() => _MapScreenTaixeState();
}

class _MapScreenTaixeState extends State<MapScreenTaixe> {
  MapLibreMapController? _mapController;
  StreamSubscription<Position>? _positionStream;
  LatLng? _currentLocation;
  Circle? _userCircle;
  bool _isFollowing = true;
  bool _locationLoaded = false;
  bool _mapReady = false;

  @override
  void initState() {
    super.initState();
    _initLocation();
  }

  // ----------------------------------------------------------
  // Lấy vị trí ban đầu
  // ----------------------------------------------------------
  Future<void> _initLocation() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.deniedForever ||
          permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Cần cấp quyền truy cập vị trí')),
        );
        return;
      }

      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Vui lòng bật GPS')),
        );
        await Geolocator.openLocationSettings();
        return;
      }

      final pos = await Geolocator.getCurrentPosition();
      setState(() {
        _currentLocation = LatLng(pos.latitude, pos.longitude);
        _locationLoaded = true;
      });

      _listenToLocation();
    } catch (e) {
      debugPrint('❌ Lỗi khi khởi tạo GPS: $e');
    }
  }

  // ----------------------------------------------------------
  // Theo dõi GPS realtime
  // ----------------------------------------------------------
  void _listenToLocation() {
    _positionStream = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.best,
        distanceFilter: 20,
      ),
    ).listen((pos) async {
      final newLoc = LatLng(pos.latitude, pos.longitude);
      setState(() => _currentLocation = newLoc);

      if (_mapController != null && _userCircle != null) {
        await _mapController!.updateCircle(
          _userCircle!,
          CircleOptions(geometry: newLoc),
        );
      }

      if (_isFollowing && _mapController != null) {
        _mapController!.animateCamera(CameraUpdate.newLatLng(newLoc));
      }
    });
  }

  // ----------------------------------------------------------
  // Khi Map được tạo
  // ----------------------------------------------------------
  void _onMapCreated(MapLibreMapController controller) {
    _mapController = controller;
  }

  // ----------------------------------------------------------
  // Khi style đã load xong → thêm marker + GPS
  // ----------------------------------------------------------
  Future<void> _onStyleLoaded() async {
    if (_mapController == null) return;

    _mapReady = true;

    // ✅ Thêm marker tĩnh (trường, điểm đón)
    final mapCtrl = MapController(mapController: _mapController!);
    try {
      await mapCtrl.addStaticMarkers();
      debugPrint('📍 Marker tĩnh đã được thêm');
    } catch (e) {
      debugPrint('❌ Lỗi khi thêm marker tĩnh: $e');
    }

    // ✅ Vẽ chấm xanh hiện vị trí tài xế
    if (_currentLocation != null) {
      _userCircle = await _mapController!.addCircle(
        CircleOptions(
          geometry: _currentLocation!,
          circleColor: "#007AFF",
          circleRadius: 6.0,
          circleStrokeColor: "#ffffff",
          circleStrokeWidth: 2.0,
        ),
      );

      await _mapController!.animateCamera(
        CameraUpdate.newLatLngZoom(_currentLocation!, 16),
      );
    }
  }

  void _toggleFollow() {
    setState(() {
      _isFollowing = !_isFollowing;
      if (_isFollowing && _currentLocation != null && _mapController != null) {
        _mapController!.animateCamera(
          CameraUpdate.newLatLng(_currentLocation!),
        );
      }
    });
  }

  @override
  void dispose() {
    _positionStream?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_locationLoaded) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Bản đồ tài xế"),
        backgroundColor: Colors.blueAccent,
      ),
      body: MapLibreMap(
        styleString:
            "https://api.maptiler.com/maps/streets/style.json?key=pUBUuP2WfgOr936olMQR",
        onMapCreated: _onMapCreated,
        onStyleLoadedCallback: _onStyleLoaded,
        initialCameraPosition: CameraPosition(
          target: _currentLocation!,
          zoom: 16,
        ),
        myLocationEnabled: false,
        compassEnabled: false,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor:
            _isFollowing ? Colors.blueAccent : Colors.grey.shade600,
        onPressed: _toggleFollow,
        child: Icon(
          _isFollowing ? Icons.gps_fixed : Icons.gps_not_fixed,
        ),
      ),
    );
  }
}
