import 'package:flutter/material.dart';

void main() {
  runApp(CalculatorApp());
}

// Main App Widget
class CalculatorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculator App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: CalculatorHomePage(),
    );
  }
}

// Calculator Home Page
class CalculatorHomePage extends StatefulWidget {
  @override
  _CalculatorHomePageState createState() => _CalculatorHomePageState();
}

class _CalculatorHomePageState extends State<CalculatorHomePage> {
  String displayText = "0";  // Display area text
  String currentOperation = "";  // Track the ongoing calculation
  double firstOperand = 0;   // First number in the operation
  double secondOperand = 0;  // Second number in the operation
  String operator = "";      // Stores the operator (+, -, *, /)
  String result = "0";       // Stores the result of the operation

  // Function to handle number input
  void numberPressed(String number) {
    setState(() {
      if (displayText == "0") {
        displayText = number;
      } else {
        displayText += number;
      }
      // Update current operation display
      currentOperation += number;
    });
  }

  // Function to handle operator input
  void operatorPressed(String op) {
    setState(() {
      firstOperand = double.parse(displayText);
      operator = op;
      displayText = "0"; // Reset display for second operand input

      // Update current operation display
      currentOperation += " $op ";
    });
  }

  // Function to handle calculations
  void calculate() {
    setState(() {
      secondOperand = double.parse(displayText);
      if (operator == "+") {
        result = (firstOperand + secondOperand).toString();
      } else if (operator == "-") {
        result = (firstOperand - secondOperand).toString();
      } else if (operator == "*") {
        result = (firstOperand * secondOperand).toString();
      } else if (operator == "/") {
        result = secondOperand != 0 ? (firstOperand / secondOperand).toString() : "Error";
      }
      displayText = result;

      // Update current operation display with result
      currentOperation += " = $result";
    });
  }

  // Function to handle clearing the calculator
  void clear() {
    setState(() {
      displayText = "0";
      firstOperand = 0;
      secondOperand = 0;
      operator = "";
      result = "0";
      currentOperation = ""; // Clear the current operation
    });
  }

  // Build number button
  Widget buildButton(String text, Color color, VoidCallback onPressed) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextButton(
          style: TextButton.styleFrom(
            backgroundColor: color,
            padding: EdgeInsets.all(16.0),
          ),
          onPressed: onPressed,
          child: Text(
            text,
            style: TextStyle(fontSize: 24, color: Colors.white),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Calculator')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          // Display Area for Current Operation (Shows ongoing calculation)
          Container(
            padding: EdgeInsets.all(16),
            alignment: Alignment.centerRight,
            child: Text(
              currentOperation,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.normal),
            ),
          ),
          // Display Area for Result
          Container(
            padding: EdgeInsets.all(16),
            alignment: Alignment.centerRight,
            child: Text(
              displayText,
              style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
            ),
          ),
          // Number Buttons
          Row(
            children: <Widget>[
              buildButton("7", Colors.blue, () => numberPressed("7")),
              buildButton("8", Colors.blue, () => numberPressed("8")),
              buildButton("9", Colors.blue, () => numberPressed("9")),
              buildButton("/", Colors.orange, () => operatorPressed("/")),
            ],
          ),
          Row(
            children: <Widget>[
              buildButton("4", Colors.blue, () => numberPressed("4")),
              buildButton("5", Colors.blue, () => numberPressed("5")),
              buildButton("6", Colors.blue, () => numberPressed("6")),
              buildButton("*", Colors.orange, () => operatorPressed("*")),
            ],
          ),
          Row(
            children: <Widget>[
              buildButton("1", Colors.blue, () => numberPressed("1")),
              buildButton("2", Colors.blue, () => numberPressed("2")),
              buildButton("3", Colors.blue, () => numberPressed("3")),
              buildButton("-", Colors.orange, () => operatorPressed("-")),
            ],
          ),
          Row(
            children: <Widget>[
              buildButton("0", Colors.blue, () => numberPressed("0")),
              buildButton("C", Colors.red, () => clear()),   // Clear button
              buildButton("=", Colors.green, () => calculate()), // Equals button
              buildButton("+", Colors.orange, () => operatorPressed("+")),
            ],
          ),
        ],
      ),
    );
  }
}
