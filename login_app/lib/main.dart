import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Hides the top-right debug banner
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.lightBlue,
          title: const Text('Login App'),
          leading: const Icon(Icons.menu),
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.settings),
            ),
          ],
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // Center everything vertically
            children: [
              
              // Container for username and password fields
              Container(
                height: MediaQuery.of(context).size.height * 0.26,
                width: MediaQuery.of(context).size.width * 0.9,
                padding: const EdgeInsets.all(16.0), // Add padding inside the container
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(10), // Rounded corners
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    
                    // Username field
                    const Text(
                      'Username',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    const SizedBox(height: 8), // Space after the label
                    TextField(
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        hintText: 'Enter your username',
                      ),
                    ),
                    const SizedBox(height: 16), // Space between username and password

                    // Password field
                    const Text(
                      'Password',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    const SizedBox(height: 8), // Space after the label
                    TextField(
                      obscureText: true, // Hides password input
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        hintText: 'Enter your password',
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 20), // Space between container and buttons

              // Login Button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.4, // Full-width button
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                      ),
                      child: const Text('Login'),
                    ),
                  ),
                  const SizedBox(height: 10), // Space between Login and Sign Up button
                  
                  // Sign Up Button
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.4, // Full-width button
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green, // Optional: Change color for Sign Up
                      ),
                      child: const Text('Sign Up'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
