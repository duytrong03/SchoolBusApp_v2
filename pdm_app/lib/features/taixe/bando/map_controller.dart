import 'dart:ui';

import 'package:flutter/services.dart';
import 'package:maplibre_gl/maplibre_gl.dart';
import 'package:pdm_app/features/taixe/data/api_service.dart';

class MapController {
  final MapLibreMapController mapController;
  final ApiService apiService = ApiService();

  MapController({required this.mapController});

  Future<void> addStaticMarkers() async {
    // 1. Thêm icon
    final schoolIcon = await rootBundle.load('assets/images/icons/school_icon.png');
    await mapController.addImage("school-icon", schoolIcon.buffer.asUint8List());

    final pickupIcon = await rootBundle.load('assets/images/icons/home_icon.png');
    await mapController.addImage("pickup-icon", pickupIcon.buffer.asUint8List());

    // 2. Marker trường
    await mapController.addSymbol(SymbolOptions(
      geometry: LatLng(21.04256556849624, 105.798300735847),
      iconImage: "school-icon",
      iconSize: 0.3,
      textOffset: Offset(0, 1.2),
    ));

    // 3. Marker điểm đón
    final diemDonList = await apiService.getDiemDon();
    for (var dd in diemDonList) {
      if (dd.viDo != null && dd.kinhDo != null) {
        await mapController.addSymbol(SymbolOptions(  
          geometry: LatLng(dd.viDo!, dd.kinhDo!),
          iconImage: "pickup-icon",
          iconSize: 0.2,
          textOffset: Offset(0, 1.2),
        ));
      }
    }
  }
}