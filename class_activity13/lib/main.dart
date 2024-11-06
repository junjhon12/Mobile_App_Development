import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  // Ensures Flutter's bindings are initialized before using Firebase.
  WidgetsFlutterBinding.ensureInitialized();

  // Initializes Firebase with platform-specific options.
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Runs the app starting with the MyApp widget.
  runApp(MyApp());
}

// Main application widget.
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Firebase Auth Demo',
      home: AuthenticationScreen(), // Sets AuthenticationScreen as the home screen.
    );
  }
}

// Authentication screen that includes both registration and sign-in widgets.
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
            RegisterEmailSection(), // Widget for user registration.
            EmailPasswordForm(),    // Widget for user sign-in.
          ],
        ),
      ),
    );
  }
}

// Service class to manage Firebase Authentication functionality.
class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Registers a user with email and password.
  Future<User?> registerWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user; // Returns the registered user.
    } catch (e) {
      print(e.toString());
      return null; // Returns null if registration fails.
    }
  }

  // Signs in a user with email and password.
  Future<User?> signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user; // Returns the signed-in user.
    } catch (e) {
      print(e.toString());
      return null; // Returns null if sign-in fails.
    }
  }

  // Signs out the currently authenticated user.
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Getter for the currently authenticated user.
  User? get currentUser {
    return _auth.currentUser;
  }

  // Changes the password for the currently authenticated user.
  Future<void> changePassword(String newPassword) async {
    await _auth.currentUser?.updatePassword(newPassword);
  }
}

// Widget for user registration using email and password.
class RegisterEmailSection extends StatefulWidget {
  @override
  _RegisterEmailSectionState createState() => _RegisterEmailSectionState();
}

class _RegisterEmailSectionState extends State<RegisterEmailSection> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthService _authService = AuthService();
  bool _success = false; // Tracks registration success status.
  String _message = "";

  // Registers the user when called and updates success status.
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
          _message, // Displays registration status message.
          style: TextStyle(color: _success ? Colors.green : Colors.red),
        ),
      ],
    );
  }
}

// Widget for user sign-in using email and password.
class EmailPasswordForm extends StatefulWidget {
  @override
  _EmailPasswordFormState createState() => _EmailPasswordFormState();
}

class _EmailPasswordFormState extends State<EmailPasswordForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthService _authService = AuthService();
  bool _success = false; // Tracks sign-in success status.
  String _message = "";

  // Signs in the user when called and updates success status.
  void _signIn() async {
    User? user = await _authService.signInWithEmailAndPassword(
      _emailController.text,
      _passwordController.text,
    );
    setState(() {
      _success = user != null;
      _message = _success ? "Sign-in successful" : "Sign-in failed";
    });

    // Navigates to ProfileScreen if sign-in is successful.
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
          _message, // Displays sign-in status message.
          style: TextStyle(color: _success ? Colors.green : Colors.red),
        ),
      ],
    );
  }
}

// Profile screen displaying the user's email, with password change and logout options.
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
            // Logs out the user and navigates back to AuthenticationScreen.
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
            Text("Email: ${_authService.currentUser?.email ?? 'No user'}"), // Displays user email.
            SizedBox(height: 20),
            ElevatedButton(
              // Changes the user's password with a sample password.
              onPressed: () async {
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
