// todo_controller.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/todo_model.dart';

class TodoController {
  final CollectionReference _todosCollection = FirebaseFirestore.instance.collection('todos');

  // Create
  Future<void> addTodo(Todo todo) async {
    await _todosCollection.add({
      'title': todo.title,
      'isCompleted': todo.isCompleted,
    });
  }

  // Read
  Stream<QuerySnapshot> readTodos() {
    return _todosCollection.snapshots();
  }

  // Update
  Future<void> updateTodo(Todo todo) async {
    await _todosCollection.doc(todo.id).update({
      'title': todo.title,
      'isCompleted': todo.isCompleted,
    });
  }

  // Delete
  Future<void> deleteTodo(String id) async {
    await _todosCollection.doc(id).delete();
  }
}
