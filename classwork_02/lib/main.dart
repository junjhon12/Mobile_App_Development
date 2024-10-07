import 'package:flutter/material.dart';
import 'home_screen.dart';

void main() {
  runApp(const RecipeBookApp());
}

class RecipeBookApp extends StatelessWidget {
  const RecipeBookApp({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> recipes = [
      {
        'name': 'Spaghetti Bolognese',
        'ingredients':
            'Pasta,Tomato Ground, Beef, Onion, Garlic, Olive Oil, Salt, Pepper, Parmesan, Cheese',
        'instructions': 'Boil a large pot of salted water and cook the pasta according to package instructions,'
            'In a separate pan heat olive oil over medium heat Add diced onion and minced garlic cooking until softened,'
            'Add ground beef to the pan cooking until browned Drain excess fat,'
            'Stir in chopped tomatoes salt and pepper Simmer for 20 minutes,'
            'Serve the sauce over the pasta and sprinkle with grated Parmesan cheese'
      },
      {
        'name': 'Chicken Curry',
        'ingredients':
            'Chicken,Curry Powder, Onion, Garlic, Ginger, Coconut Milk, Bell Peppers, Salt, Rice',
        'instructions':
            'In a large pan heat oil over medium heat and sauté chopped onion garlic and ginger until fragrant,'
                'Add diced chicken and curry powder cooking until the chicken is browned,'
                'Stir in chopped bell peppers and cook for a few minutes,'
                'Pour in coconut milk and simmer for 15-20 minutes or until chicken is cooked through,'
                'Serve hot with steamed rice'
      },
      {
        'name': 'Vegetable Stir Fry',
        'ingredients':
            'Broccoli, Bell Peppers, Carrots, Soy Sauce, Garlic, Ginger, Olive Oil, Sesame Seeds',
        'instructions':
            'Heat olive oil in a large pan over medium heat Add minced garlic and ginger sauté for a minute,'
                'Add chopped broccoli bell peppers and carrots stir-fry for 5-7 minutes,'
                'Pour in soy sauce and cook for another 2 minutes,'
                'Sprinkle with sesame seeds before serving'
      },
      {
        'name': 'Beef Tacos',
        'ingredients':
            'Ground Beef, Taco Shells, Lettuce, Tomato, Cheese, Sour Cream, Taco Seasoning',
        'instructions': 'Cook ground beef in a pan over medium heat until browned,'
            'Drain excess fat and add taco seasoning mix well,'
            'Fill taco shells with beef and top with shredded lettuce diced tomato cheese and sour cream'
      },
      {
        'name': 'Caprese Salad',
        'ingredients':
            'Tomato, Mozzarella, Basil, Olive Oil, Balsamic Vinegar, Salt, Pepper',
        'instructions':
            'Slice tomatoes and mozzarella cheese layer them with fresh basil leaves,'
                'Drizzle with olive oil and balsamic vinegar sprinkle with salt and pepper before serving'
      },
      {
        'name': 'Chocolate Chip Cookies',
        'ingredients':
            'Butter, Sugar, Brown Sugar, Eggs, Vanilla Extract, Flour, Baking Soda, Chocolate Chips',
        'instructions':
            'Preheat oven to 350°F Mix butter sugar and brown sugar until creamy,'
                'Add eggs and vanilla extract mix well,'
                'Combine flour and baking soda gradually add to the mixture,'
                'Stir in chocolate chips drop spoonfuls onto baking sheet and bake for 10-12 minutes'
      },
    ];

    return MaterialApp(
      title: 'Recipe Book',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(recipes: recipes, favoriteRecipes: const []),
    );
  }
}
