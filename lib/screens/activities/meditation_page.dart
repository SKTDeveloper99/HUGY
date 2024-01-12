import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_timer_countdown/flutter_timer_countdown.dart';
import 'package:hugy/main.dart';
import 'package:hugy/screens/home.dart';

class MeditationPage extends StatefulWidget {
  const MeditationPage({super.key});

  @override
  State<MeditationPage> createState() => _MeditationPageState();
}

class _MeditationPageState extends State<MeditationPage> {
  Timer? _timer;
  Duration _clockTime = Duration(seconds: 0);

  int _seconds = 0;
  int _minutes = 1;
  int _hours = 0;

  String formatTime(int time) {
    return time.toString().padLeft(2, '0');
  }

  Widget buildClock() {
    return Container(
      child: TimerCountdown(
        format: CountDownTimerFormat.hoursMinutesSeconds,
        endTime: DateTime.now().add(
          Duration(
            days: 0,
            hours: _hours,
            minutes: _minutes,
            seconds: _seconds,
          ),
        ),
        onEnd: () {
          // show complete dialog
          print("end");
        },
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
