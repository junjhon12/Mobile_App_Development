import 'package:flutter/material.dart';

class SavingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Savings'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Top Section for Total Savings Balance
          Container(
            color: Colors.redAccent,
            width: double.infinity,
            padding: EdgeInsets.all(16.0),
            child: Center(
              child: Text(
                '\$2000.00',
                style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          
          SizedBox(height: 16),

          // Savings List (Similar to the Transaction List)
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ListView(
                children: [
                  _buildSavingsItem('Sesame Str.', 50.00, true),
                  _buildSavingsItem('Yellow Not Bird', 50.00, false),
                  _buildSavingsItem('Red Sketch Elmo', 20.00, true),
                  _buildSavingsItem('Not suspicious', 165.00, true),
                  _buildSavingsItem('Money Laundry', 50.00, true),
                  _buildSavingsItem('Legal Cash', 50.00, false),
                ],
              ),
            ),
          ),
        ],
      ),
      
      // Bottom Navigation Bar
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.black54,
        backgroundColor: Colors.redAccent,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.attach_money),
            label: 'Transactions',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.savings),
            label: 'Savings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.show_chart),
            label: 'Investments',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
        ],
      ),
    );
  }

  // Function to Build Savings Item Row
  Widget _buildSavingsItem(String title, double amount, bool isPositive) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      padding: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              title,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ),
          Text(
            '\$$amount',
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(width: 10),
          IconButton(
            onPressed: () {
              // Add your action for "+" or "-" button here
            },
            icon: Icon(isPositive ? Icons.add_circle : Icons.remove_circle),
            color: isPositive ? Colors.green : Colors.red,
          ),
        ],
      ),
    );
  }
}
