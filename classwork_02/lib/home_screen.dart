import 'package:flutter/material.dart';
import 'details_screen.dart';
import 'favorites_screen.dart';

/// HomeScreen displays a list of recipes and allows users to toggle their favorites.
/// It uses a StatefulWidget to maintain the state of favorite recipes.
class HomeScreen extends StatefulWidget {
  final List<Map<String, dynamic>> recipes; // List of all recipes
  final List<Map<String, dynamic>> favoriteRecipes; // List of favorite recipes

  const HomeScreen({super.key, required this.recipes, required this.favoriteRecipes});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recipe List'), // Title displayed on the app bar
        actions: [
          IconButton(
            icon: const Icon(
              Icons.favorite,
              color: Colors.red
            ), // Icon button to navigate to favorites screen
            onPressed: () {
              // Navigate to the FavoritesScreen when the icon is pressed
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FavoritesScreen(
                    favoriteRecipes: widget
                        .favoriteRecipes, // Pass favorite recipes to the FavoritesScreen
                    toggleFavorite:
                        toggleFavorite, // Pass toggle function to the FavoritesScreen
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: widget.recipes.length, // Count of recipes to display
        itemBuilder: (context, index) {
          final recipe = widget.recipes[index]; // Get the current recipe
          final isFavorite = widget.favoriteRecipes
              .contains(recipe); // Check if the recipe is a favorite

          return Center(
            child: GestureDetector(
              // Widget that detects taps
              onTap: () {
                // Navigate to the DetailsScreen when the recipe is tapped
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailsScreen(
                      recipe:
                          recipe, // Pass the selected recipe to the DetailsScreen
                      favoriteRecipes:
                          widget.favoriteRecipes, // Pass favorite recipes
                      toggleFavorite: toggleFavorite, // Pass toggle function
                    ),
                  ),
                );
              },
              child: Container(
                width: MediaQuery.of(context).size.width *
                    0.8, // Set container width to 80% of screen width
                height: 80.0, // Fixed height for each recipe item
                margin: const EdgeInsets.symmetric(
                    horizontal: 12.5, vertical: 8.0), // Add margin for spacing

                // Row widget to display the recipe title and like button
                child: Row(
                  mainAxisAlignment: MainAxisAlignment
                      .spaceBetween, // Space between title and like button
                  children: [
                    Expanded(
                      // Allows title to expand and fill available space
                      child: Container(
                        color:
                            Colors.blue[100], // Background color for the title
                        padding: const EdgeInsets.all(
                            16.0), // Padding inside the title container

                        // Centered text widget to display the recipe name
                        child: Center(
                          child: Text(
                            recipe['name'], // Display the recipe name
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold), // Text styling
                          ),
                        ),
                      ),
                    ),

                    // Container for the like button
                    Container(
                      color: Colors
                          .grey[200], // Background color for the like button
                      height: double.infinity, // Fill the container's height

                      // IconButton for toggling favorites
                      child: IconButton(
                        icon: isFavorite
                            ? const Icon(Icons.favorite,
                                color: Colors
                                    .red) // Red heart if recipe is a favorite
                            : const Icon(Icons
                                .favorite_border), // Border heart if recipe is not a favorite
                        onPressed: () {
                          toggleFavorite(
                              recipe); // Toggle the favorite status when the icon is pressed
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  /// Method to toggle a recipe's favorite status
  void toggleFavorite(Map<String, dynamic> recipe) {
    setState(() {
      if (widget.favoriteRecipes.contains(recipe)) {
        widget.favoriteRecipes
            .remove(recipe); // Remove from favorites if already present
      } else {
        widget.favoriteRecipes.add(recipe); // Add to favorites if not present
      }
    });
  }
}
