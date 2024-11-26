import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'dart:math';

class RouteScreen extends StatefulWidget {
  final String startMemberId;
  final String endMemberId;

  const RouteScreen({
    Key? key,
    required this.startMemberId,
    required this.endMemberId,
  }) : super(key: key);

  @override
  _RouteScreenState createState() => _RouteScreenState();
}

class _RouteScreenState extends State<RouteScreen> {
  DateTime _selectedDate = DateTime.now(); // Default to today
  List<LatLng> _routePointsForSelectedDate = [];
  List<LatLng> _stopsForSelectedDate = [];
  List<String> _locationNames = [];
  List<String> _statuses = [];
  List<String> _times = [];
  double _totalDistance = 0.0;

  @override
  void initState() {
    super.initState();
    _fetchRouteForSelectedDate();
  }

  void _fetchRouteForSelectedDate() {
    setState(() {
      // Mock data for route and timeline
      _routePointsForSelectedDate = [
        LatLng(28.7041, 77.1025), // New Delhi
        LatLng(28.6149, 77.2090), // Connaught Place
        LatLng(28.5355, 77.3910), // Noida
      ];
      _stopsForSelectedDate = [LatLng(28.6149, 77.2090)];
      _locationNames = ['New Delhi (Start)', 'Connaught Place (Stop)', 'Noida (End)'];
      _statuses = ['Visited', 'Stopped for 10 mins', 'Completed'];
      _times = ['9:00 AM', '10:15 AM', '11:30 AM'];

      // Calculate total distance
      _totalDistance = _calculateTotalDistance(_routePointsForSelectedDate);
    });
  }

  double _calculateTotalDistance(List<LatLng> points) {
    double totalDistance = 0.0;

    for (int i = 0; i < points.length - 1; i++) {
      totalDistance += _calculateDistance(
        points[i].latitude,
        points[i].longitude,
        points[i + 1].latitude,
        points[i + 1].longitude,
      );
    }

    return totalDistance;
  }

  double _calculateDistance(
      double lat1, double lon1, double lat2, double lon2) {
    const double R = 6371; // Earth's radius in kilometers
    double dLat = _degToRad(lat2 - lat1);
    double dLon = _degToRad(lon2 - lon1);
    double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_degToRad(lat1)) *
            cos(_degToRad(lat2)) *
            sin(dLon / 2) *
            sin(dLon / 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return R * c;
  }

  double _degToRad(double degree) {
    return degree * pi / 180;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Route Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: () => _selectDate(context),
          ),
        ],
      ),
      body: Stack(
        children: [
          // Google Map View
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: _routePointsForSelectedDate.isNotEmpty
                  ? _routePointsForSelectedDate.first
                  : LatLng(0, 0),
              zoom: 12.0,
            ),
            markers: {
              Marker(
                markerId: const MarkerId('start'),
                position: _routePointsForSelectedDate.first,
                infoWindow: InfoWindow(
                  title: _locationNames.first,
                ),
              ),
              Marker(
                markerId: const MarkerId('end'),
                position: _routePointsForSelectedDate.last,
                infoWindow: InfoWindow(
                  title: _locationNames.last,
                ),
              ),
              for (int i = 0; i < _stopsForSelectedDate.length; i++)
                Marker(
                  markerId: MarkerId('stop_${_stopsForSelectedDate[i].latitude}_${_stopsForSelectedDate[i].longitude}'),
                  position: _stopsForSelectedDate[i],
                  icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
                  infoWindow: InfoWindow(
                    title: _locationNames[i + 1],
                  ),
                ),
            },
            polylines: {
              Polyline(
                polylineId: const PolylineId('route'),
                points: _routePointsForSelectedDate,
                color: Colors.blue,
                width: 5,
              ),
            },
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
          ),
          // Bottom Draggable Timeline View
          DraggableScrollableSheet(
            initialChildSize: 0.3, // Initial height as a fraction of the screen
            minChildSize: 0.2, // Minimum height (collapsed state)
            maxChildSize: 0.6, // Maximum height (expanded state)
            builder: (context, scrollController) {
              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16.0),
                    topRight: Radius.circular(16.0),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 8.0,
                      spreadRadius: 2.0,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Drag Handle
                    Center(
                      child: Container(
                        margin: const EdgeInsets.only(top: 8.0, bottom: 16.0),
                        width: 40.0,
                        height: 4.0,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        'Selected Date: ${DateFormat.yMMMd().format(_selectedDate)}',
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Expanded(
                      child: SingleChildScrollView(
                        controller: scrollController,
                        child: Column(
                          children: [
                            ListView.builder(
                              shrinkWrap: true, // Use shrinkWrap for proper list rendering
                              itemCount: _locationNames.length,
                              itemBuilder: (context, index) {
                                double segmentDistance = 0.0;
                                if (index < _routePointsForSelectedDate.length - 1) {
                                  segmentDistance = _calculateDistance(
                                    _routePointsForSelectedDate[index].latitude,
                                    _routePointsForSelectedDate[index].longitude,
                                    _routePointsForSelectedDate[index + 1].latitude,
                                    _routePointsForSelectedDate[index + 1].longitude,
                                  );
                                }
                                return TimelineTile(
                                  isFirst: index == 0,
                                  isLast: index == _locationNames.length - 1,
                                  time: _times[index],
                                  title: _locationNames[index],
                                  status: _statuses[index],
                                  segmentDistance: segmentDistance,
                                );
                              },
                            ),
                            // Display the total distance at the bottom of the timeline
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Text(
                                'Total Distance: ${_totalDistance.toStringAsFixed(2)} km',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  void _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    ) ??
        _selectedDate;

    setState(() {
      _selectedDate = picked;
      _fetchRouteForSelectedDate();
    });
  }
}

class TimelineTile extends StatelessWidget {
  final bool isFirst;
  final bool isLast;
  final String time;
  final String title;
  final String status;
  final double segmentDistance;

  const TimelineTile({
    Key? key,
    required this.isFirst,
    required this.isLast,
    required this.time,
    required this.title,
    required this.status,
    required this.segmentDistance,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (!isFirst)
          Container(
            width: 2,
            height: 60,
            color: Colors.blue,
          ),
        const SizedBox(width: 8),
        Column(
          children: [
            Container(
              width: 10,
              height: 10,
              decoration: const BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
              ),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 60,
                color: Colors.blue,
              ),
          ],
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                time,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                status,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                ),
              ),
              if (segmentDistance > 0.0)
                Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Text(
                    'Distance: ${segmentDistance.toStringAsFixed(2)} km',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black87,
                    ),
                  ),
                ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ],
    );
  }
}
