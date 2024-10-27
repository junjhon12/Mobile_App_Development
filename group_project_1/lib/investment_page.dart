import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'income_page.dart';
import 'saving_page.dart';
import 'expenses_page.dart';

class InvestmentPage extends StatefulWidget {
  const InvestmentPage({super.key});

  @override
  _InvestmentPageState createState() => _InvestmentPageState();
}

class _InvestmentPageState extends State<InvestmentPage> {
  double totalInvestments = 0.0; // Current investments total
  final TextEditingController _amountController = TextEditingController();
  final List<Map<String, dynamic>> investmentEntries = []; // List for investment entries

  @override
  void initState() {
    super.initState();
    _loadTotalInvestments();
  }

  Future<void> _loadTotalInvestments() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      totalInvestments = prefs.getDouble('totalInvestments') ?? 0.0;
    });
  }

  Future<void> _saveTotalInvestments() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setDouble('totalInvestments', totalInvestments);
  }

  // Function to add an investment
  void _addInvestment() {
    setState(() {
      double amount = double.tryParse(_amountController.text) ?? 0;
      totalInvestments += amount;
      investmentEntries.add({'title': 'Investment Added', 'amount': amount, 'isPositive': true});
    });
    _saveTotalInvestments();
    _amountController.clear();
  }

  // Function to remove an investment
  void _removeInvestment() {
    setState(() {
      double amount = double.tryParse(_amountController.text) ?? 0;
      totalInvestments -= amount;
      investmentEntries.add({'title': 'Investment Removed', 'amount': amount, 'isPositive': false});
    });
    _saveTotalInvestments();
    _amountController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Investments'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Top Section for Total Investments
          Container(
            color: Colors.greenAccent,
            width: double.infinity,
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Text(
                '\$$totalInvestments',
                style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Form Section for Adding or Removing Investments
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
                    GestureDetector(
                      onTap: _addInvestment,
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
                      onTap: _removeInvestment,
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

          // Investment Entries List
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ListView.builder(
                itemCount: investmentEntries.length,
                itemBuilder: (context, index) {
                  final entry = investmentEntries[index];
                  return _buildInvestmentEntry(
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
        currentIndex: 3, // Highlight the Investments tab
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
            icon: _buildNavIcon(Icons.show_chart, Colors.greenAccent, true),
            label: 'Investments',
          ),
        ],
      ),
    );
  }

  // Function to build individual investment entry
  Widget _buildInvestmentEntry(String title, double amount, bool isPositive) {
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

  // Function to style bottom navigation icons
  Widget _buildNavIcon(IconData icon, Color color, bool isSelected) {
    return Icon(
      icon,
      color: isSelected ? color : color.withOpacity(0.5),
    );
  }
}
