import 'package:cloud_firestore/cloud_firestore.dart';

class Task {
  String? id;
  String title;
  bool completed; // true/false

  Task({this.id, required this.title, this.completed = false});

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      title: json['title'],
      completed: json['completed'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'completed': completed,
    };
  }

  factory Task.fromDocumentSnapshot(DocumentSnapshot doc) {
    return Task(
      id: doc.id,
      title: doc['title'],
      completed: doc['completed'],
    );
  }

  toMap() {
    return {
      'id': id,
      'title': title,
      'completed': completed,
    };
  }
}
