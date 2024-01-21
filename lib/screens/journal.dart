import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hugy/models/log.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class NoteEditor extends StatefulWidget {
  NoteEditor({super.key, required this.log});
  Log log;

  @override
  State<NoteEditor> createState() => _NoteEditorState();
}

class _NoteEditorState extends State<NoteEditor> {
  TextEditingController logController = TextEditingController();
  Timer? _debounce;

  @override
  Widget build(BuildContext context) {
    logController.addListener(() {
      if (_debounce?.isActive ?? false) _debounce?.cancel();
      _debounce = Timer(const Duration(milliseconds: 500), () async {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Saving..."),
        ));
        await LogService().uploadLog(Log(
            title: DateFormat('dd MM yyyy').format(DateTime.now()),
            content: logController.text,
            timeCreated: DateTime.now()));
      });
    });
    return Scaffold(
      appBar: AppBar(
        title: Text("Create a log"),
      ),
      body: Container(
        child: TextField(
          controller: logController,
          maxLines: 100,
          decoration: InputDecoration(
            hintText: "Write your log here",
            border: OutlineInputBorder(),
          ),
        ),
      ),
    );
  }
}

class JournalPage extends StatefulWidget {
  const JournalPage({super.key});

  @override
  State<JournalPage> createState() => _JournalPageState();
}

class _JournalPageState extends State<JournalPage> {
  PageController pageController = PageController();

  DateTime selectedDate = DateTime.now();

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
    pageController = PageController(initialPage: 0, viewportFraction: 0.8);
  }

  Widget noteCard(Log log, String id) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => NoteEditor(
                        log: log,
                      )));
        },
        child: Container(
            width: 400,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(32),
              image: DecorationImage(
                  opacity: 0.8,
                  image: AssetImage("assets/circles.png"),
                  fit: BoxFit.cover),
              boxShadow: [
                BoxShadow(
                  blurStyle: BlurStyle.outer,
                  blurRadius: 20,
                  color: Colors.black.withOpacity(0.25),
                ),
              ],
            ),
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      log.title,
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      icon: Icon(Icons.delete_outline),
                      onPressed: () async {
                        await LogService().deleteLog(id);
                        setState(() {});
                      },
                    )
                  ],
                ),
                Text(truncate(log.content),
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.w300)),
              ],
            )),
      ),
    );
  }

  Widget carouselView(List<QueryDocumentSnapshot> logs, int index) {
    return AnimatedBuilder(
      animation: pageController,
      builder: (context, child) {
        double rotAmount = 0.0;

        rotAmount = index.toDouble() - (pageController.page ?? 0.0);
        rotAmount = (rotAmount * 0.188).clamp(-1, 1);

        return Center(
          child: Transform.rotate(
            angle: rotAmount,
            child: noteCard(Log.fromSnapshot(logs[index % logs.length]),
                logs[index % logs.length].id),
          ),
        );
      },
    );
  }

// MAIN VIEW
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add_outlined),
          backgroundColor:
              Theme.of(context).floatingActionButtonTheme.backgroundColor,
          onPressed: () {
            var log = Log(
                title: DateFormat('dd MM yyyy').format(DateTime.now()),
                content: "",
                timeCreated: DateTime.now());
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => NoteEditor(
                          log: log,
                        )));
          }),
      appBar: AppBar(
        title: Text("Journal"),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_month_outlined),
            onPressed: () async {
              DateTime? date = await showDatePicker(
                context: context,
                firstDate: DateTime(DateTime.now().year - 1),
                lastDate: DateTime.now(),
                initialDate: DateTime.now(),
              );

              if (date != null) {
                setState(() {
                  selectedDate = DateTime(date.year, date.month, date.day);
                });
              }
            },
          )
        ],
      ),
      body: Center(
        child: FutureBuilder<List<QueryDocumentSnapshot>>(
            future: LogService().getLogsByDate(selectedDate),
            builder: (context, snapshot) {
              return AspectRatio(
                aspectRatio: 0.8,
                child: Column(
                  children: [
                    Text(
                      DateFormat('dd MMMM yyyy').format(selectedDate),
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    Expanded(
                      child: Container(
                          child: PageView.builder(
                        controller: pageController,
                        physics: ClampingScrollPhysics(),
                        // PAGEVIEW STARTS HERE
                        itemBuilder: (context, index) {
                          if (snapshot.hasData &&
                              snapshot.data != null &&
                              snapshot.data?.isNotEmpty == true) {
                            return carouselView(snapshot.data!, index);
                          } else {
                            return Container(
                              width: 200,
                              height: 200,
                              child: Column(
                                children: [
                                  Text("No logs found"),
                                  TextButton(
                                    onPressed: () {
                                      var log = Log(
                                          title: DateFormat('dd MM yyyy')
                                              .format(DateTime.now()),
                                          content: "",
                                          timeCreated: DateTime.now());
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => NoteEditor(
                                                    log: log,
                                                  )));
                                    },
                                    child: Text("Create a log"),
                                  )
                                ],
                              ),
                            );
                          }
                        },
                      )),
                    ),
                  ],
                ),
              );
            }),
      ),
    );
  }
}
