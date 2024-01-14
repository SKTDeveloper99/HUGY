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

  String twoDigits(int n) => n.toString().padLeft(2, "0");

  int max_seconds = 60 * 2;
  Duration duration = Duration();

  int _seconds = 0;
  int _minutes = 0;
  int _hours = 0;

  @override
  void initState() {
    super.initState();
    duration = Duration(seconds: max_seconds);
    _seconds = duration.inSeconds;
    _minutes = duration.inMinutes;
    _hours = duration.inHours;
  }

  @override
  void dispose() {
    stopTimer();
    super.dispose();
  }

  void updateTimer() {
    setState(() {
      max_seconds--;
      duration = Duration(seconds: max_seconds);

      _seconds = duration.inSeconds;
      _minutes = duration.inMinutes;
      _hours = duration.inHours;
    });
  }

  void startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (_) {
      updateTimer();
    });
  }

  void stopTimer() {
    // cancel the timer
    if (_timer != null) {
      _timer!.cancel();
    }
  }

  // set the timer to zero seconds
  void resetTimer() {
    setState(() {
      max_seconds = 60 * 2;
      duration = Duration(seconds: max_seconds);
      _seconds = duration.inSeconds;
      _minutes = duration.inMinutes;
      _hours = duration.inHours;
    });
  }

  Widget buildTimeSlot(int time) {
    return Container(
      color: Colors.white,
      width: 50,
      height: 50,
      child: Card(
        child: Center(
          child: Text(
            twoDigits(time),
            style: TextStyle(fontSize: 24),
          ),
        ),
      ),
    );
  }

  Widget buildClock() {
    return SizedBox(
        width: 200,
        height: 200,
        child: Stack(fit: StackFit.expand, children: [
          CircularProgressIndicator(
            value: duration.inSeconds / max_seconds,
            strokeWidth: 10,
          ),
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                buildTimeSlot(_hours),
                buildTimeSlot(_minutes),
                buildTimeSlot(_seconds),
              ],
            ),
          )
        ]));
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                          onPressed: () {
                            setState(() => startTimer());
                          },
                          child: Text("Start")),
                      ElevatedButton(
                        onPressed: () => stopTimer(),
                        child: Text("Stop"),
                      ),
                      ElevatedButton(
                        onPressed: () => resetTimer(),
                        child: Text("Reset"),
                      ),
                    ],
                  ),
                ],
              )),
            )));
  }
}
