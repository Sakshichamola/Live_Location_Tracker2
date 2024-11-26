import 'package:google_maps_flutter/google_maps_flutter.dart';

class RouteData {
  final String id; // Unique ID for the route (typically matches member ID)
  final String name; // Name of the route (e.g., "Office to Home")
  final LatLng startLocation; // Starting point of the route (LatLng object)
  final LatLng endLocation; // Ending point of the route (LatLng object)
  final List<LatLng> routePoints; // List of points that form the route
  final List<LatLng> pauses; // List of points where there were significant pauses (e.g., >10 minutes)
  final double distanceKm; // Total distance of the route in kilometers
  final int durationMinutes; // Total duration of the route in minutes

  // Constructor to initialize the RouteData object
  const RouteData({
    required this.id,
    required this.name,
    required this.startLocation,
    required this.endLocation,
    required this.routePoints,
    required this.pauses,
    required this.distanceKm,
    required this.durationMinutes,
  });
}
