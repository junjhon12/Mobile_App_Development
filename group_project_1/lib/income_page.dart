import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'saving_page.dart';
import 'expenses_page.dart';
import 'investment_page.dart';

class IncomePage extends StatefulWidget {
  const IncomePage({super.key});

  @override
  _IncomePageState createState() => _IncomePageState();
}

class _IncomePageState extends State<IncomePage> {
  double totalIncome = 0.0;
  final TextEditingController _amountController = TextEditingController();
  final List<Map<String, dynamic>> incomeEntries = []; // List to store income entries

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
    prefs.setDouble('totalIncome', totalIncome);
  }

  void _addIncome() {
    setState(() {
      double amount = double.tryParse(_amountController.text) ?? 0;
      totalIncome += amount;
      incomeEntries.add({'title': 'Income Added', 'amount': amount, 'isPositive': true});
    });
    _saveTotalIncome();
    _amountController.clear();
  }

  void _removeIncome() {
    setState(() {
      double amount = double.tryParse(_amountController.text) ?? 0;
      totalIncome -= amount;
      incomeEntries.add({'title': 'Income Removed', 'amount': amount, 'isPositive': false});
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
      ),
      body: Column(
        children: [
          // Top Section: Display Total Income
          Container(
            color: Colors.redAccent,
            width: double.infinity,
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Text(
                '\$$totalIncome',
                style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Input Form for Adding/Removing Income
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
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton.icon(
                      icon: const Icon(Icons.add),
                      label: const Text('Add Income'),
                      onPressed: _addIncome,
                    ),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.remove),
                      label: const Text('Remove Income'),
                      onPressed: _removeIncome,
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
                  return _buildIncomeEntry(
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

  // Function to build income entry
  Widget _buildIncomeEntry(String title, double amount, bool isPositive) {
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
    color: isSelected ? color : color.withOpacity(0.5), // Full color when selected, semi-transparent when not
  );
}
}
