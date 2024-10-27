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
  double currentSavings = 2000.0;
  double savingsGoal = 5000.0;
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _goalController = TextEditingController();
  final List<Map<String, dynamic>> savingsEntries = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  // Load savings data from SharedPreferences
  Future<void> _loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      currentSavings = prefs.getDouble('currentSavings') ?? 2000.0;
      savingsGoal = prefs.getDouble('savingsGoal') ?? 5000.0;
      // Load entries as JSON string
      savingsEntries.addAll((prefs.getStringList('savingsEntries') ?? []).map((entry) => Map<String, dynamic>.from(jsonDecode(entry))).toList());
    });
  }

  // Save savings data to SharedPreferences
  Future<void> _saveData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('currentSavings', currentSavings);
    await prefs.setDouble('savingsGoal', savingsGoal);
    // Save entries as JSON string
    List<String> entries = savingsEntries.map((entry) => jsonEncode(entry)).toList();
    await prefs.setStringList('savingsEntries', entries);
  }

  // Function to add savings
  void _addSavings() {
    setState(() {
      double amount = double.tryParse(_amountController.text) ?? 0;
      currentSavings += amount;
      savingsEntries.add({
        'title': 'Savings Added',
        'amount': amount,
        'isPositive': true,
        'date': DateTime.now().toString(),
      });
    });
    _saveData();
    _amountController.clear();
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
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                double amount = double.tryParse(_amountController.text) ?? 0;
                currentSavings -= amount;
                savingsEntries.add({
                  'title': 'Savings Removed',
                  'amount': amount,
                  'isPositive': false,
                  'date': DateTime.now().toString(),
                });
              });
              _saveData();
              _amountController.clear();
              Navigator.of(context).pop();
            },
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }

  // Calculate progress towards the goal
  double _calculateProgress() => currentSavings / savingsGoal;

  @override
  Widget build(BuildContext context) {
    double progress = _calculateProgress();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Savings'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              _goalController.text = savingsGoal.toString();
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Edit Savings Goal'),
                  content: TextField(
                    controller: _goalController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Enter new savings goal',
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          savingsGoal = double.tryParse(_goalController.text) ?? savingsGoal;
                        });
                        _saveData();
                        Navigator.of(context).pop();
                      },
                      child: const Text('Save'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Display current savings and savings goal
          Container(
            color: Colors.amberAccent,
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Current Savings', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
                    Text(
                      '\$$currentSavings',
                      style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text('Savings Goal', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
                    Text(
                      '\$$savingsGoal',
                      style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Progress bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                LinearProgressIndicator(
                  value: progress.clamp(0.0, 1.0),
                  minHeight: 10,
                  backgroundColor: Colors.grey[300],
                  color: progress >= 1.0 ? Colors.green : Colors.blueAccent,
                ),
                const SizedBox(height: 8),
                Text(
                  progress >= 1.0 ? 'Goal Reached! 🎉' : '${(progress * 100).toStringAsFixed(1)}% of your goal reached',
                  style: TextStyle(fontSize: 16, color: progress >= 1.0 ? Colors.green : Colors.black, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Input Form for Adding/Removing Savings
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                TextField(
                  controller: _amountController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Enter Amount', border: OutlineInputBorder()),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    GestureDetector(
                      onTap: _addSavings,
                      child: Container(
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(8.0)),
                        child: const Icon(Icons.add_circle, color: Colors.green, size: 36),
                      ),
                    ),
                    GestureDetector(
                      onTap: _removeSavings,
                      child: Container(
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(8.0)),
                        child: const Icon(Icons.remove_circle, color: Colors.red, size: 36),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Savings Entries List
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ListView.builder(
                itemCount: savingsEntries.length,
                itemBuilder: (context, index) {
                  final entry = savingsEntries[index];
                  return _buildSavingsItem(entry['title'], entry['amount'], entry['isPositive'], entry['date']);
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
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const IncomePage()));
          } else if (index == 1) {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const SavingsPage()));
          } else if (index == 2) {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const ExpensesPage()));
          } else if (index == 3) {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const InvestmentPage()));
          }
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color.fromARGB(255, 0, 0, 0),
        unselectedItemColor: const Color.fromARGB(137, 0, 0, 0),
        backgroundColor: Colors.white,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.attach_money, color: Colors.redAccent), label: 'Income'),
          BottomNavigationBarItem(icon: Icon(Icons.savings, color: Colors.amberAccent), label: 'Savings'),
          BottomNavigationBarItem(icon: Icon(Icons.account_balance_wallet, color: Colors.orangeAccent), label: 'Expenses'),
          BottomNavigationBarItem(icon: Icon(Icons.show_chart, color: Colors.greenAccent), label: 'Investments'),
        ],
      ),
    );
  }

  Widget _buildSavingsItem(String title, double amount, bool isPositive, String date) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(8.0)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                Text(date, style: const TextStyle(fontSize: 12, color: Colors.black54)),
              ],
            ),
          ),
          Text(
            '\$${amount.toStringAsFixed(2)}',
            style: TextStyle(fontSize: 16, color: isPositive ? Colors.green : Colors.red, fontWeight: FontWeight.bold),
          ),
          Icon(isPositive ? Icons.add_circle : Icons.remove_circle, color: isPositive ? Colors.green : Colors.red),
        ],
      ),
    );
  }
}
