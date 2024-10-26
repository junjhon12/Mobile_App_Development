import 'package:flutter/material.dart';
import 'income_page.dart';
import 'saving_page.dart';
import 'investment_page.dart';

class ExpensesPage extends StatefulWidget {
  const ExpensesPage({super.key});

  @override
  _ExpensesPageState createState() => _ExpensesPageState();
}

class _ExpensesPageState extends State<ExpensesPage> {
  double totalExpenses = 0.00; // Starting total expenses
  final TextEditingController _amountController = TextEditingController();

  // Function to add an expense
  void _addExpense() {
    setState(() {
      double amount = double.tryParse(_amountController.text) ?? 0;
      totalExpenses += amount;
    });
    _amountController.clear(); // Clear the input field after updating
  }

  // Function to remove an expense
  void _removeExpense() {
    setState(() {
      double amount = double.tryParse(_amountController.text) ?? 0;
      totalExpenses -= amount;
    });
    _amountController.clear(); // Clear the input field after updating
  }

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
            child: Center(
              child: Text(
                '\$$totalExpenses', // Dynamically display the updated total expenses
                style: const TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Form Section for Adding or Removing Expenses
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                // Input field for amount
                TextField(
                  controller: _amountController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Enter Amount',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                // Buttons for adding or removing expenses
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    // Button for adding expense
                    GestureDetector(
                      onTap: _addExpense,
                      child: Container(
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: const Icon(
                          Icons.add_circle,
                          color: Colors.green,
                          size: 36,
                        ),
                      ),
                    ),
                    // Button for removing expense
                    GestureDetector(
                      onTap: _removeExpense,
                      child: Container(
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: const Icon(
                          Icons.remove_circle,
                          color: Colors.red,
                          size: 36,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
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

      // Bottom Navigation Bar
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
            selectedItemColor: const Color.fromARGB(255, 0, 0, 0),
            unselectedItemColor: const Color.fromARGB(137, 0, 0, 0),
            backgroundColor: Colors.white,
            items: [
              BottomNavigationBarItem(
                icon: _buildNavIcon(Icons.attach_money, Colors.redAccent, false),
                label: 'Income',
              ),
              BottomNavigationBarItem(
                icon: _buildNavIcon(Icons.savings, Colors.amberAccent, false),
                label: 'Savings',
              ),
              BottomNavigationBarItem(
                icon: _buildNavIcon(Icons.account_balance_wallet, Colors.orangeAccent, false),
                label: 'Expenses',
              ),
              BottomNavigationBarItem(
                icon: _buildNavIcon(Icons.show_chart, Colors.greenAccent, false),
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

  Widget _buildNavIcon(IconData icon, Color color, bool isSelected) {
  return Icon(
    icon,
    color: isSelected ? color : color.withOpacity(0.5), // Full color when selected, semi-transparent when not
  );
}
}
