import 'package:flutter/material.dart';
import 'income_page.dart';
import 'saving_page.dart';
import 'investment_page.dart';
import 'expenses_page.dart'; // Ensure all necessary pages are imported

class ExpensesPage extends StatelessWidget {
  const ExpensesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Expenses'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Top Section for Total Expenses
          Container(
            color: Colors.orangeAccent,
            width: double.infinity,
            padding: const EdgeInsets.all(16.0),
            child: const Center(
              child: Text(
                '\$800.00', // Example expenses value
                style: TextStyle(
                  fontSize: 36, 
                  fontWeight: FontWeight.bold, 
                  color: Colors.white
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),

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

      // Bottom Navigation Bar moved here, inside the Scaffold
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 2, // Highlight the Expenses tab
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
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: ListTile(
          title: Text(category, style: const TextStyle(fontSize: 18)),
          trailing: Text(
            '\$$amount',
            style: const TextStyle(
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
