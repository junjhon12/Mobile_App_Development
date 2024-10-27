import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'income_page.dart';
import 'saving_page.dart';
import 'investment_page.dart';

class ExpensesPage extends StatefulWidget {
  const ExpensesPage({super.key});

  @override
  _ExpensesPageState createState() => _ExpensesPageState();
}

class _ExpensesPageState extends State<ExpensesPage> {
  double totalExpenses = 0.0; // Current expenses total
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _goalController = TextEditingController(); // Goal input controller
  final List<Map<String, dynamic>> expenseEntries = []; // Store expense entries
  double? expenseGoal; // Expense goal

  @override
  void initState() {
    super.initState();
    _loadTotalExpenses();
    _loadExpenseGoal();
  }

  Future<void> _loadTotalExpenses() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      totalExpenses = prefs.getDouble('totalExpenses') ?? 0.0;
    });
  }

  Future<void> _saveTotalExpenses() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setDouble('totalExpenses', totalExpenses);
  }

  Future<void> _loadExpenseGoal() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      expenseGoal = prefs.getDouble('expenseGoal') ?? 0.0;
    });
  }

  Future<void> _saveExpenseGoal() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setDouble('expenseGoal', expenseGoal!);
  }

  // Add an expense and save to shared preferences
  void _addExpense() {
    double? amount = double.tryParse(_amountController.text);
    if (amount != null && _categoryController.text.isNotEmpty) {
      setState(() {
        String category = _categoryController.text;
        totalExpenses += amount;
        expenseEntries.add({'title': category, 'amount': amount, 'isPositive': false});
      });
      _saveTotalExpenses();
      _amountController.clear();
      _categoryController.clear();
    }
  }

  // Remove an expense and save to shared preferences
  void _removeExpense() {
    double? amount = double.tryParse(_amountController.text);
    if (amount != null && _categoryController.text.isNotEmpty) {
      setState(() {
        String category = _categoryController.text;
        totalExpenses -= amount;
        expenseEntries.add({'title': category, 'amount': amount, 'isPositive': true});
      });
      _saveTotalExpenses();
      _amountController.clear();
      _categoryController.clear();
    }
  }

  // Set a monthly/weekly expense goal
  void _setGoal() {
    setState(() {
      expenseGoal = double.tryParse(_goalController.text);
      _saveExpenseGoal();
      _goalController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    double progress = expenseGoal != null && expenseGoal! > 0
        ? (totalExpenses / expenseGoal!).clamp(0.0, 1.0)
        : 0.0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Expenses'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Top Section: Display Total Expenses
          Container(
            color: Colors.orangeAccent,
            width: double.infinity,
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  '\$$totalExpenses',
                  style: const TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                if (expenseGoal != null && expenseGoal! > 0)
                  Column(
                    children: [
                      LinearProgressIndicator(
                        value: progress,
                        backgroundColor: Colors.grey[300],
                        color: Colors.redAccent,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${(progress * 100).toStringAsFixed(1)}% of goal reached',
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
                  controller: _amountController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Enter Amount',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _categoryController,
                  decoration: const InputDecoration(
                    labelText: 'Enter Category (e.g., Food, Transport)',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _goalController,
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
                    GestureDetector(
                      onTap: _setGoal,
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
                itemCount: expenseEntries.length,
                itemBuilder: (context, index) {
                  final entry = expenseEntries[index];
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
        currentIndex: 2,
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
            icon: _buildNavIcon(Icons.account_balance_wallet, Colors.orangeAccent, true),
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

  Widget _buildExpenseEntry(String title, double amount, bool isPositive) {
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
            '\$${amount.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: 16,
              color: isPositive ? Colors.green : Colors.red,
              fontWeight: FontWeight.bold,
            ),
          ),
          Icon(
            isPositive ? Icons.add_circle : Icons.remove_circle,
            color: isPositive ? Colors.green : Colors.red,
          ),
        ],
      ),
    );
  }

  Widget _buildNavIcon(IconData icon, Color color, bool isSelected) {
    return Icon(
      icon,
      color: isSelected ? color : color.withOpacity(0.5),
    );
  }
}
