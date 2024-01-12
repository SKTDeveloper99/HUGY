import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';

var endpoint = "http://10.0.2.2:5000";

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
  var collection = fs.collection("entries");

  var query = collection.orderBy('timeCreated', descending: true).limit(1);

  var snapshot =
      (await query.get().then((value) => value.docs[0].data()))['content'];

  String? mood = await getMood(snapshot);
  print("mood: $mood");

  final String response = await rootBundle.loadString('assets/activities.json');
  Map<String, dynamic> data = await jsonDecode(response);

  List<String> activities = (data[mood] as List<dynamic>)
      .map((e) => e.toString())
      .toList()
      .cast<String>();

  return activities;
}
