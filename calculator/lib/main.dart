import 'package:flutter/material.dart';

void main() {
  runApp(CalculatorApp());
}

// Main Calculator App Widget
class CalculatorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculator App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: CalculatorHomePage(), // Home screen of the calculator
    );
  }
}

// Home Page Widget with Calculator functionality
class CalculatorHomePage extends StatefulWidget {
  @override
  _CalculatorHomePageState createState() => _CalculatorHomePageState();
}

class _CalculatorHomePageState extends State<CalculatorHomePage> {
  String displayText = "0";      // Display area for the current input
  String currentOperation = "";  // Displays the ongoing calculation
  double firstOperand = 0;       // First number in the operation
  double secondOperand = 0;      // Second number in the operation
  String operator = "";          // Stores the selected operator (+, -, *, /)
  String result = "0";           // Stores the result of the calculation

  // Function to handle number button press
  void numberPressed(String number) {
    setState(() {
      if (displayText == "0") {
        displayText = number; // Replace "0" with the number
      } else {
        displayText += number; // Append the number to the current input
      }
      currentOperation += number; // Update the current operation string
    });
  }

  // Function to handle operator button press
  void operatorPressed(String op) {
    setState(() {
      firstOperand = double.parse(displayText); // Save the first operand
      operator = op; // Store the operator
      displayText = "0"; // Reset display for the next number
      currentOperation += " $op "; // Show the selected operator
    });
  }

  // Function to perform the calculation when "=" is pressed
  void calculate() {
    setState(() {
      secondOperand = double.parse(displayText); // Get the second operand

      // Perform the operation based on the operator
      if (operator == "+") {
        result = (firstOperand + secondOperand).toString();
      } else if (operator == "-") {
        result = (firstOperand - secondOperand).toString();
      } else if (operator == "*") {
        result = (firstOperand * secondOperand).toString();
      } else if (operator == "/") {
        result = secondOperand != 0 ? (firstOperand / secondOperand).toString() : "Error";
      }

      displayText = result; // Display the result
      currentOperation += " = $result"; // Show the result in the current operation string
    });
  }

  // Function to clear the calculator's display and reset variables
  void clear() {
    setState(() {
      displayText = "0"; // Reset display to "0"
      firstOperand = 0;
      secondOperand = 0;
      operator = "";
      result = "0";
      currentOperation = ""; // Clear the current operation display
    });
  }

  // Helper function to build calculator buttons
  Widget buildButton(String text, Color color, VoidCallback onPressed) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextButton(
          style: TextButton.styleFrom(
            backgroundColor: color,
            padding: EdgeInsets.all(16.0),
          ),
          onPressed: onPressed, // Call the corresponding function on press
          child: Text(
            text,
            style: TextStyle(fontSize: 24, color: Colors.white), // Text styling
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Calculator')), // App title
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          // Displays the current operation (e.g., "5 + 3")
          Container(
            padding: EdgeInsets.all(16),
            alignment: Alignment.centerRight,
            child: Text(
              currentOperation,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.normal),
            ),
          ),
          // Displays the current input or result
          Container(
            padding: EdgeInsets.all(16),
            alignment: Alignment.centerRight,
            child: Text(
              displayText,
              style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
            ),
          ),
          // Row of number and operator buttons
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
              buildButton("C", Colors.red, () => clear()), // Clear button
              buildButton("=", Colors.green, () => calculate()), // Equals button
              buildButton("+", Colors.orange, () => operatorPressed("+")),
            ],
          ),
        ],
      ),
    );
  }
}
