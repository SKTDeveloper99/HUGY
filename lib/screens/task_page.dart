import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hugy/models/task.dart';

class TaskPage extends StatefulWidget {
  const TaskPage({super.key});

  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Tasks"),
        centerTitle: true,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection('tasks')
            .snapshots()
            .asBroadcastStream(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (BuildContext context, int index) {
                Task task = Task.fromJson(
                    snapshot.data!.docs[index].data() as Map<String, dynamic>);

                print(task);
                return Card(
                  child: Dismissible(
                    key: Key(snapshot.data!.docs[index].id),
                    background: Container(
                      color: Colors.green,
                      child: const Icon(Icons.check, color: Colors.white),
                    ),
                    secondaryBackground: Container(
                      color: Colors.red,
                      child: const Icon(Icons.delete, color: Colors.white),
                    ),
                    onDismissed: (direction) async {
                      if (direction == DismissDirection.endToStart) {
                        FirebaseFirestore.instance
                            .collection('users')
                            .doc(FirebaseAuth.instance.currentUser!.uid)
                            .collection('tasks')
                            .doc(snapshot.data!.docs[index].id)
                            .delete();
                      }
                      if (direction == DismissDirection.startToEnd) {
                        FirebaseFirestore.instance
                            .collection('users')
                            .doc(FirebaseAuth.instance.currentUser!.uid)
                            .collection('tasks')
                            .doc(snapshot.data!.docs[index].id)
                            .delete();

                        // ADD USER COINS
                        await FirebaseFirestore.instance
                            .collection('users')
                            .doc(FirebaseAuth.instance.currentUser!.uid)
                            .update({'coins': FieldValue.increment(50)});

                        if (!mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Good job! You earned 50 coins!'),
                          ),
                        );
                      }
                    },
                    child: ListTile(
                        onTap: () {
                          FirebaseFirestore.instance
                              .collection('users')
                              .doc(FirebaseAuth.instance.currentUser!.uid)
                              .collection('tasks')
                              .get()
                              .asStream();
                        },
                        contentPadding: const EdgeInsets.all(10),
                        title: Text(snapshot.data!.docs[index]['title']),
                        trailing: Checkbox(
                          value: snapshot.data!.docs[index]['completed'],
                          onChanged: (value) {
                            FirebaseFirestore.instance
                                .collection('users')
                                .doc(FirebaseAuth.instance.currentUser!.uid)
                                .collection('tasks')
                                .doc(snapshot.data!.docs[index].id)
                                .update({'completed': value});
                          },
                        )),
                  ),
                );
              },
            );
          }

          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
