import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class InteractiveMapsScreen extends StatefulWidget {
  const InteractiveMapsScreen({super.key});

  @override
  _InteractiveMapsScreenState createState() => _InteractiveMapsScreenState();
}

class _InteractiveMapsScreenState extends State<InteractiveMapsScreen> {
  late GoogleMapController mapController;

  // Initial camera position (centered at some default location)
  final CameraPosition _initialPosition = const CameraPosition(
    target: LatLng(37.7749, -122.4194),  // Example: San Francisco
    zoom: 10,
  );

  // Function to handle map creation
  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Interactive Maps')),
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: _initialPosition,
        mapType: MapType.normal,  // You can change this to satellite or hybrid
        myLocationEnabled: true,  // Enable user location
        myLocationButtonEnabled: true,  // Enable the location button
        zoomControlsEnabled: true,  // Enable zoom controls
        compassEnabled: true,  // Enable compass
        tiltGesturesEnabled: true,  // Enable tilt gestures
        scrollGesturesEnabled: true,  // Enable scroll gestures
        markers: <Marker>{
            Marker(
              markerId: MarkerId('1'),
              position: LatLng(37.7749, -122.4194),  // Example location
              infoWindow: InfoWindow(
                title: 'San Francisco',
                snippet: 'Weather data here',
              ),
            ),
          },
      ),
    );
  }
}
