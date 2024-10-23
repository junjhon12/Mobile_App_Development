import 'package:flutter/material.dart';

class ExpensesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Expenses'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Top Section for Total Expenses
          Container(
            color: Colors.orangeAccent,
            width: double.infinity,
            padding: EdgeInsets.all(16.0),
            child: Center(
              child: Text(
                '\$800.00', // Example expenses value
                style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ),
          SizedBox(height: 16),

          // List of expense entries
          Expanded(
            child: ListView(
              children: [
                _buildExpenseEntry('Groceries', 200.00),
                _buildExpenseEntry('Rent', 500.00),
                _buildExpenseEntry('Transportation', 100.00),
                // Add more expense entries here
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Function to build individual expense entries
  Widget _buildExpenseEntry(String category, double amount) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: ListTile(
          title: Text(category, style: TextStyle(fontSize: 18)),
          trailing: Text(
            '\$$amount',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}
