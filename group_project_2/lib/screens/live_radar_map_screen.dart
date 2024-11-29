import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LiveRadarMapScreen extends StatefulWidget {
  const LiveRadarMapScreen({super.key});

  @override
  _LiveRadarMapScreenState createState() => _LiveRadarMapScreenState();
}

class _LiveRadarMapScreenState extends State<LiveRadarMapScreen> {
  late GoogleMapController _mapController;

  // Initial position for the map (example: New York City)
  static const LatLng _initialPosition = LatLng(40.7128, -74.0060);

  // List of radar stations and their marker positions
  final Set<Marker> _markers = {
    Marker(
      markerId: const MarkerId('radar1'),
      position: const LatLng(40.73061, -73.935242),
      infoWindow: const InfoWindow(title: 'Radar Station 1', snippet: 'Coverage Area: North-East'),
    ),
    Marker(
      markerId: const MarkerId('radar2'),
      position: const LatLng(40.650002, -73.949997),
      infoWindow: const InfoWindow(title: 'Radar Station 2', snippet: 'Coverage Area: Brooklyn'),
    ),
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Live Radar Map'),
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: _initialPosition,
          zoom: 10.0, // Zoom level
        ),
        markers: _markers, // Displaying the markers on the map
        onMapCreated: (GoogleMapController controller) {
          _mapController = controller;
        },
        myLocationEnabled: true, // Enable the user's current location
        myLocationButtonEnabled: true, // Show the "My Location" button
        zoomControlsEnabled: true, // Allow zoom controls
      ),
    );
  }
}
