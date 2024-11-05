import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(InventoryApp());
}

class InventoryApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Inventory Management App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: InventoryHomePage(title: 'Inventory Home Page'),
    );
  }
}

class InventoryHomePage extends StatefulWidget {
  InventoryHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _InventoryHomePageState createState() => _InventoryHomePageState();
}

class _InventoryHomePageState extends State<InventoryHomePage> {
  final TextEditingController _nameController =
      TextEditingController(); // Controller for item name input
  final TextEditingController _quantityController =
      TextEditingController(); // Controller for item quantity input
  final CollectionReference inventory = FirebaseFirestore.instance
      .collection('inventory'); // Firestore collection reference

  // Function to add a new item to the inventory
  Future<void> _addItem() async {
    await inventory.add({
      'name': _nameController.text,
      'quantity': int.tryParse(_quantityController.text) ?? 0,
    });
    _nameController.clear();
    _quantityController.clear();
  }

  // Function to update an existing item in the inventory
  Future<void> _updateItem(String id, String name, int quantity) async {
    _nameController.text = name;
    _quantityController.text = quantity.toString();
    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Update Item"), // Title of the dialog
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Item Name'),
            ),
            TextField(
              controller: _quantityController,
              decoration: InputDecoration(labelText: 'Quantity'),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            child: Text('Cancel'),
            onPressed: () {
              _nameController.clear(); // Clear the input fields
              _quantityController.clear();
              Navigator.of(context).pop(); // Close the dialog
            },
          ),
          TextButton(
            child: Text('Update'), // Update button
            onPressed: () async {
              await inventory.doc(id).update({
                'name': _nameController.text, // Update item name
                'quantity': int.tryParse(_quantityController.text) ??
                    0, // Update item quantity
              });
              _nameController.clear(); // Clear the input fields
              _quantityController.clear();
              Navigator.of(context).pop(); // Close the dialog
            },
          ),
        ],
      ),
    );
  }

  // Function to delete an item from the inventory
  Future<void> _deleteItem(String id) async {
    await inventory.doc(id).delete(); // Deletes the item from Firestore
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title), // App bar title
      ),
      body: StreamBuilder(
        stream: inventory.snapshots(), // Listen to Firestore collection changes
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          final items = snapshot.data?.docs ?? [];

          return ListView.builder(
            itemCount: items.length, // Number of items to display
            itemBuilder: (context, index) {
              final item = items[index];
              final data = item.data() as Map<String, dynamic>;

              // Determine color based on quantity
              Color quantityColor;
              int quantity = data['quantity'];
              if (quantity < 5) {
                quantityColor = Colors.red; // Low stock
              } else if (quantity <= 10) {
                quantityColor = Colors.orange; // Adequate stock
              } else {
                quantityColor = Colors.green; // Surplus
              }

              return Container(
                color: quantityColor.withOpacity(
                    0.1), // Light background color based on quantity
                child: ListTile(
                  title: Text(data['name']),
                  subtitle: Text("Quantity: ${data['quantity']}"),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit), // Edit icon
                        onPressed: () => _updateItem(item.id, data['name'],
                            data['quantity']), // Update item on press
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () => _deleteItem(item.id),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: Text("Add Item"), // Title of the dialog to add an item
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _nameController, // Name input field
                  decoration: InputDecoration(labelText: 'Item Name'),
                ),
                TextField(
                  controller: _quantityController, // Quantity input field
                  decoration: InputDecoration(labelText: 'Quantity'),
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
            actions: [
              TextButton(
                child: Text('Cancel'), // Cancel button
                onPressed: () {
                  _nameController.clear();
                  _quantityController.clear();
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: Text('Add'), // Add button
                onPressed: () {
                  _addItem();
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        ),
        tooltip: 'Add Item', // Tooltip for the floating action button
        child: Icon(Icons.add),
      ),
    );
  }
}