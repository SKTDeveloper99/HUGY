import 'package:flutter/material.dart';

class JournalPage extends StatefulWidget {
  const JournalPage({super.key});

  @override
  State<JournalPage> createState() => _JournalPageState();
}

class _JournalPageState extends State<JournalPage> {
  // dummy data

  var journals = [
    {"name": "Journal 1", "content": "This is journal 1"},
    {"name": "Journal 2", "content": "This is journal 2"},
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Journal"),
        ),
        body: Container(
            child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Color.fromARGB(255, 81, 81, 81),
                ),
                height: 300,
                child: TextField(
                  textAlign: TextAlign.start,
                  textAlignVertical: TextAlignVertical.top,
                  maxLines: null,
                  minLines: null,
                  expands: true,
                  style: TextStyle(fontSize: 20),
                  decoration: InputDecoration(
                    hintText: "What's on your mind?",
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Color.fromARGB(255, 57, 57, 57),
                  ),
                  child: Column(
                    children: [
                      Container(
                          child: TextField(
                        decoration: InputDecoration(
                          hintText: "Search",
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      )),
                      Expanded(
                        child: ListView.builder(
                            itemCount: journals.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                title: Text(journals[index]["name"]!),
                                subtitle: Text(journals[index]["content"]!),
                              );
                            }),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        )));
  }
}
