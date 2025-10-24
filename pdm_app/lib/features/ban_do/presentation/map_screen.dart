import 'package:flutter/material.dart';
import 'package:maplibre_gl/maplibre_gl.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  MapLibreMapController? _mapController;

  // Khi map được khởi tạo
  void _onMapCreated(MapLibreMapController controller) {
    _mapController = controller;
  }

  // Hàm chuyển camera tới vị trí hiện tại (hoặc vị trí giả lập)
  Future<void> _goToMyLocation() async {
    if (_mapController == null) return;

    const newPos = LatLng(21.03, 105.85); // ví dụ: khu vực Hà Nội
    await _mapController!.animateCamera(
      CameraUpdate.newLatLngZoom(newPos, 15),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Theo dõi xe"),
        backgroundColor: Colors.blueAccent,
      ),
      body: MapLibreMap(
        styleString: "https://api.maptiler.com/maps/streets/style.json?key=pUBUuP2WfgOr936olMQR",

        initialCameraPosition: const CameraPosition(
          target: LatLng(21.0285, 105.8542),
          zoom: 13,
        ),

        onMapCreated: _onMapCreated,

        // Hiển thị vị trí người dùng (nếu có quyền truy cập vị trí)
        myLocationEnabled: true,

        // Cho phép người dùng xoay và zoom
        compassEnabled: true,
        rotateGesturesEnabled: true,
        scrollGesturesEnabled: true,
        tiltGesturesEnabled: true,
        zoomGesturesEnabled: true,
      ),

      // Nút bay tới vị trí hiện tại
      floatingActionButton: FloatingActionButton(
        onPressed: _goToMyLocation,
        tooltip: "Về vị trí của tôi",
        backgroundColor: Colors.blueAccent,
        child: const Icon(Icons.my_location),
      ),
    );
  }
}
