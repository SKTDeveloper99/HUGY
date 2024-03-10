import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';

var endpoint = "https://hugy-server.onrender.com";

Future<String?> getMood(String text) async {
  print("getting mood");
  Uri uri = Uri.parse("$endpoint/predict");
  try {
    var response = await http.post(uri,
        body: jsonEncode({"text": text}),
        headers: {HttpHeaders.contentTypeHeader: "application/json"});
    print(response.body);
    return jsonDecode(response.body)['prediction'];
  } catch (e) {
    return "joy";
  }
}

Future<List<String>> getActivity() async {
  FirebaseFirestore fs = FirebaseFirestore.instance;
  String userId = FirebaseAuth.instance.currentUser!.uid;
  var collection = fs.collection("users").doc(userId).collection("entries");

  var query = collection.orderBy('timeCreated', descending: true).limit(1);

  if (await query.get().then(
        (value) => value.size == 0,
      )) {
    return [];
  }

  var snapshot =
      (await query.get().then((value) => value.docs[0].data()))['content'];

  String? mood = await getMood(snapshot);

  final String response = await rootBundle.loadString('assets/activities.json');
  Map<String, dynamic> data = await jsonDecode(response);

  List<String> activities = (data[mood] as List<dynamic>)
      .map((e) => e.toString())
      .toList()
      .cast<String>();

  return activities;
}
