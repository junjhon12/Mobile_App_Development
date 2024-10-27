import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  int _selectedIndex = 0; // Track selected index for BottomNavigationBar

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

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if (index == 0) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => const IncomePage()));
    } else if (index == 1) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => const SavingsPage()));
    } else if (index == 2) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => const ExpensesPage()));
    } else if (index == 3) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => const InvestmentPage()));
    }
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
        currentIndex: _selectedIndex, // Dynamic tracking of selected tab
        onTap: _onItemTapped, // Update the selected index
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.black, // Color for selected icons and labels
        unselectedItemColor: Colors.black54, // Color for unselected icons and labels
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
}
