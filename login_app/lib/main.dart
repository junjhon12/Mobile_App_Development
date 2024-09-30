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

        // Main body content
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // Center everything vertically
            children: [
              
              // Space above the container
              const SizedBox(height: 20),
              
              // Container for username and password fields
              Container(
                height: MediaQuery.of(context).size.height * 0.26,
                width: MediaQuery.of(context).size.width * 0.9,
                padding: const EdgeInsets.all(16.0), // Add padding inside the container
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(10), // Rounded corners
                ),
                
                // Column inside the container
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    
                    // Username field
                    const Text(
                      'Username',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    
                    // Space between the username label and text field
                    const SizedBox(height: 8),
                    
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
                    
                    // Space between the username and password fields
                    const SizedBox(height: 16),

                    // Password field
                    const Text(
                      'Password',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    
                    // Space between the password label and text field
                    const SizedBox(height: 8),
                    
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

              // Space between the container and the buttons
              const SizedBox(height: 20),

              // Row for login and sign-up buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  
                  // Space between the buttons and container above
                  const SizedBox(height: 10),
                  
                  // Login Button
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
                  
                  // Space between the Login and Sign Up buttons
                  const SizedBox(width: 10),
                  
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
