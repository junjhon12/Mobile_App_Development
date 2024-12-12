import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class CustomizableBackgroundsScreen extends StatefulWidget {
  const CustomizableBackgroundsScreen({super.key});

  @override
  _CustomizableBackgroundsScreenState createState() => _CustomizableBackgroundsScreenState();
}

class _CustomizableBackgroundsScreenState extends State<CustomizableBackgroundsScreen> {
  File? _imageFile;

  final ImagePicker _picker = ImagePicker();

  // Function to pick an image from the gallery
  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  // Predefined backgrounds (example with color options)
  final List<Color> _backgrounds = [
    Colors.blue,
    Colors.green,
    Colors.orange,
    Colors.purple,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Customizable Backgrounds')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _imageFile == null
                ? Container(
                    width: 300,
                    height: 300,
                    color: Colors.grey[200],
                    child: const Center(child: Text('No Image Selected')),
                  )
                : Image.file(_imageFile!),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _pickImage,
              child: const Text('Pick Image from Gallery'),
            ),
            const SizedBox(height: 20),
            const Text('OR Choose a Background Color:'),
            const SizedBox(height: 10),
            Wrap(
              spacing: 10,
              children: _backgrounds.map((color) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _imageFile = null;  // Clear the image if background color is selected
                    });
                  },
                  child: Container(
                    width: 50,
                    height: 50,
                    color: color,
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
