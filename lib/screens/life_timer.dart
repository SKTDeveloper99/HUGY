import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hugy/auth/firebase.dart';

class LifeTimer extends StatefulWidget {
  const LifeTimer({super.key});

  @override
  State<LifeTimer> createState() => _LifeTimerState();
}

class _LifeTimerState extends State<LifeTimer> {
  Future<DateTime?> getUserBirthday() async {
    final user = await FirebaseAuth.instance.currentUser;
    final userDoc = await FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get();

    try {
      return userDoc.get("birthday");
    } catch (e) {
      return null;
    }
  }

  DateTime? birthday = null;

  @override
  void initState() {
    super.initState();
    getUserBirthday().then((value) => setState(() {
          birthday = value;
        }));

    if (birthday != null) {
      buildDatePicker();
    }
  }

  Future<void> addBirthday(DateTime birthday) async {
    final user = FirebaseAuth.instance.currentUser;
    await FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .update({"birthday": birthday});
  }

  Widget buildDatePicker() {
    return SizedBox(
      width: 200,
      height: 200,
      child: Center(
        child: ElevatedButton(
          onPressed: () async {
            final DateTime? picked = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(1900),
              lastDate: DateTime.now(),
            );
            if (picked != null) {
              setState(() {
                birthday = picked;
              });
              addBirthday(picked);
            }
          },
          child: const Text('Select your birthday'),
        ),
      ),
    );
  }

  Timer? _timer;
  ValueNotifier<int> timeLeft = ValueNotifier<int>(0);
  Duration difference = const Duration();

  String twoDigits(int n) => n.toString().padLeft(2, "0");

  // construct time since we were born

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      difference = DateTime.now().difference(birthday!);
    });
  }

  void stopTimer() {
    if (!mounted) return;

    // cancel the timer
    _timer?.cancel();
  }

  Widget buildClock() {
    return SizedBox(
        width: 200,
        height: 200,
        child: Stack(fit: StackFit.expand, children: [
          Center(
            child: Text(
              // formatted time difference between now and our birthday
              "${twoDigits(difference.inDays)}:${twoDigits(difference.inHours.remainder(24))}:${twoDigits(difference.inMinutes.remainder(60))}:${twoDigits(difference.inSeconds.remainder(60))}",
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
                  birthday != null ? buildClock() : buildDatePicker(),
                ],
              )),
            )));
  }
}
