import 'package:location/location.dart';

class LocationHelper {
  static final LocationHelper _locationHelper = LocationHelper._internal();
  factory LocationHelper() {
    return _locationHelper;
  }
  LocationHelper._internal();
  Location _location = Location();
  late bool _serviceEnabled;
  late PermissionStatus _permissionGranted;
  static LocationData? _locationData;
  static getLocationData() {
    return _locationData;
  }

  Future<LocationData?> getLocation() async {
    _serviceEnabled = await _location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await _location.requestService();
      if (!_serviceEnabled) {
        return null;
      }
    }
    _permissionGranted = await _location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await _location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return null;
      }
    }
    _locationData = await _location.getLocation();
    return _locationData;
  }
}
