import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

void main() {
  runApp(const CardOrganizerApp());
}

class CardOrganizerApp extends StatelessWidget {
  const CardOrganizerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Card Organizer App',
      home: FolderScreen(),
    );
  }
}

// Database Helper Class
class DatabaseHelper {
  static const _databaseName = "card_organizer.db";
  static const _databaseVersion = 1;

  static const tableFolders = 'folders';
  static const tableCards = 'cards';

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  _initDatabase() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, _databaseName);
    return await openDatabase(path, version: _databaseVersion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $tableFolders (
        id INTEGER PRIMARY KEY,
        folder_name TEXT NOT NULL,
        timestamp TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE $tableCards (
        id INTEGER PRIMARY KEY,
        name TEXT NOT NULL,
        suit TEXT NOT NULL,
        image_url TEXT,
        folder_id INTEGER,
        FOREIGN KEY (folder_id) REFERENCES $tableFolders (id)
      )
    ''');

    // Insert default folders
    await db.insert(tableFolders, {'folder_name': 'Hearts', 'timestamp': DateTime.now().toString()});
    await db.insert(tableFolders, {'folder_name': 'Spades', 'timestamp': DateTime.now().toString()});
    await db.insert(tableFolders, {'folder_name': 'Diamonds', 'timestamp': DateTime.now().toString()});
    await db.insert(tableFolders, {'folder_name': 'Clubs', 'timestamp': DateTime.now().toString()});

    // Prepopulate cards (Ace to King for each suit)
    for (var suit in ['Hearts', 'Spades', 'Diamonds', 'Clubs']) {
      for (var num = 1; num <= 13; num++) {
        String name = '$num of $suit';
        String imageUrl = 'https://example.com/images/$name.png'; // Replace with actual image URLs
        await db.insert(tableCards, {'name': name, 'suit': suit, 'image_url': imageUrl, 'folder_id': null});
      }
    }
  }

  // Fetch all folders
  Future<List<Map<String, dynamic>>> fetchFolders() async {
    Database db = await instance.database;
    return await db.query(tableFolders);
  }

  // Fetch cards in a folder
  Future<List<Map<String, dynamic>>> fetchCards(int folderId) async {
    Database db = await instance.database;
    return await db.query(tableCards, where: 'folder_id = ?', whereArgs: [folderId]);
  }

  // Add card to folder
  Future<int> addCardToFolder(String name, String suit, String imageUrl, int folderId) async {
    Database db = await instance.database;
    return await db.insert(tableCards, {'name': name, 'suit': suit, 'image_url': imageUrl, 'folder_id': folderId});
  }

  // Update card details
  Future<int> updateCard(int id, String name, String suit, String imageUrl, int? folderId) async {
    Database db = await instance.database;
    return await db.update(tableCards, {'name': name, 'suit': suit, 'image_url': imageUrl, 'folder_id': folderId}, where: 'id = ?', whereArgs: [id]);
  }

  // Remove card from folder
  Future<int> removeCardFromFolder(int cardId) async {
    Database db = await instance.database;
    return await db.delete(tableCards, where: 'id = ?', whereArgs: [cardId]);
  }

  // Get count of cards in a folder
  Future<int> countCardsInFolder(int folderId) async {
    Database db = await instance.database;
    var result = await db.rawQuery('SELECT COUNT(*) FROM $tableCards WHERE folder_id = ?', [folderId]);
    return Sqflite.firstIntValue(result) ?? 0;
  }

  // Delete folder
  Future<int> deleteFolder(int folderId) async {
    Database db = await instance.database;
    await db.delete(tableCards, where: 'folder_id = ?', whereArgs: [folderId]); // Delete all cards in the folder
    return await db.delete(tableFolders, where: 'id = ?', whereArgs: [folderId]);
  }

  // Add custom folder
  Future<int> addCustomFolder(String folderName) async {
    Database db = await instance.database;
    return await db.insert(tableFolders, {'folder_name': folderName, 'timestamp': DateTime.now().toString()});
  }
}

// Folder Screen
class FolderScreen extends StatelessWidget {
  const FolderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Folders'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              // Code to add a custom folder
              await _addCustomFolder(context);
            },
          ),
        ],
      ),
      body: FutureBuilder(
        future: DatabaseHelper.instance.fetchFolders(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasData) {
            var folders = snapshot.data as List<Map<String, dynamic>>;
            return ListView.builder(
              itemCount: folders.length,
              itemBuilder: (context, index) {
                var folder = folders[index];
                return ListTile(
                  title: Text(folder['folder_name']),
                  subtitle: FutureBuilder<int>(
                    future: DatabaseHelper.instance.countCardsInFolder(folder['id']),
                    builder: (context, cardCountSnapshot) {
                      if (cardCountSnapshot.connectionState == ConnectionState.waiting) {
                        return const Text('Loading...');
                      }
                      return Text('${cardCountSnapshot.data} cards');
                    },
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CardScreen(folderId: folder['id']),
                      ),
                    );
                  },
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () async {
                      await DatabaseHelper.instance.deleteFolder(folder['id']);
                      // Refresh the screen
                      (context as Element).reassemble();
                    },
                  ),
                );
              },
            );
          }
          return const Center(child: Text('No Folders'));
        },
      ),
    );
  }

  Future<void> _addCustomFolder(BuildContext context) async {
    TextEditingController folderNameController = TextEditingController();
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Custom Folder'),
          content: TextField(
            controller: folderNameController,
            decoration: const InputDecoration(labelText: 'Folder Name'),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                String folderName = folderNameController.text;
                if (folderName.isNotEmpty) {
                  await DatabaseHelper.instance.addCustomFolder(folderName);
                  Navigator.of(context).pop();
                  (context as Element).reassemble();
                }
              },
              child: const Text('Add'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }
}

// Card Screen
class CardScreen extends StatefulWidget {
  final int folderId;

  const CardScreen({super.key, required this.folderId});

  @override
  _CardScreenState createState() => _CardScreenState();
}

class _CardScreenState extends State<CardScreen> {
  late Future<List<Map<String, dynamic>>> cards;

  @override
  void initState() {
    super.initState();
    cards = DatabaseHelper.instance.fetchCards(widget.folderId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cards'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              _addCard(context);
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: cards,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No Cards in this Folder'));
          }

          var cardList = snapshot.data!;
          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
            ),
            itemCount: cardList.length,
            itemBuilder: (context, index) {
              var card = cardList[index];
              return Card(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Image.network(card['image_url']),
                    Text(card['name']),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () async {
                            await DatabaseHelper.instance.removeCardFromFolder(card['id']);
                            setState(() {
                              // Reload the card list
                              cards = DatabaseHelper.instance.fetchCards(widget.folderId);
                            });
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () async {
                            await _updateCard(context, card);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Future<void> _addCard(BuildContext context) async {
    TextEditingController cardNameController = TextEditingController();
    TextEditingController cardSuitController = TextEditingController();
    TextEditingController cardImageUrlController = TextEditingController();

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Card'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: cardNameController,
                decoration: const InputDecoration(labelText: 'Card Name'),
              ),
              TextField(
                controller: cardSuitController,
                decoration: const InputDecoration(labelText: 'Card Suit'),
              ),
              TextField(
                controller: cardImageUrlController,
                decoration: const InputDecoration(labelText: 'Image URL'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () async {
                String name = cardNameController.text;
                String suit = cardSuitController.text;
                String imageUrl = cardImageUrlController.text;

                if (name.isNotEmpty && suit.isNotEmpty && imageUrl.isNotEmpty) {
                  await DatabaseHelper.instance.addCardToFolder(name, suit, imageUrl, widget.folderId);
                  setState(() {
                    // Refresh the card list
                    cards = DatabaseHelper.instance.fetchCards(widget.folderId);
                  });
                  Navigator.of(context).pop(); // Close the dialog
                }
              },
              child: const Text('Add'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _updateCard(BuildContext context, Map<String, dynamic> card) async {
    TextEditingController cardNameController = TextEditingController(text: card['name']);
    TextEditingController cardSuitController = TextEditingController(text: card['suit']);
    TextEditingController cardImageUrlController = TextEditingController(text: card['image_url']);

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Update Card'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: cardNameController,
                decoration: const InputDecoration(labelText: 'Card Name'),
              ),
              TextField(
                controller: cardSuitController,
                decoration: const InputDecoration(labelText: 'Card Suit'),
              ),
              TextField(
                controller: cardImageUrlController,
                decoration: const InputDecoration(labelText: 'Image URL'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () async {
                String name = cardNameController.text;
                String suit = cardSuitController.text;
                String imageUrl = cardImageUrlController.text;

                if (name.isNotEmpty && suit.isNotEmpty && imageUrl.isNotEmpty) {
                  await DatabaseHelper.instance.updateCard(card['id'], name, suit, imageUrl, card['folder_id']);
                  setState(() {
                    // Reload the card list
                    cards = DatabaseHelper.instance.fetchCards(widget.folderId);
                  });
                  Navigator.of(context).pop(); // Close the dialog
                }
              },
              child: const Text('Update'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }
}

