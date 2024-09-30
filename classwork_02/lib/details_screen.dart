import 'package:flutter/material.dart';

/// DetailsScreen displays detailed information about a selected recipe.
/// It shows ingredients and instructions, and allows users to toggle the favorite status.
class DetailsScreen extends StatefulWidget {
  final Map<String, dynamic> recipe; // The selected recipe to display
  final List<Map<String, dynamic>> favoriteRecipes; // List of favorite recipes
  final Function(Map<String, dynamic>)
      toggleFavorite; // Function to toggle favorite status

  const DetailsScreen(
      {super.key,
      required this.recipe,
      required this.favoriteRecipes,
      required this.toggleFavorite});

  @override
  _DetailsScreenState createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  bool isFavorite = false; // Local state to track if the recipe is a favorite

  @override
  void initState() {
    super.initState();
    // Check if the current recipe is in the list of favorite recipes
    isFavorite = widget.favoriteRecipes.contains(widget.recipe);
  }

  @override
  Widget build(BuildContext context) {
    // Split ingredients and instructions by comma
    List<String> ingredients = widget.recipe['ingredients'].split(',');
    List<String> instructions = widget.recipe['instructions'].split(',');

    return Scaffold(
      appBar: AppBar(
        title:
            Text(widget.recipe['name']), // Display recipe name in the app bar
        actions: [
          // Icon button to toggle favorite status
          IconButton(
            icon: Icon(isFavorite
                ? Icons.favorite
                : Icons
                    .favorite_border), // Show filled or outline heart based on favorite status
            color: isFavorite
                ? Colors.red
                : null, // Change icon color if it's a favorite
            onPressed: () {
              widget.toggleFavorite(widget.recipe); // Call the toggle function
              setState(() {
                isFavorite = !isFavorite; // Update local favorite status
              });
            },
          ),
        ],
      ),
      body: Container(
        color: Colors.blue[50], // Light blue background color for the body
        child: Padding(
          padding: const EdgeInsets.all(16.0), // Padding around the content
          child: SingleChildScrollView(
            // Allows scrolling if content overflows
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start, // Align items to the start
              children: [
                // Ingredients section header
                const Text(
                  'Ingredients:',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24), // Bold and larger text for the header
                ),
                const SizedBox(height: 8), // Space below the header

                // Container for the ingredients list
                Container(
                  decoration: BoxDecoration(
                    color: Colors
                        .white, // Background color for the ingredients list
                    borderRadius: BorderRadius.circular(
                        8.0), // Rounded corners for the container
                    boxShadow: [
                      // Shadow for elevation effect
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset: const Offset(0, 3), // Shadow position
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(16.0), // Padding inside the container
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment
                        .start, // Align ingredients to the start
                    children: ingredients.map((ingredient) {
                      return Padding(
                        padding: const EdgeInsets.only(
                            bottom: 8.0), // Space between each ingredient
                        child: Row(
                          children: [
                            const Icon(Icons.circle,
                                size: 8), // Bullet point for each ingredient
                            const SizedBox(
                                width:
                                    8), // Space between bullet point and text
                            Expanded(
                              child: Text(
                                ingredient
                                    .trim(), // Display the ingredient name
                                style: const TextStyle(
                                    fontSize:
                                        18), // Font size for ingredient text
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(
                    height: 16), // Space between ingredients and instructions

                // Instructions section header
                const Text(
                  'Instructions:',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24), // Bold and larger text for the header
                ),
                const SizedBox(height: 8), // Space below the header

                // Container for the instructions list
                Container(
                  decoration: BoxDecoration(
                    color: Colors
                        .white, // Background color for the instructions list
                    borderRadius: BorderRadius.circular(
                        8.0), // Rounded corners for the container
                    boxShadow: [
                      // Shadow for elevation effect
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset: const Offset(0, 3), // Shadow position
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(16.0), // Padding inside the container
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment
                        .start, // Align instructions to the start
                    children: instructions.map((instruction) {
                      return Padding(
                        padding: const EdgeInsets.only(
                            bottom: 8.0), // Space between each instruction
                        child: Row(
                          children: [
                            const Icon(Icons.circle,
                                size: 8), // Bullet point for each instruction
                            const SizedBox(
                                width:
                                    8), // Space between bullet point and text
                            Expanded(
                              child: Text(
                                instruction
                                    .trim(), // Display the instruction text
                                style: const TextStyle(
                                    fontSize:
                                        18), // Font size for instruction text
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
