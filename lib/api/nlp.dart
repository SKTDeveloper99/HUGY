import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';

var endpoint = "http://127.0.0.1:5000";

Future<String?> getMood(String text) async {
  Uri uri = Uri.parse("$endpoint/predict/$text");
  try {
    await http.get(uri).then((value) {
      return jsonDecode(value.body)['prediction'];
    });
  } catch (e) {
    print(e);
  }
}

Future<List<String>> getActivity() async {
  FirebaseFirestore fs = FirebaseFirestore.instance;
  var collection = fs.collection("entries");

  var query = collection.orderBy('timeCreated', descending: true).limit(1);

  var snapshot = await query.get().then((value) => value.docs[0].data());

  if (snapshot == null) {
    return [];
  }

  String? mood = await getMood(snapshot['content']);

  final String response = await rootBundle.loadString('assets/activities.json');
  final data = await jsonDecode(response);

  var activities_for_mood = data[mood];

  activities_for_mood.shuffle();

  // pick 5
  var random = new Random();
  var activities = [];
  var cap = activities_for_mood.length > 5 ? 5 : activities_for_mood.length;

  for (var i = 0; i < cap; i++) {
    activities
        .add(activities_for_mood[random.nextInt(activities_for_mood.length)]);
  }

  return activities.cast<String>();
}
