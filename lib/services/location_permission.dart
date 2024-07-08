import 'package:location/location.dart';

class LocationPermission {
  static final _location = Location();
  static bool _isServiceEnabled = false;
  static PermissionStatus _permissionStatus = PermissionStatus.denied;
  static LocationData? currentLocation;

  static Future<void> init() async {
    await checkService();
    await checkPermission();

    await _location.changeSettings(
        accuracy: LocationAccuracy.high, distanceFilter: 10, interval: 1000);
  }

  static Future<void> checkService() async {
    _isServiceEnabled = await _location.serviceEnabled();

    if (!_isServiceEnabled) {
      _isServiceEnabled = await _location.requestService();
      if (!_isServiceEnabled) {
        return;
      }
    }
  }

  static Future<void> checkPermission() async {
    _permissionStatus = await _location.hasPermission();
    if (_permissionStatus == PermissionStatus.denied) {
      _permissionStatus = await _location.requestPermission();
      if (_permissionStatus != PermissionStatus.granted) {
        return; //Sozlamalarda to'g'irlaymiz
      }
    }
  }

  static Future<LocationData> getCurrentLocation() async {
    return currentLocation = await _location.getLocation();
  }

  static Stream<LocationData> getLiveLocation() async* {
    yield* _location.onLocationChanged;
  }
}
