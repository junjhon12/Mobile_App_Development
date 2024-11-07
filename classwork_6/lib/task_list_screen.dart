import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class Task {
  String id;
  String name;
  bool isCompleted;

  Task({required this.id, required this.name, this.isCompleted = false});

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'isCompleted': isCompleted,
      };

  static Task fromJson(Map<String, dynamic> json, String id) {
    return Task(
      id: id,
      name: json['name'],
      isCompleted: json['isCompleted'] ?? false,
    );
  }
}

class TaskListScreen extends StatefulWidget {
  @override
  _TaskListScreenState createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  final DatabaseReference _tasksRef = FirebaseDatabase.instance.ref().child('tasks');
  final TextEditingController _taskController = TextEditingController();
  List<Task> _tasks = [];

  @override
  void initState() {
    super.initState();
    _tasksRef.onValue.listen((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;
      if (data != null) {
        setState(() {
          _tasks = data.entries
              .map((entry) => Task.fromJson(Map<String, dynamic>.from(entry.value), entry.key))
              .toList();
        });
      }
    });
  }

  Future<void> _addTask() async {
    if (_taskController.text.isEmpty) return;

    String taskId = _tasksRef.push().key!;
    await _tasksRef.child(taskId).set(Task(id: taskId, name: _taskController.text).toJson());
    _taskController.clear();
  }

  Future<void> _deleteTask(String id) async {
    await _tasksRef.child(id).remove();
  }

  Future<void> _toggleComplete(String id, bool currentStatus) async {
    await _tasksRef.child(id).update({'isCompleted': !currentStatus});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Tasks')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _taskController,
                    decoration: InputDecoration(hintText: 'Enter a task'),
                  ),
                ),
                IconButton(
                  onPressed: _addTask,
                  icon: Icon(Icons.add),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _tasks.length,
              itemBuilder: (context, index) {
                final task = _tasks[index];
                return ListTile(
                  title: Text(
                    task.name,
                    style: TextStyle(
                      decoration: task.isCompleted
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                    ),
                  ),
                  leading: Checkbox(
                    value: task.isCompleted,
                    onChanged: (_) => _toggleComplete(task.id, task.isCompleted),
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () => _deleteTask(task.id),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
