import 'package:flutter/material.dart';
import 'income_page.dart';
import 'expenses_page.dart';
import 'investment_page.dart';

class SavingsPage extends StatefulWidget {
  const SavingsPage({super.key});

  @override
  _SavingsPageState createState() => _SavingsPageState();
}

class _SavingsPageState extends State<SavingsPage> {
  double currentSavings = 2000.00; // Current savings
  double savingsGoal = 5000.00; // User's savings goal
  final TextEditingController _amountController = TextEditingController();

  // Function to add savings
  void _addSavings() {
    setState(() {
      double amount = double.tryParse(_amountController.text) ?? 0;
      currentSavings += amount;
    });
    _amountController.clear(); // Clear the input field after updating
  }

  // Function to remove savings
  void _removeSavings() {
    setState(() {
      double amount = double.tryParse(_amountController.text) ?? 0;
      currentSavings -= amount;
    });
    _amountController.clear(); // Clear the input field after updating
  }

  // Function to calculate the progress percentage toward the savings goal
  double _calculateProgress() {
    return currentSavings / savingsGoal;
  }

  @override
  Widget build(BuildContext context) {
    double progress = _calculateProgress(); // Calculate progress as a fraction (0 to 1)

    return Scaffold(
      appBar: AppBar(
        title: const Text('Savings'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Top Section: Display current savings and savings goal
          Container(
            color: Colors.amberAccent,
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Current savings
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Current Savings',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                    Text(
                      '\$$currentSavings',
                      style: const TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                // Savings goal
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text(
                      'Savings Goal',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                    Text(
                      '\$$savingsGoal',
                      style: const TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Progress bar showing how far the user is from the goal
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                // Show progress bar
                LinearProgressIndicator(
                  value: progress.clamp(0.0, 1.0), // Clamp between 0 and 1
                  minHeight: 10,
                  backgroundColor: Colors.grey[300],
                  color: progress >= 1.0 ? Colors.green : Colors.blueAccent,
                ),
                const SizedBox(height: 8),
                // Show how far the user is from their goal
                Text(
                  progress >= 1.0
                      ? 'Goal Reached! 🎉'
                      : '${(progress * 100).toStringAsFixed(1)}% of your goal reached',
                  style: TextStyle(
                    fontSize: 16,
                    color: progress >= 1.0 ? Colors.green : Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Form Section for Adding or Removing Savings
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
                // Buttons for adding or removing savings
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    // Button for adding savings
                    GestureDetector(
                      onTap: _addSavings,
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
                    // Button for removing savings
                    GestureDetector(
                      onTap: _removeSavings,
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

          // Savings List (Similar to the Transaction List)
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ListView(
                children: [
                  _buildSavingsItem('Emergency Fund', 500.00, true),
                  _buildSavingsItem('Vacation Fund', 300.00, false),
                  // Add more savings items here
                ],
              ),
            ),
          ),
        ],
      ),

      // Bottom Navigation Bar for page navigation
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
        color: Colors.grey[200], // Same background color as the buttons
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
