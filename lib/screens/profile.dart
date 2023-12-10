import 'package:flutter/material.dart';

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
        ],
      ),
    );
  }
}
