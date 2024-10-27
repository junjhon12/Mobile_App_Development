import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'income_page.dart';
import 'saving_page.dart';
import 'investment_page.dart';

// Main widget for the Expenses Page
class ExpensesPage extends StatefulWidget {
  const ExpensesPage({super.key});

  @override
  _ExpensesPageState createState() => _ExpensesPageState();
}

class _ExpensesPageState extends State<ExpensesPage> {
  double totalExpenses = 0.0; // Current total of expenses
  final TextEditingController _amountController =
      TextEditingController(); // Controller for amount input
  final TextEditingController _categoryController =
      TextEditingController(); // Controller for category input
  final TextEditingController _goalController =
      TextEditingController(); // Controller for goal input
  final List<Map<String, dynamic>> expenseEntries =
      []; // List to store expense entries
  double? expenseGoal; // Variable to store the expense goal

  @override
  void initState() {
    super.initState();
    _loadTotalExpenses(); // Load total expenses from shared preferences
    _loadExpenseGoal(); // Load expense goal from shared preferences
  }

  // Load total expenses from shared preferences
  Future<void> _loadTotalExpenses() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      totalExpenses = prefs.getDouble('totalExpenses') ??
          0.0; // Set total expenses, default to 0.0
    });
  }

  // Save total expenses to shared preferences
  Future<void> _saveTotalExpenses() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setDouble('totalExpenses', totalExpenses); // Save total expenses
  }

  // Load expense goal from shared preferences
  Future<void> _loadExpenseGoal() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      expenseGoal = prefs.getDouble('expenseGoal') ??
          0.0; // Set expense goal, default to 0.0
    });
  }

  // Save expense goal to shared preferences
  Future<void> _saveExpenseGoal() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setDouble('expenseGoal', expenseGoal!); // Save expense goal
  }

  // Add an expense and save it to shared preferences
  void _addExpense() {
    double? amount =
        double.tryParse(_amountController.text); // Parse the amount from input
    if (amount != null && _categoryController.text.isNotEmpty) {
      // Validate input
      setState(() {
        String category = _categoryController.text; // Get category from input
        totalExpenses += amount; // Update total expenses
        expenseEntries.add({
          'title': category,
          'amount': amount,
          'isPositive': false
        }); // Add to entries
      });
      _saveTotalExpenses(); // Save updated total expenses
      _amountController.clear(); // Clear input fields
      _categoryController.clear();
    }
  }

  // Remove an expense and save it to shared preferences
  void _removeExpense() {
    double? amount =
        double.tryParse(_amountController.text); // Parse the amount from input
    if (amount != null && _categoryController.text.isNotEmpty) {
      // Validate input
      setState(() {
        String category = _categoryController.text; // Get category from input
        totalExpenses -= amount; // Update total expenses
        expenseEntries.add({
          'title': category,
          'amount': amount,
          'isPositive': true
        }); // Add to entries
      });
      _saveTotalExpenses(); // Save updated total expenses
      _amountController.clear(); // Clear input fields
      _categoryController.clear();
    }
  }

  // Set a monthly or weekly expense goal
  void _setGoal() {
    setState(() {
      expenseGoal =
          double.tryParse(_goalController.text); // Parse goal from input
      _saveExpenseGoal(); // Save the goal
      _goalController.clear(); // Clear goal input field
    });
  }

  @override
  Widget build(BuildContext context) {
    // Calculate progress towards the expense goal
    double progress = expenseGoal != null && expenseGoal! > 0
        ? (totalExpenses / expenseGoal!)
            .clamp(0.0, 1.0) // Clamp value between 0 and 1
        : 0.0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Expenses'), // Title of the AppBar
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Top Section: Display Total Expenses and Goal Progress
          Container(
            color: Colors.orangeAccent,
            width: double.infinity,
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  '\$$totalExpenses', // Display total expenses
                  style: const TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                if (expenseGoal != null &&
                    expenseGoal! > 0) // Display progress only if goal is set
                  Column(
                    children: [
                      LinearProgressIndicator(
                        value: progress, // Set progress value
                        backgroundColor: Colors.grey[300],
                        color: Colors.redAccent,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${(progress * 100).toStringAsFixed(1)}% of goal reached', // Display percentage of goal reached
                        style: TextStyle(
                          fontSize: 16,
                          color: progress >= 1.0 ? Colors.red : Colors.white,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Input Form for Adding/Removing Expenses and Setting Goal
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                TextField(
                  controller: _amountController, // Amount input
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Enter Amount',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _categoryController, // Category input
                  decoration: const InputDecoration(
                    labelText: 'Enter Category (e.g., Food, Transport)',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _goalController, // Goal input
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Set Monthly/Weekly Goal',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    GestureDetector(
                      onTap: _addExpense, // Add expense on tap
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
                    GestureDetector(
                      onTap: _removeExpense, // Remove expense on tap
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
                    GestureDetector(
                      onTap: _setGoal, // Set goal on tap
                      child: Container(
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: const Icon(
                          Icons.track_changes,
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

          // Expense Entries List
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ListView.builder(
                itemCount: expenseEntries.length, // Number of expense entries
                itemBuilder: (context, index) {
                  final entry = expenseEntries[index]; // Get the expense entry
                  return _buildExpenseEntry(
                    entry['title'],
                    entry['amount'],
                    entry['isPositive'],
                  );
                },
              ),
            ),
          ),
        ],
      ),

      // Bottom Navigation Bar
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 2, // Current page index for Expenses
        onTap: (index) {
          // Navigate to the appropriate page based on index
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
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black54,
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
            icon: _buildNavIcon(
                Icons.account_balance_wallet, Colors.orangeAccent, true),
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

  // Widget to build a single expense entry
  Widget _buildExpenseEntry(String title, double amount, bool isPositive) {
    return ListTile(
      title: Text(title), // Display category
      subtitle: Text('\$${amount.toStringAsFixed(2)}'), // Display amount
      trailing: Icon(
        isPositive
            ? Icons.add_circle
            : Icons.remove_circle, // Show appropriate icon
        color: isPositive ? Colors.green : Colors.red,
      ),
    );
  }

  // Widget to build bottom navbar
  Widget _buildNavIcon(IconData icon, Color color, bool isSelected) {
    return Icon(
      icon,
      color: isSelected ? color : color.withOpacity(0.5),
    );
  }
}
