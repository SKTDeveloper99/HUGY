import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hugy/auth/firebase.dart';
import 'package:flutter/material.dart';
import 'package:hugy/screens/activities/meditation_page.dart';
import 'package:hugy/screens/contacts.dart';
import 'package:hugy/screens/discover.dart';
import 'package:hugy/screens/journal.dart';
import 'package:hugy/screens/profile.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int coins = 0;

  @override
  void initState() {
    super.initState();
    // getCoins();
  }

  Widget userPanel() {
    return InkWell(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (ctx) => ProfilePage()));
      },
      child: Container(
        height: 30,
        child: Row(
          children: [
            CircleAvatar(
              radius: 15,
              backgroundImage: NetworkImage(
                  "https://www.pngitem.com/pimgs/m/146-1468479_my-profile-icon-blank-profile-picture-circle-hd.png"),
            ),
            SizedBox(width: 10),
            Text(FirebaseAuth.instance.currentUser!.email!),
            Spacer(),
            Icon(
              Icons.money,
              color: Colors.yellow,
            ),
            Text("$coins"),
          ],
        ),
      ),
    );
  }

  Widget dashPanel() {
    return GridView(
      shrinkWrap: true,
      padding: EdgeInsets.all(20),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        crossAxisCount: 2,
      ),
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.blue,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.chat),
              TextButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (ctx) => ContactsPage()));
                  },
                  child: Text("Chat with AI"))
            ],
          ),
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.red,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.book),
              TextButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (ctx) => JournalPage()));
                  },
                  child: Text("Add new journal entry"))
            ],
          ),
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.green,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.chat),
              TextButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (ctx) => MeditationPage()));
                  },
                  child: Text("Meditate"))
            ],
          ),
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.green,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.chat),
              TextButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (ctx) => DiscoverPage()));
                  },
                  child: Text("Recommendations"))
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    AuthService().getCoins().then((value) {
      setState(() {
        coins = value;
      });
    });
    return SafeArea(
      child: Scaffold(
        body: Container(
          padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
          child: Column(
            children: [
              userPanel(),
              SizedBox(height: 30),
              Expanded(
                child: dashPanel(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
