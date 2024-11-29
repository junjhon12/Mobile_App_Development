import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class CommunityInsightsScreen extends StatefulWidget {
  const CommunityInsightsScreen({super.key});

  @override
  _CommunityInsightsScreenState createState() =>
      _CommunityInsightsScreenState();
}

class _CommunityInsightsScreenState extends State<CommunityInsightsScreen> {
  final TextEditingController _reportController = TextEditingController();
  final List<String> _reports = [];
  final List<File> _photos = [];

  Future<void> _pickPhoto() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _photos.add(File(pickedFile.path));
      });
    }
  }

  void _submitReport() {
    final report = _reportController.text.trim();
    if (report.isNotEmpty) {
      setState(() {
        _reports.add(report);
        _reportController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Community Insights'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            const Text(
              'Share your observations or upload a photo!',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _reportController,
              decoration: const InputDecoration(
                labelText: 'Your weather observation',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _submitReport,
                    child: const Text('Submit Report'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _pickPhoto,
                    child: const Text('Upload Photo'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: [
                  if (_reports.isNotEmpty)
                    const Text(
                      'Community Reports:',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ..._reports.map((report) => ListTile(
                        leading: const Icon(Icons.report),
                        title: Text(report),
                      )),
                  if (_photos.isNotEmpty)
                    const Text(
                      'Shared Photos:',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ..._photos.map((photo) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Image.file(photo, height: 200, fit: BoxFit.cover),
                      )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
