import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hugy/auth/firebase.dart';
import 'package:hugy/screens/chat.dart';
import 'package:hugy/screens/contacts.dart';
import 'package:hugy/screens/discover.dart';
import 'package:hugy/screens/journal.dart';
import 'package:hugy/screens/profile.dart';
import 'package:hugy/screens/task_page.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late PageController _pageController;
  int currentDoor = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _pageController = PageController();
  }

  String getTime() {
    var now = DateTime.now();
    return now.hour.toString() + ":" + now.minute.toString();
  }

  Widget _buildDoor(String doorName, VoidCallback onTap) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        InkWell(
          onTap: onTap,
          child: AnimatedContainer(
            height: 300,
            width: 171,
            duration: Duration(milliseconds: 500),
            curve: Curves.ease,
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.fitHeight,
                image: AssetImage("assets/backgrounds/pixel_door.jpg"),
              ),
            ),
          ),
        ),
        Text(
          doorName,
          style: TextStyle(fontSize: 30),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // scaffold widget
    return Scaffold(
        key: _scaffoldKey,
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage("assets/backgrounds/sky2.jpg"),
            ),
          ),
          child: Column(
            children: [
              // app bar, no back button
              SafeArea(
                child: AppBar(
                  titleSpacing: 0,
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  // coins
                  leading: Container(
                    margin: EdgeInsets.only(left: 10, top: 10),
                    child: StreamBuilder<int>(
                        stream: AuthService().getCoins().asStream(),
                        builder: (context, snapshot) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Icon(Icons.star),
                              Text(
                                snapshot.data.toString(),
                                style: TextStyle(fontSize: 20),
                              ),
                            ],
                          );
                        }),
                  ),
                  actions: [
                    IconButton(
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return TaskPage();
                        }));
                      },
                      icon: Icon(Icons.add_task),
                      iconSize: 42,
                    )
                  ],
                ),
              ),
              Expanded(
                child: SizedBox(
                  child: PageView(
                    controller: _pageController,
                    onPageChanged: (int page) {
                      setState(() {
                        currentDoor = page;
                      });
                    },
                    children: [
                      _buildDoor("Contacts", () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return ContactsPage();
                        }));
                      }),
                      _buildDoor("Missions", () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return DiscoverPage();
                        }));
                      }),
                      _buildDoor("Me", () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return ProfilePage();
                        }));
                      }),
                      _buildDoor("Journal", () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return JournalPage();
                        }));
                      })
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
