import 'package:flutter/material.dart';

class CommunityInsightsScreen extends StatelessWidget {
  const CommunityInsightsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Community Insights')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title for the Community Reports section
            const Text(
              'Community Weather Reports',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),

            // Displaying a list of user-submitted weather reports
            Expanded(
              child: ListView.builder(
                itemCount: 10, // Replace with the actual length of reports
                itemBuilder: (context, index) {
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    elevation: 3,
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.blue.shade100,
                        child: Text(
                          '#${index + 1}',
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                      title: Text('Report from User #${index + 1}'),
                      subtitle: const Text('Weather Condition: Sunny, Temp: 22°C'),
                      trailing: IconButton(
                        icon: const Icon(Icons.location_on, color: Colors.redAccent),
                        onPressed: () {
                          // Show detailed report or map location if needed
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text('Report Details'),
                                content: Text('Detailed report for day ${index + 1}.'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text('Close'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 16),

            // Button to upload photos
            ElevatedButton.icon(
              onPressed: () {
                // You can handle photo upload functionality here
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text('Upload Weather Photo'),
                      content: const Text('Select a photo to upload.'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            // Implement photo upload logic
                            Navigator.pop(context);
                          },
                          child: const Text('Select Photo'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('Cancel'),
                        ),
                      ],
                    );
                  },
                );
              },
              icon: const Icon(Icons.upload_file),
              label: const Text('Upload Weather Photo'),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white, backgroundColor: Colors.blue,
              ),
            ),

            const SizedBox(height: 20),

            // Section to view community-shared photos
            const Text(
              'Community Shared Photos:',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),

            // Horizontal list of images
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(5, (index) {
                  // Sample images for demonstration
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.asset(
                        'assets/sample_photo${index + 1}.jpg', // Replace with dynamic image fetching logic
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
