import 'package:flutter/material.dart';
import 'package:hugy/models/log.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class JournalPage extends StatefulWidget {
  const JournalPage({super.key});

  @override
  State<JournalPage> createState() => _JournalPageState();
}

class _JournalPageState extends State<JournalPage> {
  TextEditingController logController = TextEditingController();

  String truncate(String data) {
    if (data.length > 27) {
      return data.substring(0, 27);
    } else {
      return data;
    }
  }

  Widget lastFiveList() {
    return StreamBuilder(
        stream: LogService().getLastFiveLogs(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return snapshot.hasData && snapshot.data.docs.length > 0
              ? ListView.builder(
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (BuildContext context, int index) {
                    var entry = Log.fromMap(snapshot.data.docs[index].data());
                    return ListTile(
                      title: Text(entry.getTitle()),
                      subtitle: Text(truncate(entry.content)),
                      trailing: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          LogService().deleteLog(entry.id);
                        },
                      ),
                    );
                  },
                )
              : Center(
                  child: Text("No Logs found"),
                );
        });
  }

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
                  controller: logController,
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
              ElevatedButton(
                  onPressed: () async {
                    var timeCreated = DateTime.now();
                    var title = DateFormat('dd MM yyyy').format(timeCreated);
                    var id = title.hashCode ^
                        timeCreated.hashCode ^
                        logController.text.hashCode;

                    var log = Log(
                        id: id.toString(),
                        title: title,
                        content: logController.text,
                        timeCreated: timeCreated);

                    await LogService().uploadLog(log);

                    setState(() {
                      logController.clear();
                    });
                  },
                  child: Text("Submit")),
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
                        child: lastFiveList(),
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
