import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hugy/api/nlp.dart';

class DiscoverPage extends StatefulWidget {
  const DiscoverPage({super.key});

  @override
  State<DiscoverPage> createState() => _DiscoverPageState();
}

class _DiscoverPageState extends State<DiscoverPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Recommendations"),
      ),
      body: Container(
          child: FutureBuilder<List<String>>(
              future: getActivity(),
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data != null) {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Card(
                        child: ListTile(
                          contentPadding: EdgeInsets.all(10),
                          title: Text(snapshot.data![index]),
                        ),
                      );
                    },
                  );
                }

                return const Center(child: CircularProgressIndicator());
              })),
    );
  }
}
