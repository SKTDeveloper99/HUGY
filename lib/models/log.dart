import 'package:flutter/foundation.dart';

class Log {
  final String title;
  final String content;
  final DateTime timeCreated;

  Log({
    required this.title,
    required this.content,
    required this.timeCreated,
  });

  Map<String, dynamic> toMap() {
    return {
      "title": title,
      "content": content,
      "timeCreated": timeCreated,
    };
  }

  factory Log.fromMap(Map<String, dynamic> map) {
    return Log(
        content: map['content'],
        title: map['title'],
        timeCreated: map['timeCreated'].toDate());
  }
}
