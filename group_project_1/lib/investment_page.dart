import 'package:flutter/material.dart';
import 'income_page.dart';
import 'saving_page.dart';
import 'expenses_page.dart';
import 'investment_page.dart';

class InvestmentPage extends StatelessWidget {
  const InvestmentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Investments'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Top Section for Total Investments
          Container(
            color: Colors.greenAccent,
            width: double.infinity,
            padding: const EdgeInsets.all(16.0),
            child: const Center(
              child: Text(
                '\$0.00', // Example investments value
                style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ),
          const SizedBox(height: 16),

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

      // Bottom Navigation Bar
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 3, // Highlight the Investments tab
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

  // Function to build individual investment entries
  Widget _buildInvestmentEntry(String type, double amount) {
    return ListTile(
      title: Text(type),
      trailing: Text(
        '\$$amount',
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }
}
