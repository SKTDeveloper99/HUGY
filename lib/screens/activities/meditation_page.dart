import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hugy/auth/firebase.dart';

class MeditationPage extends StatefulWidget {
  const MeditationPage({super.key});

  @override
  State<MeditationPage> createState() => _MeditationPageState();
}

class _MeditationPageState extends State<MeditationPage> {
  Timer? _timer;
  ValueNotifier<int> timeLeft = ValueNotifier<int>(0);

  String twoDigits(int n) => n.toString().padLeft(2, "0");

  Duration duration = const Duration(minutes: 5);

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void updateTimer() {
    if (!mounted) return;

    setState(() {
      if (duration.inMinutes > 0) {
        duration = Duration(seconds: duration.inSeconds - 1);
      } else {
        stopTimer();
        AuthService().addCoins(100);
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: const Text("Meditation Complete!"),
                  content: const Text("You have earned 100 coins!"),
                  actions: [
                    TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text("OK"))
                  ],
                ));
      }
    });
  }

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      updateTimer();
    });
  }

  void stopTimer() {
    if (!mounted) return;

    // cancel the timer
    _timer?.cancel();
  }

  // set the timer to zero seconds
  void resetTimer() {
    setState(() {
      duration = const Duration(minutes: 5);
      // update the time slots, so they are displayed correctly
      // use math to ensure that values are wrapped
    });
  }

  Widget buildClock() {
    return SizedBox(
        width: 200,
        height: 200,
        child: Stack(fit: StackFit.expand, children: [
          Center(
            child: Text(
              "${twoDigits(duration.inHours.remainder(24))}:${twoDigits(duration.inMinutes.remainder(60))}:${twoDigits(duration.inSeconds.remainder(60))}",
              style: const TextStyle(fontSize: 24),
            ),
          ),
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
                  const SizedBox(height: 80),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                          onPressed: () async {
                            setState(() => startTimer());
                          },
                          child: const Text("Start")),
                      ElevatedButton(
                        onPressed: () => stopTimer(),
                        child: const Text("Stop"),
                      ),
                      ElevatedButton(
                        onPressed: () => resetTimer(),
                        child: const Text("Reset"),
                      ),
                    ],
                  ),
                ],
              )),
            )));
  }
}
