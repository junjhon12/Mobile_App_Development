import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'saving_page.dart';
import 'expenses_page.dart';
import 'income_page.dart';
import 'investment_page.dart';

void main() {
  runApp(const PersonalFinanceApp());
}

class PersonalFinanceApp extends StatelessWidget {
  const PersonalFinanceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Personal Finance Manager',
      theme: ThemeData(
        primarySwatch: Colors.green, // Set primary color theme
      ),
      home: const HomePage(), // Set HomePage as the initial route
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double totalIncome = 0.0; // Variable to store total income
  int _selectedIndex = 0; // Tracks the selected tab in BottomNavigationBar

  @override
  void initState() {
    super.initState();
    _loadTotalIncome(); // Load total income when initializing state
  }

  // Load total income from shared preferences
  Future<void> _loadTotalIncome() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      totalIncome = prefs.getDouble('totalIncome') ??
          0.0; // Default to 0.0 if no value is found
    });
  }

  // Handle tab selection in BottomNavigationBar
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; // Update selected index
    });

    // Navigate to the corresponding page based on selected index
    if (index == 0) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const IncomePage()),
      ).then((_) => _loadTotalIncome()); // Reload income when returning
    } else if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const SavingsPage()),
      );
    } else if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ExpensesPage()),
      );
    } else if (index == 3) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const InvestmentPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Personal Finance Manager'),
        centerTitle: true, // Center the title in the app bar
      ),
      body: Column(
        children: [
          // Top Section for displaying total balance (40% height)
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Container(
                color: Colors.lightGreen,
                width: double.infinity,
                padding: const EdgeInsets.all(16.0),
                child: Center(
                  child: Text(
                    '\$$totalIncome', // Display total income with dollar sign
                    style: const TextStyle(
                        fontSize: 50, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ),
          // Middle Section for navigational cards (45% height)
          Expanded(
            flex: 4,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: GridView.count(
                crossAxisCount: 2, // Set number of columns in the grid
                mainAxisSpacing: 10, // Vertical spacing between cards
                crossAxisSpacing: 10, // Horizontal spacing between cards
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const IncomePage()),
                      ).then(
                          (_) => _loadTotalIncome()); // Reload income on return
                    },
                    child:
                        _buildCard('Income', Colors.redAccent), // Income card
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SavingsPage()),
                      );
                    },
                    child: _buildCard(
                        'Savings', Colors.amberAccent), // Savings card
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ExpensesPage()),
                      );
                    },
                    child: _buildCard(
                        'Expenses', Colors.orangeAccent), // Expenses card
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const InvestmentPage()),
                      );
                    },
                    child: _buildCard(
                        'Investments', Colors.greenAccent), // Investments card
                  ),
                ],
              ),
            ),
          ),

          // Bottom Navigation Bar for navigation between pages
          BottomNavigationBar(
            currentIndex: _selectedIndex, // Highlight selected tab
            onTap: _onItemTapped, // Handle tap events to navigate
            type: BottomNavigationBarType.fixed,
            selectedItemColor: Colors.black, // Color for selected item
            unselectedItemColor: Colors.black54, // Color for unselected items
            backgroundColor: Colors.white,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.attach_money,
                    color: Colors.redAccent), // Icon for Income
                label: 'Income',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.savings,
                    color: Colors.amberAccent), // Icon for Savings
                label: 'Savings',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.account_balance_wallet,
                    color: Colors.orangeAccent), // Icon for Expenses
                label: 'Expenses',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.show_chart,
                    color: Colors.greenAccent), // Icon for Investments
                label: 'Investments',
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Build a card widget with title and color
  Widget _buildCard(String title, Color color) {
    return Container(
      decoration: BoxDecoration(
        color: color, // Set background color of the card
        borderRadius:
            BorderRadius.circular(10.0), // Rounded corners for the card
      ),
      child: Center(
        child: Text(
          title, // Display title in the card
          style: const TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
        ),
      ),
    );
  }
}
