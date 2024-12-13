import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class InteractiveMapsScreen extends StatefulWidget {
  const InteractiveMapsScreen({super.key});

  @override
  _InteractiveMapsScreenState createState() => _InteractiveMapsScreenState();
}

class _InteractiveMapsScreenState extends State<InteractiveMapsScreen> {
  GoogleMapController? _mapController;
  final CameraPosition _initialPosition = const CameraPosition(
    target: LatLng(37.7749, -122.4194), // Example: San Francisco
    zoom: 10,
  );
  final Set<Marker> _markers = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _getUserLocation();
  }

  Future<void> _getUserLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      final userLocation = LatLng(position.latitude, position.longitude);

      setState(() {
        _markers.add(
          Marker(
            markerId: const MarkerId('currentLocation'),
            position: userLocation,
            infoWindow: const InfoWindow(title: 'You are here'),
          ),
        );
        _isLoading = false;

        _mapController?.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(target: userLocation, zoom: 15),
          ),
        );
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to fetch location. Ensure GPS is enabled.')),
      );
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Interactive Maps')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: _initialPosition,
        mapType: MapType.normal,
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        zoomControlsEnabled: true,
        markers: _markers,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _markers.add(
              Marker(
                markerId: MarkerId(DateTime.now().toString()),
                position: LatLng(
                  _initialPosition.target.latitude + 0.01,
                  _initialPosition.target.longitude + 0.01,
                ),
                infoWindow: const InfoWindow(title: 'New Marker'),
              ),
            );
          });
        },
        child: const Icon(Icons.add_location_alt),
      ),
    );
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }
}
