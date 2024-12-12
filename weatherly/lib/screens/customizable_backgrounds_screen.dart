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
  Color? _backgroundColor;

  final ImagePicker _picker = ImagePicker();

  // Function to pick an image from the gallery
  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
        _backgroundColor = null; // Clear the color if an image is selected
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
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          color: _backgroundColor ?? Colors.grey[200],
          image: _imageFile != null
              ? DecorationImage(
            image: FileImage(_imageFile!),
            fit: BoxFit.cover,
          )
              : null,
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
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
                          _backgroundColor = color;
                          _imageFile = null; // Clear the image if a background color is selected
                        });
                      },
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: color,
                          border: Border.all(color: Colors.black, width: 2),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
