import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task Manager',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FirebaseAuth.instance.currentUser == null
          ? LoginScreen()
          : TaskListScreen(),
    );
  }
}

// Login Screen
class LoginScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> signIn(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => TaskListScreen()));
    } catch (e) {
      print('Login failed: $e');
    }
  }

  Future<void> signUp(BuildContext context) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => TaskListScreen()));
    } catch (e) {
      print('Signup failed: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => signIn(context),
              child: Text('Login'),
            ),
            ElevatedButton(
              onPressed: () => signUp(context),
              child: Text('Sign Up'),
            ),
          ],
        ),
      ),
    );
  }
}

// Task List Screen
class TaskListScreen extends StatefulWidget {
  @override
  _TaskListScreenState createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  final TextEditingController taskController = TextEditingController();
  final CollectionReference tasksCollection = FirebaseFirestore.instance
      .collection('tasks')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection('userTasks');

  void addTask() {
    if (taskController.text.isNotEmpty) {
      tasksCollection.add({
        'name': taskController.text,
        'completed': false,
        'priority': 'Medium',
      });
      taskController.clear();
    }
  }

  void updateTask(DocumentSnapshot task, bool completed) {
    tasksCollection.doc(task.id).update({'completed': completed});
  }

  void deleteTask(DocumentSnapshot task) {
    tasksCollection.doc(task.id).delete();
  }

  void signOut() {
    FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => LoginScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Task Manager'),
        actions: [IconButton(onPressed: signOut, icon: Icon(Icons.logout))],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: taskController,
                    decoration: InputDecoration(hintText: 'Enter task'),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: addTask,
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: tasksCollection.snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }
                return ListView(
                  children: snapshot.data!.docs.map((task) {
                    return ListTile(
                      title: Text(task['name']),
                      leading: Checkbox(
                        value: task['completed'],
                        onChanged: (bool? value) {
                          updateTask(task, value!);
                        },
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () => deleteTask(task),
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
