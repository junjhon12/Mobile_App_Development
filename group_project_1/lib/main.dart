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
class BottomNavigationBarSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.black54,
      backgroundColor: Colors.green,
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.attach_money),
          label: 'Transactions',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.savings),
          label: 'Savings',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.show_chart),
          label: 'Investments',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
      ],
    );
  }
}
