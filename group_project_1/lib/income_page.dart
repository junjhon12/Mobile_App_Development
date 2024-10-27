import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'expenses_page.dart';
import 'investment_page.dart';
import 'saving_page.dart';
import 'package:intl/intl.dart';
import 'dart:convert'; // Import this for JSON encoding/decoding

class IncomePage extends StatefulWidget {
  const IncomePage({super.key});

  @override
  _IncomePageState createState() => _IncomePageState();
}

class _IncomePageState extends State<IncomePage> {
  double totalIncome = 0.0; // Current total income
  final TextEditingController _amountController = TextEditingController(); // Controller for amount input
  final List<Map<String, dynamic>> incomeEntries = []; // List to store income entries

  @override
  void initState() {
    super.initState();
    _loadTotalIncome(); // Load total income from SharedPreferences when the page initializes
    _loadIncomeEntries(); // Load income entries from SharedPreferences
  }

  // Load total income from SharedPreferences
  Future<void> _loadTotalIncome() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      totalIncome = prefs.getDouble('totalIncome') ?? 0.0; // Default to 0.0 if no value is found
    });
  }

  // Load income entries from SharedPreferences
  Future<void> _loadIncomeEntries() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? entriesString = prefs.getString('incomeEntries'); // Get the saved string
    if (entriesString != null) {
      List<dynamic> entriesList = json.decode(entriesString); // Decode JSON
      for (var entry in entriesList) {
        incomeEntries.add(Map<String, dynamic>.from(entry)); // Add to the list
      }
      setState(() {}); // Update the state
    }
  }

  // Save the total income to SharedPreferences
  Future<void> _saveTotalIncome() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('totalIncome', totalIncome);
  }

  // Save the income entries to SharedPreferences
  Future<void> _saveIncomeEntries() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String entriesString = json.encode(incomeEntries); // Encode list to JSON
    await prefs.setString('incomeEntries', entriesString); // Save the JSON string
  }

  // Reset total income and clear income entries
  Future<void> _resetTotalIncome() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      totalIncome = 0.0; // Reset total income to 0.0
      incomeEntries.clear(); // Clear the list of income entries
    });
    await prefs.setDouble('totalIncome', totalIncome); // Save the reset value
    await prefs.remove('incomeEntries'); // Remove income entries from storage
  }

  // Add income to total and income entries
  void _addIncome() {
    double amount = double.tryParse(_amountController.text) ?? 0; // Parse input amount
    if (amount <= 0) {
      // Validate that the amount is positive
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid amount.')), // Show error message
      );
      return;
    }

    setState(() {
      totalIncome += amount; // Update total income
      incomeEntries.add({
        'title': 'Income Added', // Entry title
        'amount': amount, // Amount added
        'isPositive': true, // Indicator for added income
        'date': DateFormat('yyyy-MM-dd').format(DateTime.now()), // Current date
      });
    });
    _saveTotalIncome(); // Save updated total income
    _saveIncomeEntries(); // Save income entries
    _amountController.clear(); // Clear input field
  }

  // Remove income from total and income entries
  void _removeIncome() {
    double amount = double.tryParse(_amountController.text) ?? 0; // Parse input amount
    if (amount <= 0) {
      // Validate that the amount is positive
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid amount.')), // Show error message
      );
      return;
    }

    setState(() {
      totalIncome -= amount; // Update total income
      incomeEntries.add({
        'title': 'Income Removed', // Entry title
        'amount': amount, // Amount removed
        'isPositive': false, // Indicator for removed income
        'date': DateFormat('yyyy-MM-dd').format(DateTime.now()), // Current date
      });
    });
    _saveTotalIncome(); // Save updated total income
    _saveIncomeEntries(); // Save income entries
    _amountController.clear(); // Clear input field
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Income'), // App bar title
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh), // Refresh icon for resetting income
            onPressed: _resetTotalIncome, // Reset income on button press
            tooltip: 'Reset Income',
          ),
        ],
      ),
      body: Column(
        children: [
          // Top Section: Display Total Income
          Container(
            color: Colors.redAccent, // Background color for total income display
            padding: const EdgeInsets.all(16.0),
            width: double.infinity,
            child: Center(
              child: Text(
                '\$$totalIncome', // Display total income with dollar sign
                style: const TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Input Form for Adding/Removing Income
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                // Amount input field
                TextField(
                  controller: _amountController, // Controller for text input
                  keyboardType: TextInputType.number, // Numeric keyboard
                  decoration: const InputDecoration(
                    labelText: 'Enter Amount', // Label for input field
                    border: OutlineInputBorder(), // Outline border style
                  ),
                ),
                const SizedBox(height: 16),
                // Buttons for adding or removing income
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    // Button for adding income
                    GestureDetector(
                      onTap: _addIncome, // Call _addIncome when tapped
                      child: Container(
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: const Icon(
                          Icons.add_circle,
                          color: Colors.green, // Color for add icon
                          size: 36,
                        ),
                      ),
                    ),
                    // Button for removing income
                    GestureDetector(
                      onTap: _removeIncome, // Call _removeIncome when tapped
                      child: Container(
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: const Icon(
                          Icons.remove_circle,
                          color: Colors.red, // Color for remove icon
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

          // Income Entries List
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ListView.builder(
                itemCount: incomeEntries.length, // Number of income entries
                itemBuilder: (context, index) {
                  final entry = incomeEntries[index]; // Get the current entry
                  return _buildIncomeItem(
                    entry['title'], // Title of the entry
                    entry['amount'], // Amount of the entry
                    entry['isPositive'], // Indicator if income was added or removed
                    entry['date'], // Date of the entry
                  );
                },
              ),
            ),
          ),
        ],
      ),

      // Bottom Navigation Bar
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0, // Highlight the Income tab
        onTap: (index) {
          // Navigate to the selected tab
          if (index == 0) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const IncomePage()), // Income page
            );
          } else if (index == 1) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const SavingsPage()), // Savings page
            );
          } else if (index == 2) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const ExpensesPage()), // Expenses page
            );
          } else if (index == 3) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const InvestmentPage()), // Investment page
            );
          }
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor:
            const Color.fromARGB(255, 0, 0, 0), // Color for selected item
        unselectedItemColor:
            const Color.fromARGB(137, 0, 0, 0), // Color for unselected items
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

  // Widget to build income entry item
  Widget _buildIncomeItem(String title, double amount, bool isPositive, String date) {
    return Card(
      elevation: 2.0, // Shadow elevation
      margin: const EdgeInsets.symmetric(vertical: 8.0), // Vertical margin
      child: ListTile(
        title: Text(title), // Title of the entry
        subtitle: Text(date), // Date of the entry
        trailing: Text(isPositive ? '+\$${amount.toStringAsFixed(2)}' : '-\$${amount.toStringAsFixed(2)}'), // Amount with sign
      ),
    );
  }
}
