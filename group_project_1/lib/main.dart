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
        primarySwatch: Colors.green,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double totalIncome = 0.0;

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
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Container(
                color: Colors.lightGreen,
                width: double.infinity,
                padding: const EdgeInsets.all(16.0),
                child: Center(
                  child: Text(
                    '\$$totalIncome',
                    style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ),
          // Middle Section for Details (45% height)
          Expanded(
            flex: 4,
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
                      ).then((_) => _loadTotalIncome());
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
            currentIndex: 3,
            onTap: (index) {
              if (index == 0) {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const IncomePage()))
                    .then((_) => _loadTotalIncome());
              } else if (index == 1) {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const SavingsPage()));
              } else if (index == 2) {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const ExpensesPage()));
              } else if (index == 3) {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const InvestmentPage()));
              }
            },
            type: BottomNavigationBarType.fixed,
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.black54,
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
        ],
      ),
    );
  }

  Widget _buildCard(String title, Color color) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Center(
        child: Text(
          title,
          style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 0, 0, 0)),
        ),
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
