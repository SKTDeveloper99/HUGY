import 'package:flutter/material.dart';
import 'package:hugy/screens/chat.dart';
import 'package:hugy/screens/contacts.dart';
import 'package:hugy/screens/discover.dart';
import 'package:hugy/screens/profile.dart';

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
          decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage("assets/backgrounds/sky2.jpg"),
            ),
          ),
          child: Column(
            children: [
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
                      _buildDoor("Discover", () {
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
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
