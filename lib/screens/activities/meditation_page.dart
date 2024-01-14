import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hugy/main.dart';
import 'package:hugy/screens/home.dart';

class MeditationPage extends StatefulWidget {
  const MeditationPage({super.key});

  @override
  State<MeditationPage> createState() => _MeditationPageState();
}

class _MeditationPageState extends State<MeditationPage> {
  Timer? _timer;

  int _seconds = 0;
  final int max_seconds = 60 * 60 * 24;

  String formatTime(int time) {
    int hours = time ~/ 3600;
    int minutes = (time - hours * 3600) ~/ 60;
    int seconds = time - hours * 3600 - minutes * 60;
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  void startTimer() {}
  void stopTimer() {}
  void resetTimer() {}

  Widget buildClock() {
    return Container(
      child: Text(
        '${formatTime(_seconds)}',
        style: TextStyle(fontSize: 60),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(),
            body: Center(
              child: Container(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  buildClock(),
                  ElevatedButton(
                      onPressed: () {}, child: Text("Start Meditation"))
                ],
              )),
            )));
  }
}
