import 'package:flutter/material.dart';
import 'task.dart';

// The main function serves as the entry point for the Flutter application
void main() {
  runApp(TaskManagerApp());
}

// This widget represents the main application
class TaskManagerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task Manager', // Title of the app
      home: TaskListScreen(), // Setting the home screen of the app
    );
  }
}

// StatefulWidget to manage the state of the task list
class TaskListScreen extends StatefulWidget {
  @override
  _TaskListScreenState createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  // List to hold the tasks
  List<Task> tasks = [];
  // Text controller to manage the input field
  final TextEditingController taskController = TextEditingController();
  // Default selected priority for new tasks
  String selectedPriority = 'Low';

  // Method to add a new task
  void addTask() {
    // Check if the input field is not empty
    if (taskController.text.isNotEmpty) {
      setState(() {
        // Add the new task to the list with the selected priority
        tasks.add(Task(name: taskController.text, priority: selectedPriority));
        taskController.clear(); // Clear the input field after adding
      });
    }
  }

  // Method to toggle task completion status
  void toggleTaskCompletion(int index) {
    setState(() {
      // Toggle the isCompleted status of the task at the given index
      tasks[index].isCompleted = !tasks[index].isCompleted;
    });
  }

  // Method to delete a task
  void deleteTask(int index) {
    setState(() {
      // Remove the task at the given index from the list
      tasks.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    // Sort tasks by priority before displaying
    tasks.sort((a, b) {
      // Define the order of priority levels
      List<String> priorityLevels = ['Low', 'Medium', 'High'];
      // Compare the priority levels to determine order
      return priorityLevels.indexOf(a.priority).compareTo(priorityLevels.indexOf(b.priority));
    });

    return Scaffold(
      appBar: AppBar(title: Text('Task Manager')), // App bar with title
      body: Column(
        children: [
          // Input area for adding tasks
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: taskController, // Connect the text field to the controller
                    decoration: InputDecoration(labelText: 'Task Name'), // Label for the text field
                  ),
                ),
                // Dropdown to select task priority
                DropdownButton<String>(
                  value: selectedPriority, // Current selected value
                  items: <String>['Low', 'Medium', 'High'].map((String value) {
                    // Create dropdown menu items
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value), // Display the priority value
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      // Update the selected priority when user selects a new value
                      selectedPriority = newValue!;
                    });
                  },
                ),
                // Button to add the task
                IconButton(
                  icon: Icon(Icons.add), // Icon for adding a task
                  onPressed: addTask, // Call addTask method on press
                ),
              ],
            ),
          ),
          // ListView to display the list of tasks
          Expanded(
            child: ListView.builder(
              itemCount: tasks.length, // Number of tasks to display
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(tasks[index].name), // Display the task name
                  leading: Checkbox(
                    value: tasks[index].isCompleted, // Show checkbox based on completion status
                    onChanged: (value) => toggleTaskCompletion(index), // Toggle completion status on checkbox change
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.delete), // Icon for deleting a task
                    onPressed: () => deleteTask(index), // Call deleteTask method on press
                  ),
                  subtitle: Text('Priority: ${tasks[index].priority}'), // Display task priority
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
