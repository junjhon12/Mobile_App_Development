import 'package:flutter/material.dart';

class NestedTaskScreen extends StatelessWidget {
  const NestedTaskScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nested Task Lists'),
      ),
      body: ListView(
        children: const [
          ExpansionTile(
            title: Text('Monday - 9 AM to 10 AM'),
            children: [
              ListTile(title: Text('HW1')),
              ListTile(title: Text('Essay2')),
            ],
          ),
          ExpansionTile(
            title: Text('Monday - 12 PM to 2 PM'),
            children: [
              ListTile(title: Text('Project1')),
              ListTile(title: Text('Meeting Prep')),
            ],
          ),
        ],
      ),
    );
  }
}
