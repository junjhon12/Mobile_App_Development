import 'package:flutter/material.dart';
import 'details_screen.dart';

/// FavoritesScreen displays a list of favorite recipes.
/// Tapping on a recipe navigates to the DetailsScreen to show more information.
class FavoritesScreen extends StatelessWidget {
  final List<Map<String, dynamic>> favoriteRecipes; // List of favorite recipes
  final Function(Map<String, dynamic>)
      toggleFavorite; // Function to toggle favorite status

  const FavoritesScreen(
      {super.key, required this.favoriteRecipes, required this.toggleFavorite});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorite Recipes'), // Title of the app bar
      ),
      body: Container(
        color: Colors.blue[50], // Light blue background color for the body
        child: ListView.builder(
          itemCount:
              favoriteRecipes.length, // Number of favorite recipes to display
          itemBuilder: (context, index) {
            return Center(
              child: GestureDetector(
                onTap: () {
                  // Navigates to the details screen with the selected recipe
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailsScreen(
                        recipe:
                            favoriteRecipes[index], // Pass the selected recipe
                        favoriteRecipes:
                            favoriteRecipes, // Pass the list of favorite recipes
                        toggleFavorite:
                            toggleFavorite, // Pass the toggle function
                      ),
                    ),
                  );
                },
                child: Container(
                  width: MediaQuery.of(context).size.width *
                      0.8, // Set width to 80% of screen width
                  height: 80.0, // Fixed height for uniformity in the list
                  margin: const EdgeInsets.symmetric(
                      horizontal: 12.5,
                      vertical: 8.0), // Margin for spacing between items
                  decoration: BoxDecoration(
                    color:
                        Colors.white, // Background color for the favorite item
                    borderRadius: BorderRadius.circular(
                        8.0), // Rounded corners for the container
                    boxShadow: [
                      // Shadow for elevation effect
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset: const Offset(0, 3), // Position of shadow
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(
                        16.0), // Padding inside the container
                    child: Center(
                      child: Text(
                        favoriteRecipes[index]
                            ['name'], // Display the name of the favorite recipe
                        textAlign: TextAlign.center, // Center align the text
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight:
                                FontWeight.bold), // Text style for recipe name
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
