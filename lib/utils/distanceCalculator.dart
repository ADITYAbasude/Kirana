import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

double getDistance(Position location1, double lat, double lng) {
  final distanceInMeters = Geolocator.distanceBetween(
    location1.latitude,
    location1.longitude,
    lat,
    lng,
  );
  return distanceInMeters;
}
