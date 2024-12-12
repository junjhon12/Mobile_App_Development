import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class InteractiveMapsScreen extends StatefulWidget {
  const InteractiveMapsScreen({super.key});

  @override
  _InteractiveMapsScreenState createState() => _InteractiveMapsScreenState();
}

class _InteractiveMapsScreenState extends State<InteractiveMapsScreen> {
  GoogleMapController? mapController;

  // Initial camera position (centered at some default location)
  final CameraPosition _initialPosition = const CameraPosition(
    target: LatLng(37.7749, -122.4194), // Example: San Francisco
    zoom: 10,
  );

  // Markers list to handle multiple markers dynamically
  final Set<Marker> _markers = {
    Marker(
      markerId: const MarkerId('1'),
      position: const LatLng(37.7749, -122.4194), // Example location
      infoWindow: const InfoWindow(
        title: 'San Francisco',
        snippet: 'Weather data here',
      ),
    ),
  };

  // Function to handle map creation
  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  void dispose() {
    mapController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Interactive Maps')),
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: _initialPosition,
        mapType: MapType.normal, // Change to satellite or hybrid if needed
        myLocationEnabled: true, // Enable user location
        myLocationButtonEnabled: true, // Enable location button
        zoomControlsEnabled: true, // Enable zoom controls
        compassEnabled: true, // Enable compass
        tiltGesturesEnabled: true, // Enable tilt gestures
        scrollGesturesEnabled: true, // Enable scroll gestures
        markers: _markers, // Add the markers set
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Example of adding another marker dynamically
          setState(() {
            _markers.add(
              Marker(
                markerId: MarkerId('2'),
                position: const LatLng(37.7849, -122.4094), // Example new location
                infoWindow: const InfoWindow(
                  title: 'New Location',
                  snippet: 'Another marker example',
                ),
              ),
            );
          });
        },
        child: const Icon(Icons.add_location_alt),
      ),
    );
  }
}
