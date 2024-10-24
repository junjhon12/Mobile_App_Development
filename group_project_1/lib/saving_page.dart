import 'package:flutter/material.dart';

class SavingsPage extends StatefulWidget {
  const SavingsPage({super.key});

  @override
  _SavingsPageState createState() => _SavingsPageState();
}

class _SavingsPageState extends State<SavingsPage> {
  double totalBalance = 2000.00; // Starting balance
  final TextEditingController _amountController = TextEditingController();

  // Function to add income
  void _addIncome() {
    setState(() {
      double amount = double.tryParse(_amountController.text) ?? 0;
      totalBalance += amount;
    });
    _amountController.clear(); // Clear the input field after updating
  }

  // Function to add expense
  void _addExpense() {
    setState(() {
      double amount = double.tryParse(_amountController.text) ?? 0;
      totalBalance -= amount;
    });
    _amountController.clear(); // Clear the input field after updating
  }

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
            child: Center(
              child: Text(
                '\$$totalBalance', // Dynamically display the updated balance
                style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Form Section for Adding Income or Expense
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
                // Buttons for adding income or expense
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    // Button for adding income
                    GestureDetector(
                      onTap: _addIncome,
                      child: Container(
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: Colors.grey[200], // Matching background color
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: const Icon(
                          Icons.add_circle,
                          color: Colors.green,
                          size: 36,
                        ),
                      ),
                    ),
                    // Button for adding expense
                    GestureDetector(
                      onTap: _addExpense,
                      child: Container(
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: Colors.grey[200], // Matching background color
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
          // Navigation logic (similar to the previous implementation)
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
