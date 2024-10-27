import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'expenses_page.dart';
import 'investment_page.dart';
import 'saving_page.dart';
import 'package:intl/intl.dart';

class IncomePage extends StatefulWidget {
  const IncomePage({super.key});

  @override
  _IncomePageState createState() => _IncomePageState();
}

class _IncomePageState extends State<IncomePage> {
  double totalIncome = 0.0; // Current income
  final TextEditingController _amountController = TextEditingController();
  final List<Map<String, dynamic>> incomeEntries = []; // Store income entries

  @override
  void initState() {
    super.initState();
    _loadTotalIncome();
  }

  Future<void> _loadTotalIncome() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      totalIncome = prefs.getDouble('totalIncome') ?? 0.0;
    });
  }

  Future<void> _saveTotalIncome() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('totalIncome', totalIncome);
  }

  Future<void> _resetTotalIncome() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      totalIncome = 0.0;
      incomeEntries
          .clear(); // Clears the list if you want to remove past entries too
    });
    await prefs.setDouble('totalIncome', totalIncome); // Save the reset value
  }

  // Add income to total and list
  void _addIncome() {
    double amount = double.tryParse(_amountController.text) ?? 0;
    if (amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid amount.')),
      );
      return;
    }

    setState(() {
      totalIncome += amount;
      incomeEntries.add({
        'title': 'Income Added',
        'amount': amount,
        'isPositive': true,
        'date': DateFormat('yyyy-MM-dd').format(DateTime.now()),
      });
    });
    _saveTotalIncome();
    _amountController.clear();
  }

  // Remove income from total and list
  void _removeIncome() {
    double amount = double.tryParse(_amountController.text) ?? 0;
    if (amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid amount.')),
      );
      return;
    }

    setState(() {
      totalIncome -= amount;
      incomeEntries.add({
        'title': 'Income Removed',
        'amount': amount,
        'isPositive': false,
        'date': DateFormat('yyyy-MM-dd').format(DateTime.now()),
      });
    });
    _saveTotalIncome();
    _amountController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Income'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _resetTotalIncome,
            tooltip: 'Reset Income',
          ),
        ],
      ),
      body: Column(
        children: [
          // Top Section: Display Total Income
          Container(
            color: Colors.redAccent,
            padding: const EdgeInsets.all(16.0),
            width: double.infinity,
            child: Center(
              child: Text(
                '\$$totalIncome',
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
                  controller: _amountController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Enter Amount',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                // Buttons for adding or removing income
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    // Button for adding income
                    GestureDetector(
                      onTap: _addIncome,
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
                    // Button for removing income
                    GestureDetector(
                      onTap: _removeIncome,
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

          // Income Entries List
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ListView.builder(
                itemCount: incomeEntries.length,
                itemBuilder: (context, index) {
                  final entry = incomeEntries[index];
                  return _buildIncomeItem(
                    entry['title'],
                    entry['amount'],
                    entry['isPositive'],
                    entry['date'],
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
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.attach_money, color: Colors.redAccent),
            label: 'Income',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.savings, color: Colors.amberAccent),
            label: 'Savings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet, color: Colors.orangeAccent),
            label: 'Expenses',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.show_chart, color: Colors.greenAccent),
            label: 'Investments',
          ),
        ],
      ),
    );
  }

  Widget _buildIncomeItem(
      String title, double amount, bool isPositive, String date) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
          color: Colors.grey[200], borderRadius: BorderRadius.circular(8.0)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w500),
                ),
                Text(date,
                    style: const TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
          ),
          Text(
            '\$${amount.toStringAsFixed(2)}',
            style: TextStyle(
                fontSize: 16,
                color: isPositive ? Colors.green : Colors.red,
                fontWeight: FontWeight.bold),
          ),
          Icon(
            isPositive ? Icons.add_circle : Icons.remove_circle,
            color: isPositive ? Colors.green : Colors.red,
          ),
        ],
      ),
    );
  }
}
