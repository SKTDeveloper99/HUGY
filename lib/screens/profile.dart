import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hugy/screens/splash.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Profile"),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          ListTile(
            leading: Text("Profile photo"),
            trailing: CircleAvatar(),
          ),
          ListTile(
            leading: Text("Name"),
            trailing: Text("User Name"),
          ),
          ListTile(
            leading: Text("Email"),
            trailing: Text(FirebaseAuth.instance.currentUser!.email!),
          ),
          const SizedBox(
            height: 20,
          ),
          ListTile(
            leading: Text("Logout"),
            trailing: Icon(Icons.logout),
            onTap: () {
              FirebaseAuth.instance.signOut();
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => const SplashScreen()));
            },
          ),
        ],
      ),
    );
  }
}
