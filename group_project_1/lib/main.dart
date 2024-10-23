import 'package:flutter/material.dart';
import 'saving_page.dart';
import 'expenses_page.dart';
import 'income_page.dart';
import 'investment_page.dart';

void main() {
  runApp(PersonalFinanceApp());
}

class PersonalFinanceApp extends StatelessWidget {
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Personal Finance Manager'),
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
                padding: EdgeInsets.all(16.0),
                child: Center(
                  child: Text(
                    '\$1000.00',
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
                        MaterialPageRoute(builder: (context) => IncomePage()),
                      );
                    },
                    child: _buildCard('Income', Colors.redAccent),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SavingsPage()),
                      );
                    },
                    child: _buildCard('Savings', Colors.amberAccent),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ExpensesPage()),
                      );
                    },
                    child: _buildCard('Expenses', Colors.orangeAccent),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => InvestmentPage()),
                      );
                    },
                    child: _buildCard('Investments', Colors.greenAccent),
                  ),
                ],
              ),
            ),
          ),

          // Bottom Navigation Bar (auto height)
          BottomNavigationBarSection(),
        ],
      ),
    );
  }

  // Function to build the cards
  Widget _buildCard(String title, Color color) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Center(
        child: Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

// Separate Widget for Bottom Navigation Bar
class BottomNavigationBarSection extends StatefulWidget {
  @override
  _BottomNavigationBarSectionState createState() => _BottomNavigationBarSectionState();
}

class _BottomNavigationBarSectionState extends State<BottomNavigationBarSection> {
  int _currentIndex = 3; // Default to 'Home' tab

  final List<Color> _backgroundColors = [
    Colors.redAccent,     // Income
    Colors.amberAccent,   // Savings
    Colors.orangeAccent,  // Expenses
    Colors.greenAccent,   // Investments
  ];

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: _currentIndex,
      onTap: (index) {
        setState(() {
          _currentIndex = index;
        });
      },
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.black54,
      backgroundColor: Colors.white, // Keep background of the nav bar white
      items: [
        BottomNavigationBarItem(
          icon: _buildNavIcon(Icons.attach_money, _backgroundColors[0], _currentIndex == 0),
          label: 'Income',
        ),
        BottomNavigationBarItem(
          icon: _buildNavIcon(Icons.savings, _backgroundColors[1], _currentIndex == 1),
          label: 'Savings',
        ),
        BottomNavigationBarItem(
          icon: _buildNavIcon(Icons.account_balance_wallet, _backgroundColors[2], _currentIndex == 2),
          label: 'Expenses',
        ),
        BottomNavigationBarItem(
          icon: _buildNavIcon(Icons.show_chart, _backgroundColors[3], _currentIndex == 3),
          label: 'Investments',
        ),
      ],
    );
  }

  // Function to build icon with colored background
  Widget _buildNavIcon(IconData icon, Color bgColor, bool isSelected) {
    return Container(
      padding: EdgeInsets.all(8.0),
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
