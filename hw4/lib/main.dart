import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: SplashScreen(),
    );
  }
}

// Splash Screen
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    });

    return const Scaffold(
      body: Center(
        child: Text(
          'Chatboards Splash Page',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

// Login Page
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  void _login() async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      if (userCredential.user != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MessageBoardPage()),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to login: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            ElevatedButton(onPressed: _login, child: const Text('Login')),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const RegistrationPage()),
                );
              },
              child: const Text('Don\'t have an account? Register here'),
            ),
          ],
        ),
      ),
    );
  }
}

// Registration Page
class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();

  void _register() async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      if (userCredential.user != null) {
        await _firestore.collection('users').doc(userCredential.user!.uid).set({
          'firstName': _firstNameController.text.trim(),
          'lastName': _lastNameController.text.trim(),
          'email': _emailController.text.trim(),
          'role': 'user',
          'registrationDateTime': DateTime.now(),
        });

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MessageBoardPage()),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to register: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _firstNameController,
              decoration: const InputDecoration(labelText: 'First Name'),
            ),
            TextField(
              controller: _lastNameController,
              decoration: const InputDecoration(labelText: 'Last Name'),
            ),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            ElevatedButton(onPressed: _register, child: const Text('Register')),
          ],
        ),
      ),
    );
  }
}

// Message Board Page
class MessageBoardPage extends StatelessWidget {
  final List<Map<String, String>> boards = [
    {'name': 'Board 1', 'icon': '📚'},
    {'name': 'Board 2', 'icon': '🎨'},
    {'name': 'Board 3', 'icon': '🗣️'},
  ];

  const MessageBoardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Message Boards')),
      drawer: Drawer(
        child: ListView(
          children: [
            ListTile(
              title: const Text('Message Boards'),
              onTap: () {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MessageBoardPage()));
              },
            ),
            ListTile(
              title: const Text('Profile'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfilePage()));
              },
            ),
            ListTile(
              title: const Text('Settings'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingsPage()));
              },
            ),
          ],
        ),
      ),
      body: ListView.builder(
        itemCount: boards.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: Image.asset(boards[index]['icon']!),
            title: Text(boards[index]['name']!),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatWindow(boardName: boards[index]['name']!),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

// Chat Window
class ChatWindow extends StatelessWidget {
  final String boardName;

  const ChatWindow({super.key, required this.boardName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(boardName)),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('messageBoards')
            .doc(boardName)
            .collection('messages')
            .orderBy('datetime')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No messages yet.'));
          }
          final messages = snapshot.data!.docs;
          return ListView.builder(
            itemCount: messages.length,
            itemBuilder: (context, index) {
              var message = messages[index];
              return ListTile(
                title: Text(message['username']),
                subtitle: Text(message['text']),
                trailing: Text(message['datetime'].toDate().toString()),
              );
            },
          );
        },
      ),
    );
  }
}

// Profile Page
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: const Center(child: Text('Profile Page - Edit user details here.')),
    );
  }
}

// Settings Page
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            await FirebaseAuth.instance.signOut();
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const LoginPage()),
            );
          },
          child: const Text('Logout'),
        ),
      ),
    );
  }
}
