import 'package:geolocator/geolocator.dart';

Future<Position?> getLocation() async {
  if (!(await Geolocator.isLocationServiceEnabled())) {
    return null;
  }
  LocationPermission perm = await Geolocator.checkPermission();
  if (perm == LocationPermission.deniedForever) {
    return null;
  }
  if (perm == LocationPermission.denied) {
    perm = await Geolocator.requestPermission();
    if (perm == LocationPermission.denied) {
      return null;
    }
  }
  return await Geolocator.getCurrentPosition();
}
