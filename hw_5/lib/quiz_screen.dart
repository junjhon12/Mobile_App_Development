import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:hw_5/summary_screen.dart';

class QuizScreen extends StatefulWidget {
  final int numberOfQuestions;
  final String category;
  final String difficulty;
  final String type;

  const QuizScreen({
    required this.numberOfQuestions,
    required this.category,
    required this.difficulty,
    required this.type,
    super.key,
  });

  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  List _questions = [];
  int _currentIndex = 0;
  int _score = 0;
  bool _isLoading = true;
  int _timer = 15;
  late Timer _countdownTimer;
  String _feedback = '';

  @override
  void initState() {
    super.initState();
    _fetchQuestions();
  }

  Future<void> _fetchQuestions() async {
    final url =
        'https://opentdb.com/api.php?amount=${widget.numberOfQuestions}&category=${widget.category}&difficulty=${widget.difficulty}&type=${widget.type}';
    final response = await http.get(Uri.parse(url));
    final data = jsonDecode(response.body);
    setState(() {
      _questions = data['results'];
      _isLoading = false;
      _startTimer();
    });
  }

  void _startTimer() {
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timer == 0) {
        _handleAnswer(null);
      } else {
        setState(() {
          _timer--;
        });
      }
    });
  }

  void _handleAnswer(String? selectedAnswer) {
    _countdownTimer.cancel();
    setState(() {
      final correctAnswer = _questions[_currentIndex]['correct_answer'];
      if (selectedAnswer == correctAnswer) {
        _score++;
        _feedback = 'Correct!';
      } else {
        _feedback = 'Incorrect! Correct answer: $correctAnswer';
      }
      if (_currentIndex < _questions.length - 1) {
        _currentIndex++;
        _timer = 15;
        _startTimer();
      } else {
        _showSummary();
      }
    });
  }

  void _showSummary() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => SummaryScreen(
          score: _score,
          totalQuestions: _questions.length,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _countdownTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz (${_currentIndex + 1}/${_questions.length})'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Time: $_timer seconds',
              style: const TextStyle(fontSize: 18, color: Colors.red),
            ),
            const SizedBox(height: 16),
            Text(
              _questions[_currentIndex]['question'],
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 16),
            ...(_questions[_currentIndex]['incorrect_answers'] as List)
                .map((answer) => ElevatedButton(
                      onPressed: () => _handleAnswer(answer),
                      child: Text(answer),
                    )),
            const SizedBox(height: 16),
            Text(
              _feedback,
              style: const TextStyle(fontSize: 18, color: Colors.green),
            ),
          ],
        ),
      ),
    );
  }
}
