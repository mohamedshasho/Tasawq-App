import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:collection/collection.dart';

import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uuid/uuid.dart';

import '../constants.dart';

class GoogleMapService {
  static final GoogleMapService _googleMapService =
      GoogleMapService._internal();
  static Set<Marker> _markers = Set<Marker>();
  static Set<Marker> get marker => _markers;
  factory GoogleMapService() {
    return _googleMapService;
  }
  GoogleMapService._internal();

  CameraPosition getMyPosition(double lat, double long) {
    final CameraPosition myPosition = CameraPosition(
      target: LatLng(lat, long),
      zoom: 13.4746,
    );
    return myPosition;
  }

  Set<Circle> addCircle(double lat, double long) {
    String fileID = Uuid().v4();
    Set<Circle> circles = Set.from([
      Circle(
        circleId: CircleId(fileID),
        center: LatLng(lat, long),
        radius: 3000,
        strokeColor: secondaryColor,
        strokeWidth: 3,
      ),
    ]);
    return circles;
  }

  static void addMarker(
      double lat, double long, String title, String id, String? image) async {
    BitmapDescriptor icon;
    if (image != null) {
      icon = await getImage(image);
    } else {
      icon = BitmapDescriptor.defaultMarker;
    }

    final MarkerId markerId = MarkerId(id);
    Marker marker = Marker(
        markerId: markerId,
        icon: icon,
        position: LatLng(lat, long),
        infoWindow: InfoWindow(title: title));
    _markers.add(marker);
  }

  static Future<BitmapDescriptor> getImage(String imageUrl) async {
    final int targetWidth = 70;
    final File markerImageFile =
        await DefaultCacheManager().getSingleFile(imageUrl);
    final Uint8List markerImageBytes = await markerImageFile.readAsBytes();
    final Codec markerImageCodec = await instantiateImageCodec(
      markerImageBytes,
      targetWidth: targetWidth,
    );
    final FrameInfo frameInfo = await markerImageCodec.getNextFrame();
    final ByteData? byteData = await frameInfo.image.toByteData(
      format: ImageByteFormat.png,
    );
    final Uint8List resizedMarkerImageBytes = byteData!.buffer.asUint8List();
    return BitmapDescriptor.fromBytes(resizedMarkerImageBytes);
  }

  static Marker getMyMarker(String id) {
    //todo error some time
    return _markers.firstWhere((element) => element.mapsId.value == id);
  }

  static bool foundMarker(String id) {
    var found =
        _markers.firstWhereOrNull((element) => element.mapsId.value == id);
    return found != null;
  }

  static void clearMarker() {
    _markers.clear();
  }
}
