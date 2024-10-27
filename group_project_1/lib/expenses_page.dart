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
  final List<Map<String, dynamic>> expenseEntries = []; // List to store expense entries

  @override
  void initState() {
    super.initState();
    _loadTotalExpenses();
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

  // Function to add an expense
  void _addExpense() {
    setState(() {
      double amount = double.tryParse(_amountController.text) ?? 0;
      String category = _categoryController.text.isNotEmpty ? _categoryController.text : 'General';
      totalExpenses += amount;
      expenseEntries.add({'title': category, 'amount': amount, 'isPositive': true});
    });
    _saveTotalExpenses();
    _amountController.clear();
    _categoryController.clear();
  }

  // Function to remove an expense
  void _removeExpense() {
    setState(() {
      double amount = double.tryParse(_amountController.text) ?? 0;
      String category = _categoryController.text.isNotEmpty ? _categoryController.text : 'General';
      totalExpenses -= amount;
      expenseEntries.add({'title': category, 'amount': amount, 'isPositive': false});
    });
    _saveTotalExpenses();
    _amountController.clear();
    _categoryController.clear();
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
          // Top Section: Display Total Expenses
          Container(
            color: Colors.orangeAccent,
            width: double.infinity,
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Text(
                '\$$totalExpenses',
                style: const TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Input Form for Adding/Removing Expenses
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

  // Function to build individual expense entry
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
