import 'package:flutter/material.dart';
import 'saving_page.dart';
import 'expenses_page.dart';
import 'income_page.dart';
import 'investment_page.dart';

void main() {
  runApp(PersonalFinanceApp());
}

class PersonalFinanceApp extends StatelessWidget {
  const PersonalFinanceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Personal Finance Manager',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Personal Finance Manager'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Top Section for Total Balance (40% height)
          Expanded(
            flex: 3, // 40% of the height
            child: Padding(
              padding: const EdgeInsets.only(bottom: 16.0), // Adding bottom padding similar to the middle section
              child: Container(
                color: Colors.lightGreen,
                width: double.infinity,
                padding: const EdgeInsets.all(16.0),
                child: const Center(
                  child: Text(
                    '\$0.00',
                    style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ),
          // Middle Section for Details (45% height)
          Expanded(
            flex: 4.5.toInt(), // 45% of the height
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const IncomePage()),
                      );
                    },
                    child: _buildCard('Income', Colors.redAccent),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const SavingsPage()),
                      );
                    },
                    child: _buildCard('Savings', Colors.amberAccent),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const ExpensesPage()),
                      );
                    },
                    child: _buildCard('Expenses', Colors.orangeAccent),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const InvestmentPage()),
                      );
                    },
                    child: _buildCard('Investments', Colors.greenAccent),
                  ),
                ],
              ),
            ),
          ),
          BottomNavigationBar(
            currentIndex: 3,  // Home tab by default
            onTap: (index) {
              if (index == 0) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const IncomePage()),
                );
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
            },
            type: BottomNavigationBarType.fixed,
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.black54,
            backgroundColor: Colors.white, // Keep background of the nav bar white
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
        ],
      ),
    );
  }

  Widget _buildCard(String title, Color color) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Center(
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildNavIcon(IconData icon, Color bgColor, bool isSelected) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: isSelected ? bgColor : Colors.transparent, // Background color if selected
        shape: BoxShape.circle, // Circular background for the icon
      ),
      child: Icon(
        icon,
        color: isSelected ? Colors.white : Colors.black54, // Icon color based on selection
      ),
    );
  }
}
