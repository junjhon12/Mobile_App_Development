import 'package:flutter/material.dart';

class DetailedForecastScreen extends StatelessWidget {
  const DetailedForecastScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detailed Forecast')),
      body: Center(child: Text('Detailed Forecast Content Goes Here')),
    );
  }
}
