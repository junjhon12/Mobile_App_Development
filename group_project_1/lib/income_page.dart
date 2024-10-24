import 'package:flutter/material.dart';
import 'saving_page.dart';
import 'expenses_page.dart';
import 'income_page.dart';
import 'investment_page.dart';

class IncomePage extends StatelessWidget {
  const IncomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Income'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Top Section for Total Income
          Container(
            color: Colors.redAccent,
            width: double.infinity,
            padding: const EdgeInsets.all(16.0),
            child: const Center(
              child: Text(
                '\$0.00', // Example income value
                style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ),
          const SizedBox(height: 16),

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

      // Bottom Navigation Bar
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0, // Highlight the Income tab
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

  // Function to build individual income entries
  Widget _buildIncomeEntry(String source, double amount) {
    return ListTile(
      title: Text(source),
      trailing: Text(
        '\$$amount',
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }
}
