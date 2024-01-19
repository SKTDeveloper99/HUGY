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
  List<Log> logs = [];
  String truncate(String data) {
    if (data.length > 27) {
      return data.substring(0, 27);
    } else {
      return data;
    }
  }

  void initState() {
    super.initState();
    initializeDateFormatting();
  }

  Widget noteCard(Log log) {
    return Container(
      padding: EdgeInsets.all(10),
      child: ListTile(
        title: Text(truncate(log.title)),
        subtitle: Text(truncate(log.content)),
        onTap: () {
          showDialog(
              context: context,
              builder: (context) => AlertDialog(
                    title: Text(log.title),
                    content: Text(log.content),
                    actions: [
                      TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text("OK"))
                    ],
                  ));
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Journal"),
      ),
      body: FutureBuilder<Object>(
          future: LogService().getLogs(),
          builder: (context, snapshot) {
            return Container(child: PageView.builder(
              // PAGEVIEW STARTS HERE
              itemBuilder: (context, index) {
                if (snapshot.hasData && snapshot.data != null) {
                  logs = snapshot.data as List<Log>;
                } else {
                  return Container(
                      width: 200,
                      height: 200,
                      child: Column(
                        children: [
                          Text("No data"),
                        ],
                      ));
                }
                return noteCard(logs[index]);
              },
            ));
          }),
    );
  }

  void createNote() async {
    var timeCreated = DateTime.now();
    var title = DateFormat('dd MM yyyy').format(timeCreated);
    var id =
        title.hashCode ^ timeCreated.hashCode ^ logController.text.hashCode;

    var log = Log(
        id: id.toString(),
        title: title,
        content: logController.text,
        timeCreated: timeCreated);

    await LogService().uploadLog(log);

    setState(() {
      logController.clear();
    });
  }
}
