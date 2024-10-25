import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IncomePage extends StatefulWidget {
  const IncomePage({super.key});

  @override
  _IncomePageState createState() => _IncomePageState();
}

class _IncomePageState extends State<IncomePage> {
  double totalIncome = 0.0;
  final TextEditingController _amountController = TextEditingController();

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
    });
    _saveTotalIncome();
    _amountController.clear();
  }

  void _removeIncome() {
    setState(() {
      double amount = double.tryParse(_amountController.text) ?? 0;
      totalIncome -= amount;
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
        ],
      ),
    );
  }
}
