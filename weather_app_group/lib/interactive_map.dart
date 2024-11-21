import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class InteractiveMap extends StatelessWidget {
  const InteractiveMap({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Interactive Map'),
      ),
      body: FlutterMap(
        options: MapOptions(
          center: LatLng(51.5074, -0.1278), // London coordinates
          zoom: 10, // Zoom level
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
            subdomains: ['a', 'b', 'c'],
          ),
          MarkerLayer(
            markers: [
              Marker(
                point: LatLng(51.5074, -0.1278), // Location for marker
                builder: (ctx) => const Icon(Icons.location_on, color: Colors.red),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
