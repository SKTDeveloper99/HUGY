import 'package:flutter/material.dart';
import 'package:hugy/screens/dashboard.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hugy/screens/registration.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Future.delayed(Duration(seconds: 3), () {
      setState(() {
        FirebaseAuth.instance.authStateChanges().listen((User? user) {
          if (user == null) {
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const Registration()));
          } else {
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const Dashboard()));
          }
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
              Colors.blue,
              Colors.red,
            ])),
        child: Center(
          child: Text(
            "Hugy",
            style: TextStyle(fontSize: 50),
          ),
        ),
      ),
    );
  }
}
