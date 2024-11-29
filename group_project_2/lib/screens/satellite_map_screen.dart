import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class SatelliteMapScreen extends StatefulWidget {
  const SatelliteMapScreen({super.key});

  @override
  State<SatelliteMapScreen> createState() => _SatelliteMapScreenState();
}

class _SatelliteMapScreenState extends State<SatelliteMapScreen> {
  late GoogleMapController _mapController;

  final CameraPosition _initialPosition = const CameraPosition(
    target: LatLng(37.7749, -122.4194), // Default location: San Francisco
    zoom: 12,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Satellite Map'),
      ),
      body: GoogleMap(
        mapType: MapType.satellite, // Satellite view enabled
        initialCameraPosition: _initialPosition,
        onMapCreated: (GoogleMapController controller) {
          _mapController = controller;
        },
        markers: {
          Marker(
            markerId: const MarkerId('default'),
            position: const LatLng(37.7749, -122.4194),
            infoWindow: const InfoWindow(title: 'Default Location'),
          ),
        },
      ),
    );
  }
}
