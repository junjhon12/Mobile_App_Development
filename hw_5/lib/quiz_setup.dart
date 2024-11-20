import 'dart:convert';
import 'package:flutter/material.dart';
import 'quiz_screen.dart';
import 'package:http/http.dart' as http;

class QuizSetupScreen extends StatefulWidget {
  const QuizSetupScreen({super.key});

  @override
  _QuizSetupScreenState createState() => _QuizSetupScreenState();
}

class _QuizSetupScreenState extends State<QuizSetupScreen> {
  int _numberOfQuestions = 5;
  String? _selectedCategory;
  String _difficulty = 'easy';
  String _type = 'multiple';
  List<Map<String, String>> _categories = [];

  @override
  void initState() {
    super.initState();
    _fetchCategories();
  }

  Future<void> _fetchCategories() async {
    final response = await http.get(Uri.parse('https://opentdb.com/api_category.php'));
    final data = jsonDecode(response.body) as Map<String, dynamic>;
    setState(() {
      _categories = (data['trivia_categories'] as List<dynamic>)
          .map((category) => {
                'id': category['id'].toString(),
                'name': category['name'].toString(),
              })
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz Setup'),
      ),
      body: _categories.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Number of Questions:',
                    style: TextStyle(fontSize: 16),
                  ),
                  Slider(
                    value: _numberOfQuestions.toDouble(),
                    min: 5,
                    max: 15,
                    divisions: 2,
                    label: '$_numberOfQuestions',
                    onChanged: (value) {
                      setState(() {
                        _numberOfQuestions = value.toInt();
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Select Category:',
                    style: TextStyle(fontSize: 16),
                  ),
                  DropdownButton<String>(
                    isExpanded: true,
                    value: _selectedCategory,
                    items: _categories.map((category) {
                      return DropdownMenuItem(
                        value: category['id'],
                        child: Text(category['name']!),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedCategory = value;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Select Difficulty:',
                    style: TextStyle(fontSize: 16),
                  ),
                  DropdownButton<String>(
                    isExpanded: true,
                    value: _difficulty,
                    items: const [
                      DropdownMenuItem(value: 'easy', child: Text('Easy')),
                      DropdownMenuItem(value: 'medium', child: Text('Medium')),
                      DropdownMenuItem(value: 'hard', child: Text('Hard')),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _difficulty = value!;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Select Type:',
                    style: TextStyle(fontSize: 16),
                  ),
                  DropdownButton<String>(
                    isExpanded: true,
                    value: _type,
                    items: const [
                      DropdownMenuItem(value: 'multiple', child: Text('Multiple Choice')),
                      DropdownMenuItem(value: 'boolean', child: Text('True/False')),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _type = value!;
                      });
                    },
                  ),
                  const SizedBox(height: 32),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        if (_selectedCategory == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Please select a category!')),
                          );
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => QuizScreen(
                                numberOfQuestions: _numberOfQuestions,
                                category: _selectedCategory!,
                                difficulty: _difficulty,
                                type: _type,
                              ),
                            ),
                          );
                        }
                      },
                      child: const Text('Start Quiz'),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
