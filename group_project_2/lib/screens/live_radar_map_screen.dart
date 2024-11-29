import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LiveRadarMapScreen extends StatefulWidget {
  const LiveRadarMapScreen({super.key});

  @override
  _LiveRadarMapScreenState createState() => _LiveRadarMapScreenState();
}

class _LiveRadarMapScreenState extends State<LiveRadarMapScreen> {
  late GoogleMapController _mapController;

  final LatLng _initialPosition = const LatLng(40.7128, -74.0060);

  final List<Marker> _markers = [
    const Marker(
      markerId: MarkerId('radar1'),
      position: LatLng(40.73061, -73.935242),
      infoWindow: InfoWindow(title: 'Radar Station 1', snippet: 'Coverage Area: North-East'),
    ),
    const Marker(
      markerId: MarkerId('radar2'),
      position: LatLng(40.650002, -73.949997),
      infoWindow: InfoWindow(title: 'Radar Station 2', snippet: 'Coverage Area: Brooklyn'),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Live Radar Map'),
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: _initialPosition,
          zoom: 10.0,
        ),
        markers: Set<Marker>.of(_markers),
        onMapCreated: (controller) {
          _mapController = controller;
        },
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        zoomControlsEnabled: true,
      ),
    );
  }
}
