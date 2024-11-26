import 'package:google_maps_flutter/google_maps_flutter.dart';

// Sample members list
final List<Member> members = [
  Member(id: '1', name: 'Sakshi'),
  Member(id: '2', name: 'Naman '),
  Member(id: '3', name: 'Raaj '),
  Member(id: '4', name: 'Prianka'),
  Member(id: '5', name: 'Shubham'),
  Member(id: '6', name: 'Sunil'),
  Member(id: '7', name: 'Mehul'),
];

// Sample route data, linking each member to their route
final List<RouteData> routeData = [
  RouteData(
    id: '1',
    name: 'John\'s Route',
    startLocation: const LatLng(28.7041, 77.1025),
    endLocation: const LatLng(28.5355, 77.3910),
    routePoints: [
      const LatLng(28.7041, 77.1025),
      const LatLng(28.6149, 77.2090),
      const LatLng(28.5355, 77.3910),
    ],
    pauses: [const LatLng(28.6149, 77.2090)],
    distanceKm: 40.5,
    durationMinutes: 60,
  ),
  RouteData(
    id: '4',
    name: 'Michael\'s Route',
    startLocation: const LatLng(28.4595, 77.0266),
    endLocation: const LatLng(28.4089, 77.3178),
    routePoints: [
      const LatLng(28.4595, 77.0266),
      const LatLng(28.4448, 77.1029),
      const LatLng(28.4089, 77.3178),
    ],
    pauses: [const LatLng(28.4448, 77.1029)],
    distanceKm: 35.2,
    durationMinutes: 50,
  ),
  RouteData(
    id: '5',
    name: 'Emily\'s Route',
    startLocation: const LatLng(28.5355, 77.3910),
    endLocation: const LatLng(28.4089, 77.5797),
    routePoints: [
      const LatLng(28.5355, 77.3910),
      const LatLng(28.4563, 77.4567),
      const LatLng(28.4089, 77.5797),
    ],
    pauses: [const LatLng(28.4563, 77.4567)],
    distanceKm: 45.7,
    durationMinutes: 65,
  ),
  RouteData(
    id: '6',
    name: 'David\'s Route',
    startLocation: const LatLng(28.7041, 77.1025),
    endLocation: const LatLng(28.7046, 77.4206),
    routePoints: [
      const LatLng(28.7041, 77.1025),
      const LatLng(28.7243, 77.2034),
      const LatLng(28.7046, 77.4206),
    ],
    pauses: [const LatLng(28.7243, 77.2034)],
    distanceKm: 50.3,
    durationMinutes: 70,
  ),
  RouteData(
    id: '7',
    name: 'Sophia\'s Route',
    startLocation: const LatLng(28.4089, 77.3178),
    endLocation: const LatLng(28.5355, 77.3910),
    routePoints: [
      const LatLng(28.4089, 77.3178),
      const LatLng(28.4511, 77.3456),
      const LatLng(28.5355, 77.3910),
    ],
    pauses: [const LatLng(28.4511, 77.3456)],
    distanceKm: 30.8,
    durationMinutes: 45,
  ),
];

// Visited locations for each member
final Map<String, List<LatLng>> visitedLocations = {
  '1': [
    const LatLng(28.7041, 77.1025),
    const LatLng(28.5355, 77.3910),
  ],
  '2': [
    const LatLng(28.4595, 77.0266),
    const LatLng(28.6149, 77.2090),
  ],
  '3': [
    const LatLng(28.5355, 77.3910),
    const LatLng(28.7046, 77.4206),
  ],
  '4': [
    const LatLng(28.4595, 77.0266),
    const LatLng(28.4089, 77.3178),
  ],
  '5': [
    const LatLng(28.5355, 77.3910),
    const LatLng(28.4089, 77.5797),
  ],
  '6': [
    const LatLng(28.7041, 77.1025),
    const LatLng(28.7046, 77.4206),
  ],
  '7': [
    const LatLng(28.4089, 77.3178),
    const LatLng(28.5355, 77.3910),
  ],
};

// Dummy Member class for member data
class Member {
  final String id;
  final String name;

  Member({required this.id, required this.name});
}

// RouteData class as described before
class RouteData {
  final String id;
  final String name;
  final LatLng startLocation;
  final LatLng endLocation;
  final List<LatLng> routePoints;
  final List<LatLng> pauses;
  final double distanceKm;
  final int durationMinutes;

  RouteData({
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
