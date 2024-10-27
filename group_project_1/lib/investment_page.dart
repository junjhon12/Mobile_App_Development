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
  double totalInvestments = 0.0;
  final TextEditingController _amountController = TextEditingController();
  String? _selectedCategory;
  final List<Map<String, dynamic>> investmentEntries = [];

  @override
  void initState() {
    super.initState();
    _loadInvestmentData();
  }

  Future<void> _loadInvestmentData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      totalInvestments = prefs.getDouble('totalInvestments') ?? 0.0;
      _loadInvestmentEntries(prefs);
    });
  }

  Future<void> _saveInvestmentData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setDouble('totalInvestments', totalInvestments);
    _saveInvestmentEntries(prefs);
  }

  void _loadInvestmentEntries(SharedPreferences prefs) {
    final entries = prefs.getStringList('investmentEntries') ?? [];
    setState(() {
      investmentEntries.clear();
      investmentEntries.addAll(entries.map(
          (e) => Map<String, dynamic>.from(Uri.decodeComponent(e) as Map)));
    });
  }

  void _saveInvestmentEntries(SharedPreferences prefs) {
    final entries = investmentEntries
        .map((e) => Uri.encodeComponent(e.toString()))
        .toList();
    prefs.setStringList('investmentEntries', entries);
  }

  void _addInvestment() {
    if (_selectedCategory == null) return;

    setState(() {
      double amount = double.tryParse(_amountController.text) ?? 0;
      totalInvestments += amount;
      investmentEntries.add({
        'title': 'Investment Added',
        'category': _selectedCategory!,
        'amount': amount,
        'isPositive': true,
      });
    });
    _saveInvestmentData();
    _amountController.clear();
  }

  void _removeInvestment() {
    if (_selectedCategory == null) return;

    setState(() {
      double amount = double.tryParse(_amountController.text) ?? 0;
      totalInvestments -= amount;
      investmentEntries.add({
        'title': 'Investment Removed',
        'category': _selectedCategory!,
        'amount': amount,
        'isPositive': false,
      });
    });
    _saveInvestmentData();
    _amountController.clear();
  }

  void _clearInvestments() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    setState(() {
      totalInvestments = 0.0;
      investmentEntries.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Investments'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: _clearInvestments,
          ),
        ],
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
                style: const TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Form Section for Adding or Removing Investments
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                // Dropdown to select category
                DropdownButtonFormField<String>(
                  value: _selectedCategory,
                  items: <String>['Stocks', 'Bonds', 'Real Estate', 'Other']
                      .map((category) => DropdownMenuItem(
                            value: category,
                            child: Text(category),
                          ))
                      .toList(),
                  onChanged: (value) =>
                      setState(() => _selectedCategory = value),
                  decoration: const InputDecoration(
                    labelText: 'Select Investment Type',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 8),
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
                    entry['category'],
                  );
                },
              ),
            ),
          ),
        ],
      ),

      // Bottom Navigation Bar
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 3,
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const IncomePage()));
          } else if (index == 1)
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const SavingsPage()));
          else if (index == 2)
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const ExpensesPage()));
          else if (index == 3)
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => const InvestmentPage()));
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
            icon: _buildNavIcon(
                Icons.account_balance_wallet, Colors.orangeAccent, false),
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
  Widget _buildInvestmentEntry(
      String title, double amount, bool isPositive, String category) {
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
              child: Text('$title - $category',
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w500))),
          Text(
            '\$${amount.toStringAsFixed(2)}',
            style: TextStyle(
                fontSize: 16,
                color: isPositive ? Colors.green : Colors.red,
                fontWeight: FontWeight.bold),
          ),
          Icon(isPositive ? Icons.add_circle : Icons.remove_circle,
              color: isPositive ? Colors.green : Colors.red),
        ],
      ),
    );
  }

  // Function to style bottom navigation icons
  Widget _buildNavIcon(IconData icon, Color color, bool isSelected) {
    return Icon(icon, color: isSelected ? color : color.withOpacity(0.5));
  }
}
