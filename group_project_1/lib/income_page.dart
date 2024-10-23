import 'package:flutter/material.dart';

class IncomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Income'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Top Section for Total Income
          Container(
            color: Colors.redAccent,
            width: double.infinity,
            padding: EdgeInsets.all(16.0),
            child: Center(
              child: Text(
                '\$2000.00', // Example income value
                style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ),
          SizedBox(height: 16),

          // List of income entries
          Expanded(
            child: ListView(
              children: [
                _buildIncomeEntry('Salary', 1500.00),
                _buildIncomeEntry('Freelance', 500.00),
                // Add more income entries here
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Function to build individual income entries
  Widget _buildIncomeEntry(String source, double amount) {
    return ListTile(
      title: Text(source),
      trailing: Text('\$$amount', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
    );
  }
}
