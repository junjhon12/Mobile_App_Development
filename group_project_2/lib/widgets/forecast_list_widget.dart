import 'package:flutter/material.dart';

class ForecastListWidget extends StatelessWidget {
  final List<dynamic> forecastInfo;

  const ForecastListWidget({super.key, required this.forecastInfo});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: forecastInfo.take(7).map(
        (forecast) {
          return ListTile(
            title: Text(
                '${forecast['dt_txt']}: ${forecast['main']['temp']}°C, ${forecast['weather'][0]['description']}'),
          );
        },
      ).toList(),
    );
  }
}
