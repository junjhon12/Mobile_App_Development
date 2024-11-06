import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Firebase Auth Demo',
      home: AuthenticationScreen(),
    );
  }
}

// Authentication Screen with Registration and Sign-In
class AuthenticationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Firebase Auth Demo'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RegisterEmailSection(),
            EmailPasswordForm(),
          ],
        ),
      ),
    );
  }
}

// AuthService class to manage Firebase Authentication
class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> registerWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<User?> signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  User? get currentUser {
    return _auth.currentUser;
  }

  Future<void> changePassword(String newPassword) async {
    await _auth.currentUser?.updatePassword(newPassword);
  }
}

// Widget for User Registration
class RegisterEmailSection extends StatefulWidget {
  @override
  _RegisterEmailSectionState createState() => _RegisterEmailSectionState();
}

class _RegisterEmailSectionState extends State<RegisterEmailSection> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthService _authService = AuthService();
  bool _success = false;
  String _message = "";

  void _register() async {
    User? user = await _authService.registerWithEmailAndPassword(
      _emailController.text,
      _passwordController.text,
    );
    setState(() {
      _success = user != null;
      _message = _success ? "Registration successful" : "Registration failed";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        TextFormField(
          controller: _emailController,
          decoration: InputDecoration(labelText: 'Email'),
        ),
        TextFormField(
          controller: _passwordController,
          decoration: InputDecoration(labelText: 'Password'),
        ),
        ElevatedButton(
          onPressed: _register,
          child: Text('Register'),
        ),
        Text(
          _message,
          style: TextStyle(color: _success ? Colors.green : Colors.red),
        ),
      ],
    );
  }
}

// Widget for User Sign-In
class EmailPasswordForm extends StatefulWidget {
  @override
  _EmailPasswordFormState createState() => _EmailPasswordFormState();
}

class _EmailPasswordFormState extends State<EmailPasswordForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthService _authService = AuthService();
  bool _success = false;
  String _message = "";

  void _signIn() async {
    User? user = await _authService.signInWithEmailAndPassword(
      _emailController.text,
      _passwordController.text,
    );
    setState(() {
      _success = user != null;
      _message = _success ? "Sign-in successful" : "Sign-in failed";
    });
    if (_success) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => ProfileScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        TextFormField(
          controller: _emailController,
          decoration: InputDecoration(labelText: 'Email'),
        ),
        TextFormField(
          controller: _passwordController,
          decoration: InputDecoration(labelText: 'Password'),
        ),
        ElevatedButton(
          onPressed: _signIn,
          child: Text('Sign In'),
        ),
        Text(
          _message,
          style: TextStyle(color: _success ? Colors.green : Colors.red),
        ),
      ],
    );
  }
}

// Profile Screen with Email Display, Password Change, and Logout
class ProfileScreen extends StatelessWidget {
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await _authService.signOut();
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => AuthenticationScreen()),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("Email: ${_authService.currentUser?.email ?? 'No user'}"),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                // Functionality to change the password (for example purposes, a new password is hardcoded here)
                await _authService.changePassword("newPassword123");
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Password changed successfully")),
                );
              },
              child: Text("Change Password"),
            ),
          ],
        ),
      ),
    );
  }
}
