import 'package:flutter/material.dart';
import 'income_page.dart';
import 'saving_page.dart';
import 'expenses_page.dart';
import 'investment_page.dart';

class SavingsPage extends StatelessWidget {
  const SavingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Savings'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Top Section for Total Savings Balance
          Container(
            color: Colors.amberAccent,
            width: double.infinity,
            padding: const EdgeInsets.all(16.0),
            child: const Center(
              child: Text(
                '\$2000.00',
                style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          
          const SizedBox(height: 16),

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
        currentIndex: 1, // Highlight the Savings tab
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const IncomePage()),
            );
          } else if (index == 1) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const SavingsPage()),
            );
          } else if (index == 2) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const ExpensesPage()),
            );
          } else if (index == 3) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const InvestmentPage()),
            );
          }
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.black54,
        backgroundColor: Colors.white,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.attach_money),
            label: 'Income',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.savings),
            label: 'Savings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet),
            label: 'Expenses',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.show_chart),
            label: 'Investments',
          ),
        ],
      ),
    );
  }

  // Function to Build Savings Item Row
  Widget _buildSavingsItem(String title, double amount, bool isPositive) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      padding: const EdgeInsets.all(8.0),
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
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ),
          Text(
            '\$$amount',
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(width: 10),
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
