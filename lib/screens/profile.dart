import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:hugy/screens/splash.dart';
import 'package:file_picker/file_picker.dart';

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
        title: const Text("My Profile"),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const Text("Profile photo"),
            trailing: InkWell(
              onTapUp: (details) async {
                FilePickerResult? image = await FilePicker.platform
                    .pickFiles(type: FileType.image, allowMultiple: false);

                if (image != null) {
                  File file = File(image.files.first.path!);
                  Uint8List bytes = file.readAsBytesSync();
                  String fileName =
                      '${FirebaseAuth.instance.currentUser!.email!}.jpg';
                  await FirebaseStorage.instance
                      .ref('profiles/$fileName')
                      .putData(bytes);

                  String downloadURL = await FirebaseStorage.instance
                      .ref('profiles/$fileName')
                      .getDownloadURL();

                  await FirebaseAuth.instance.currentUser!
                      .updatePhotoURL(downloadURL);

                  setState(() {});
                }

                // set as use profile photo
              },
              child: CircleAvatar(
                radius: 30,
                backgroundImage: NetworkImage(
                  FirebaseAuth.instance.currentUser?.photoURL ??
                      "https://www.pngitem.com/pimgs/m/146-1468479_my-profile-icon-blank-profile-picture-circle-hd.png",
                ),
              ),
              onTap: () {},
            ),
          ),
          ListTile(
            leading: const Text("Name"),
            trailing: SizedBox(
              width: 200,
              child: TextField(
                decoration: InputDecoration(
                  hintText: FirebaseAuth.instance.currentUser!.displayName,
                ),
                onSubmitted: (value) async {
                  await FirebaseAuth.instance.currentUser!
                      .updateDisplayName(value);
                },
              ),
            ),
          ),
          ListTile(
            leading: const Text("Email"),
            trailing: Text(FirebaseAuth.instance.currentUser!.email!),
          ),
          const SizedBox(
            height: 20,
          ),
          ListTile(
            leading: const Text("Logout"),
            trailing: const Icon(Icons.logout),
            onTap: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => const SplashScreen()));
            },
          ),
        ],
      ),
    );
  }
}
