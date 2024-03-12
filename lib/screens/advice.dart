import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hugy/api/nlp.dart';
import 'package:hugy/models/task.dart';

class DiscoverPage extends StatefulWidget {
  const DiscoverPage({super.key});

  @override
  State<DiscoverPage> createState() => _DiscoverPageState();
}

class _DiscoverPageState extends State<DiscoverPage> {
  @override
  Widget build(BuildContext context) {
    Future<void> addToTasks(Task task) async {
      final user = FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid);

      final querySnapshot = await user
          .collection('tasks')
          .where('title', isEqualTo: task.title)
          .get();
      if (querySnapshot.docs.isEmpty) {
        await user.collection('tasks').add(task.toJson());
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Recommendations"),
      ),
      body: Container(
          child: FutureBuilder<List<String>>(
              future: getActivity(),
              builder: (context, snapshot) {
                if (snapshot.hasData &&
                    snapshot.data != null &&
                    snapshot.data!.isNotEmpty) {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Card(
                        child: ListTile(
                          onTap: () {
                            Task task = Task(
                                title: snapshot.data![index], completed: false);
                            addToTasks(task);
                          },
                          contentPadding: const EdgeInsets.all(10),
                          title: Text(snapshot.data![index]),
                        ),
                      );
                    },
                  );
                }

                return const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      CircularProgressIndicator(),
                      Text("Loading recommendations..."),
                      SizedBox(height: 10),
                      CheckBackLater(),
                    ],
                  ),
                );
              })),
    );
  }
}

class CheckBackLater extends StatelessWidget {
  const CheckBackLater({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text("Check back later if recommendations don't load."),
    );
  }
}
