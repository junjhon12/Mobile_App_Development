import 'package:flutter/material.dart';

void main() {
  // The main function starts the Flutter app
  runApp(const weatherApp());
}

// The main app widget is a stateless widget (does not change state)
class weatherApp extends StatelessWidget {
  const weatherApp({super.key});

  // The build method describes the UI and returns a widget tree
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Removes the default debug banner on the top-right corner
      debugShowCheckedModeBanner: false,

      // The main UI layout of the app
      home: Scaffold(
        // Top app bar with the title 'Weather App'
        appBar: AppBar(
          // Centers the title 'Weather App' in the app bar
          title: const Center(child: Text('Weather App')),
        ),

        // Body of the app
        body: Center(
          // Centers the content vertically and horizontally
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // A small space of 5 pixels between widgets
              const SizedBox(height: 5),

              // A container that holds the input field and buttons
              Container(
                // The container's height is 30% of the screen height
                height: MediaQuery.of(context).size.height * 0.3,

                // The container's width is 60% of the screen width
                width: MediaQuery.of(context).size.width * 0.6,

                // Adds padding (spacing inside the container) of 5 pixels
                padding: const EdgeInsets.all(5),

                // Applies rounded corners to the container
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),

                // A column inside the container to stack its content vertically
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Label for the city name input field
                    const Text(
                      'City name',
                      style: TextStyle(color: Colors.black, fontSize: 20),
                    ),
                    // Adds 5 pixels of vertical space after the label
                    const SizedBox(height: 5),

                    // Input field for users to type the city name
                    TextField(
                      decoration: InputDecoration(
                        // Background color for the text field
                        fillColor: Colors.white,
                        filled: true,

                        // Border styling with rounded corners
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),

                        // Hint text that appears inside the text field
                        hintText: 'Enter your city name',
                      ),
                    ),

                    // Adds 10 pixels of vertical space after the text field
                    const SizedBox(height: 5),

                    // Button to fetch the current weather when clicked
                    SizedBox(
                      // The button takes up 50% of the screen width
                      width: MediaQuery.of(context).size.width * 0.5,

                      child: ElevatedButton(
                        // Button action when pressed (currently empty)
                        onPressed: () {},

                        // Button styling, with a black background
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          // Ensure the text color is white for better visibility
                          foregroundColor: Colors.white,
                          textStyle: TextStyle(fontSize: 15),
                        ),

                        // Text displayed on the button with a white color
                        child: const Text(
                          'Fetch Weather',
                          style: TextStyle(color: Colors.white), // Set text color to white
                        ),
                      ),
                    ),

                    // Adds 10 pixels of vertical space after the current weather button
                    const SizedBox(height: 5),

                    // Button to fetch the 7-day weather forecast when clicked
                    SizedBox(
                      // The button takes up 50% of the screen width
                      width: MediaQuery.of(context).size.width * 0.5,

                      child: ElevatedButton(
                        // Button action for 7-day forecast (currently empty)
                        onPressed: () {},

                        // Button styling, with a green background
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          foregroundColor: Colors.white,
                          textStyle: TextStyle(fontSize: 15),
                        ),

                        // Text displayed on the 7-day forecast button
                        child: const Text(
                          '7-Day Forecast',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Adds 20 pixels of vertical space after the buttons
              const SizedBox(height: 20),

              // Placeholder for 7-day forecast section
              const Text(
                '7-Day Forecast:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 20),

              // 7-day forecast displayed as a horizontally scrollable row
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.generate(7, (index) {
                      return Container(
                        color: Colors.white,
                        margin: const EdgeInsets.symmetric(horizontal: 5.5),
                        child: Column(
                          children: [
                            const Icon(Icons.wb_sunny),
                            Text('Day ${index + 1}'),
                            const Text('Temp: --°C'),
                          ],
                        ),
                      );
                    }),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
