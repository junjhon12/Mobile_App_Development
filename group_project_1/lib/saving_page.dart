import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert'; // Import for JSON encoding and decoding
import 'income_page.dart';
import 'expenses_page.dart';
import 'investment_page.dart';

class SavingsPage extends StatefulWidget {
  const SavingsPage({super.key});

  @override
  _SavingsPageState createState() => _SavingsPageState();
}

class _SavingsPageState extends State<SavingsPage> {
  // Initial current savings and goal
  double currentSavings = 2000.0;
  double savingsGoal = 5000.0;
  final TextEditingController _amountController =
      TextEditingController(); // Controller for amount input
  final TextEditingController _goalController =
      TextEditingController(); // Controller for goal input
  final List<Map<String, dynamic>> savingsEntries =
      []; // List to store savings entries

  @override
  void initState() {
    super.initState();
    _loadData(); // Load savings data when the page initializes
  }

  // Load savings data from SharedPreferences
  Future<void> _loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      // Retrieve saved current savings and goal, with defaults if not found
      currentSavings = prefs.getDouble('currentSavings') ?? 2000.0;
      savingsGoal = prefs.getDouble('savingsGoal') ?? 5000.0;
      // Load entries as JSON string
      savingsEntries.addAll((prefs.getStringList('savingsEntries') ?? [])
          .map((entry) => Map<String, dynamic>.from(jsonDecode(entry)))
          .toList());
    });
  }

  // Save savings data to SharedPreferences
  Future<void> _saveData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(
        'currentSavings', currentSavings); // Save current savings
    await prefs.setDouble('savingsGoal', savingsGoal); // Save savings goal
    // Save entries as JSON string
    List<String> entries =
        savingsEntries.map((entry) => jsonEncode(entry)).toList();
    await prefs.setStringList('savingsEntries', entries); // Save entries list
  }

  // Function to add savings
  void _addSavings() {
    setState(() {
      double amount =
          double.tryParse(_amountController.text) ?? 0; // Parse input amount
      currentSavings += amount; // Update current savings
      // Add entry to the savings list
      savingsEntries.add({
        'title': 'Savings Added',
        'amount': amount,
        'isPositive': true,
        'date': DateTime.now().toString(),
      });
    });
    _saveData(); // Save updated data
    _amountController.clear(); // Clear input field
  }

  // Function to remove savings with confirmation dialog
  void _removeSavings() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Removal'),
        content: const Text('Are you sure you want to remove this amount?'),
        actions: [
          TextButton(
            onPressed: () =>
                Navigator.of(context).pop(), // Close dialog on cancel
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                double amount = double.tryParse(_amountController.text) ??
                    0; // Parse input amount
                currentSavings -= amount; // Update current savings
                // Add entry to the savings list for removal
                savingsEntries.add({
                  'title': 'Savings Removed',
                  'amount': amount,
                  'isPositive': false,
                  'date': DateTime.now().toString(),
                });
              });
              _saveData(); // Save updated data
              _amountController.clear(); // Clear input field
              Navigator.of(context).pop(); // Close dialog
            },
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }

  // Function to clear all savings entries
  void _clearSavings() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Clear'),
        content:
            const Text('Are you sure you want to clear all savings entries?'),
        actions: [
          TextButton(
            onPressed: () =>
                Navigator.of(context).pop(), // Close dialog on cancel
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                currentSavings = 0.0; // Reset current savings
                savingsEntries.clear(); // Clear all savings entries
              });
              _saveData(); // Save updated data
              Navigator.of(context).pop(); // Close dialog
            },
            child: const Text('Clear All'),
          ),
        ],
      ),
    );
  }

  // Calculate progress towards the savings goal
  double _calculateProgress() => currentSavings / savingsGoal;

  @override
  Widget build(BuildContext context) {
    double progress = _calculateProgress(); // Get progress towards goal

    return Scaffold(
      appBar: AppBar(
        title: const Text('Savings'), // App bar title
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit), // Edit button for savings goal
            onPressed: () {
              _goalController.text =
                  savingsGoal.toString(); // Set controller text to current goal
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Edit Savings Goal'), // Dialog title
                  content: TextField(
                    controller: _goalController,
                    keyboardType: TextInputType.number, // Number input for goal
                    decoration: const InputDecoration(
                      labelText: 'Enter new savings goal',
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () =>
                          Navigator.of(context).pop(), // Close dialog on cancel
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          savingsGoal = double.tryParse(_goalController.text) ??
                              savingsGoal; // Update savings goal
                        });
                        _saveData(); // Save updated goal
                        Navigator.of(context).pop(); // Close dialog
                      },
                      child: const Text('Save'),
                    ),
                  ],
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.clear), // Clear button for savings entries
            onPressed: _clearSavings,
          ),
        ],
      ),
      body: Column(
        children: [
          // Display current savings and savings goal
          Container(
            color: Colors.amberAccent, // Background color for the savings info
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Current Savings',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w500)),
                    Text(
                      '\$$currentSavings', // Display current savings
                      style: const TextStyle(
                          fontSize: 36, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text('Savings Goal',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w500)),
                    Text(
                      '\$$savingsGoal', // Display savings goal
                      style: const TextStyle(
                          fontSize: 36, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 16), // Spacing

          // Progress bar to show savings progress
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                LinearProgressIndicator(
                  value: progress.clamp(
                      0.0, 1.0), // Clamp progress value between 0 and 1
                  minHeight: 10,
                  backgroundColor:
                      Colors.grey[300], // Background color of progress bar
                  color: progress >= 1.0
                      ? Colors.green
                      : Colors.blueAccent, // Change color based on goal status
                ),
                const SizedBox(height: 8),
                Text(
                  progress >= 1.0
                      ? 'Goal Reached! 🎉'
                      : '${(progress * 100).toStringAsFixed(1)}% of your goal reached', // Display progress message
                  style: TextStyle(
                      fontSize: 16,
                      color: progress >= 1.0 ? Colors.green : Colors.black,
                      fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16), // Spacing

          // Input Form for Adding/Removing Savings
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                TextField(
                  controller: _amountController, // Controller for amount input
                  keyboardType: TextInputType.number, // Number input for amount
                  decoration: const InputDecoration(
                      labelText: 'Enter Amount', border: OutlineInputBorder()),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    GestureDetector(
                      onTap: _addSavings, // Add savings on tap
                      child: Container(
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(8.0)),
                        child: const Icon(Icons.add_circle,
                            color: Colors.green, size: 36),
                      ),
                    ),
                    GestureDetector(
                      onTap: _removeSavings, // Remove savings on tap
                      child: Container(
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(8.0)),
                        child: const Icon(Icons.remove_circle,
                            color: Colors.red, size: 36),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16), // Spacing

          // Savings Entries List
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ListView.builder(
                itemCount:
                    savingsEntries.length, // Number of entries to display
                itemBuilder: (context, index) {
                  final entry = savingsEntries[index]; // Get current entry
                  return _buildSavingsItem(entry['title'], entry['amount'],
                      entry['isPositive'], entry['date']); // Build entry item
                },
              ),
            ),
          ),
        ],
      ),

      // Bottom Navigation Bar
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1,
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const IncomePage()));
          } else if (index == 1) {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const SavingsPage()));
          } else if (index == 2) {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const ExpensesPage()));
          } else if (index == 3) {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => const InvestmentPage()));
          }
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color.fromARGB(255, 0, 0, 0),
        unselectedItemColor: const Color.fromARGB(137, 0, 0, 0),
        backgroundColor: Colors.white,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.attach_money, color: Colors.redAccent),
              label: 'Income'),
          BottomNavigationBarItem(
              icon: Icon(Icons.savings, color: Colors.amberAccent),
              label: 'Savings'),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_balance_wallet,
                  color: Colors.orangeAccent),
              label: 'Expenses'),
          BottomNavigationBarItem(
              icon: Icon(Icons.show_chart, color: Colors.greenAccent),
              label: 'Investments'),
        ],
      ),
    );
  }

  // Build individual savings entry item
  Widget _buildSavingsItem(
      String title, double amount, bool isPositive, String date) {
    return ListTile(
      title: Text(title), // Entry title
      subtitle: Text(date), // Entry date
      trailing: Text(
        '${isPositive ? '+' : '-'} \$${amount.toStringAsFixed(2)}', // Display amount with sign
        style: TextStyle(color: isPositive ? Colors.green : Colors.red),
      ),
    );
  }
}
