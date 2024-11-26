import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart'; // For real-time location updates
import 'package:intl/intl.dart'; // For date formatting

class LocationScreen extends StatefulWidget {
  final String memberId;

  const LocationScreen({Key? key, required this.memberId}) : super(key: key);

  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  late GoogleMapController mapController;
  late Location location;
  LatLng? _currentLocation; // To store current location
  DateTime _selectedDate = DateTime.now(); // Default to today
  List<LatLng> _visitedLocationsForSelectedDate = []; // Store locations for the selected date

  @override
  void initState() {
    super.initState();
    location = Location();
    _getLocation();
    _requestPermissions();
  }

  // Request location permission
  Future<void> _requestPermissions() async {
    PermissionStatus permission = await location.hasPermission();
    if (permission == PermissionStatus.denied) {
      permission = await location.requestPermission();
      if (permission != PermissionStatus.granted) {
        return;
      }
    }

    bool serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }
  }

  // Get live location
  void _getLocation() {
    location.onLocationChanged.listen((LocationData currentLocationData) {
      setState(() {
        _currentLocation = LatLng(currentLocationData.latitude ?? 0.0,
            currentLocationData.longitude ?? 0.0);
      });
    });
  }

  // Show Flutter's built-in date picker
  void _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    ) ?? _selectedDate;

    setState(() {
      _selectedDate = picked;
      _fetchVisitedLocationsForSelectedDate();
    });
  }

  // Fetch visited locations for the selected date (this is just a mockup for now)
  void _fetchVisitedLocationsForSelectedDate() {
    // In a real app, you would query your database or filter your data
    // based on the selected date to get the correct visited locations.

    // Mock data for the selected date (For example, you could have a map of dates to locations)
    setState(() {
      _visitedLocationsForSelectedDate = [
        LatLng(28.7041, 77.1025), // Example coordinates for today
        LatLng(28.5355, 77.3910),
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Member ${widget.memberId} Location'),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: () => _selectDate(context), // Show date picker when the icon is clicked
          ),
        ],
      ),
      body: Column(
        children: [
          _currentLocation == null
              ? const Center(child: CircularProgressIndicator())
              : Expanded(
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: _currentLocation!,
                zoom: 14.0,
              ),
              onMapCreated: (GoogleMapController controller) {
                mapController = controller;
              },
              markers: {
                Marker(
                  markerId: const MarkerId('current_location'),
                  position: _currentLocation!,
                  infoWindow: const InfoWindow(title: 'Current Location'),
                ),
                // Show markers for the visited locations on the selected date
                ..._visitedLocationsForSelectedDate.map((location) {
                  return Marker(
                    markerId: MarkerId(location.toString()),
                    position: location,
                    infoWindow: const InfoWindow(title: 'Visited Location'),
                  );
                }).toSet(),
              },
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Selected Date: ${DateFormat.yMMMd().format(_selectedDate)}\n'
                  'Total Locations: ${_visitedLocationsForSelectedDate.length}',
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
