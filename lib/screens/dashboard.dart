import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hugy/auth/firebase.dart';
import 'package:hugy/screens/contacts.dart';
import 'package:hugy/screens/discover.dart';
import 'package:hugy/screens/journal.dart';
import 'package:hugy/screens/life_timer.dart';
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
    return "${now.hour}:${now.minute}";
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
            duration: const Duration(milliseconds: 500),
            curve: Curves.ease,
            decoration: const BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.fitHeight,
                image: AssetImage("assets/backgrounds/pixel_door.jpg"),
              ),
            ),
          ),
        ),
        Text(
          doorName,
          style: const TextStyle(fontSize: 30),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget buildDots() {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              _pageController.animateToPage((currentDoor - 1) % 5,
                  duration: Duration(milliseconds: 500), curve: Curves.linear);
            },
          ),
          SizedBox(
            height: 50,
            width: 100,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 5,
              itemBuilder: (context, index) {
                return AnimatedContainer(
                  padding: const EdgeInsets.all(5),
                  duration: Duration(milliseconds: 500),
                  curve: Curves.ease,
                  width: index == currentDoor ? 30 : 10,
                  height: 10,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  child: Container(
                    width: 4,
                    height: 4,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: index == currentDoor
                          ? Colors.blue
                          : Colors.blue.withOpacity(0.5),
                    ),
                  ),
                );
              },
            ),
          ),
          IconButton(
            icon: const Icon(Icons.arrow_forward),
            onPressed: () {
              _pageController.animateToPage((currentDoor + 1) % 5,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.linear);
            },
          )
        ],
      );
    }

    // scaffold widget
    return Scaffold(
        key: _scaffoldKey,
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          decoration: const BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage("assets/backgrounds/sky2.jpg"),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // app bar, no back button
              SafeArea(
                child: AppBar(
                  titleSpacing: 0,
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  // coins
                  leading: Container(
                    margin: const EdgeInsets.only(left: 10, top: 10),
                    child: StreamBuilder<int>(
                        stream: AuthService().getCoins().asStream(),
                        builder: (context, snapshot) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              const Icon(Icons.star),
                              Text(
                                snapshot.data.toString(),
                                style: const TextStyle(fontSize: 20),
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
                          return const TaskPage();
                        }));
                      },
                      icon: const Icon(Icons.add_task),
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
                          return const ContactsPage();
                        }));
                      }),
                      _buildDoor("Missions", () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return const DiscoverPage();
                        }));
                      }),
                      _buildDoor("Me", () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return const ProfilePage();
                        }));
                      }),
                      _buildDoor("Journal", () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return const JournalPage();
                        }));
                      }),
                      _buildDoor("Life Timer", () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return const LifeTimer();
                        }));
                      })
                    ],
                  ),
                ),
              ),
              Padding(padding: EdgeInsets.only(bottom: 20), child: buildDots()),
            ],
          ),
        ));
  }
}
