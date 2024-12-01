import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class CustomizableBackgroundsScreen extends StatefulWidget {
  const CustomizableBackgroundsScreen({super.key});

  @override
  _CustomizableBackgroundsScreenState createState() =>
      _CustomizableBackgroundsScreenState();
}

class _CustomizableBackgroundsScreenState
    extends State<CustomizableBackgroundsScreen> {
  // Variable to hold the selected background image file
  File? _backgroundImage;

  // List of predefined background themes
  final List<String> _backgroundThemes = [
    'Sunny',
    'Rainy',
    'Cloudy',
    'Night',
    'Snowy',
  ];

  // Selected background theme
  String _selectedBackground = 'Sunny';

  // Function to pick an image from the gallery
  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _backgroundImage = File(pickedFile.path);
      });
    }
  }

  // Function to get the appropriate background color based on selected theme
  Color _getBackgroundColor(String theme) {
    switch (theme) {
      case 'Sunny':
        return Colors.yellowAccent;
      case 'Rainy':
        return Colors.blueGrey;
      case 'Cloudy':
        return Colors.grey;
      case 'Night':
        return Colors.indigo;
      case 'Snowy':
        return Colors.lightBlueAccent;
      default:
        return Colors.white;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Customizable Backgrounds')),
      body: GestureDetector(
        onTap: () {
          // Dismiss the keyboard if tapped outside of text fields
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Container(
          decoration: BoxDecoration(
            image: _backgroundImage != null
                ? DecorationImage(
                    image: FileImage(_backgroundImage!),
                    fit: BoxFit.cover,
                  )
                : null,
            color: _backgroundImage == null
                ? _getBackgroundColor(_selectedBackground)
                : null,
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title for the background themes section
                const Text(
                  'Select Background Theme:',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),

                // List of background themes for selection
                Wrap(
                  spacing: 16.0,
                  children: _backgroundThemes.map((theme) {
                    return ChoiceChip(
                      label: Text(theme),
                      selected: _selectedBackground == theme,
                      onSelected: (bool selected) {
                        setState(() {
                          _selectedBackground = selected ? theme : _selectedBackground;
                        });
                      },
                    );
                  }).toList(),
                ),

                const SizedBox(height: 20),

                // Button to upload a custom image
                ElevatedButton(
                  onPressed: _pickImage,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                  child: const Text('Upload Custom Background'),
                ),

                const SizedBox(height: 20),

                // Display the current background selection
                if (_backgroundImage == null)
                  Text(
                    'Current Theme: $_selectedBackground',
                    style: const TextStyle(fontSize: 18),
                  ),
                if (_backgroundImage != null)
                  const Text(
                    'Custom Background Uploaded!',
                    style: TextStyle(fontSize: 18, color: Colors.green),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
