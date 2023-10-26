// add_todo_page.dart
import 'package:flutter/material.dart';
import '../controllers/todo_controller.dart';
import '../models/todo_model.dart';

class AddTodoPage extends StatelessWidget {
  final TodoController todoController = TodoController();
  final TextEditingController _controller = TextEditingController();

  AddTodoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Todo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: TextField(
          controller: _controller,
          decoration: const InputDecoration(
            labelText: 'What are you going to do?',
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (_controller.text.isNotEmpty) {
            await todoController.addTodo(
              Todo(
                id: '', // You can let Firestore auto-generate this
                title: _controller.text,
                isCompleted: false,
              ),
            );
            Navigator.pop(context); // Go back to the previous page
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
