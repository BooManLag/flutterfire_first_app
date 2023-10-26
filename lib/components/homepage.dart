import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'add_todo_page.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required String title});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter To-Do List'),
      ),
      body: StreamBuilder(
        // Change #1: Adding StreamBuilder to listen to real-time updates from Firestore
        stream: FirebaseFirestore.instance.collection('todos').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }

          // Change #2: Dynamically creating a list of todo items from Firestore
          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data() as Map<String, dynamic>;
              var yourListTile = ListTile(
                title: Text(data['title']),
                subtitle: Text(data['isCompleted'] ? 'Done' : 'Not Done'),
                trailing: IconButton(
                  icon: Icon(data['isCompleted']
                      ? Icons.check_box
                      : Icons.check_box_outline_blank),
                  onPressed: () {
                    FirebaseFirestore.instance
                        .collection('todos')
                        .doc(document.id)
                        .update({'isCompleted': !data['isCompleted']});
                  },
                ),
              );

              return data['isCompleted']
                  ? Dismissible(
                      key: Key(document.id),
                      background: Container(color: Colors.red),
                      onDismissed: (direction) {
                        FirebaseFirestore.instance
                            .collection('todos')
                            .doc(document.id)
                            .delete();
                      },
                      child: yourListTile,
                    )
                  : yourListTile;
            }).toList(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddTodoPage()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
