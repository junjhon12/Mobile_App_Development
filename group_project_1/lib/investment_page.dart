import 'package:flutter/material.dart';

class InvestmentPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Investments'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Top Section for Total Investments
          Container(
            color: Colors.greenAccent,
            width: double.infinity,
            padding: EdgeInsets.all(16.0),
            child: Center(
              child: Text(
                '\$5000.00', // Example investments value
                style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ),
          SizedBox(height: 16),

          // List of investment entries
          Expanded(
            child: ListView(
              children: [
                _buildInvestmentEntry('Stocks', 3000.00),
                _buildInvestmentEntry('Bonds', 1000.00),
                _buildInvestmentEntry('Cryptocurrency', 1000.00),
                // Add more investment entries here
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Function to build individual investment entries
  Widget _buildInvestmentEntry(String type, double amount) {
    return ListTile(
      title: Text(type),
      trailing: Text('\$$amount', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
    );
  }
}
