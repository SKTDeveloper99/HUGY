import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class Log {
  final String id;
  final String title;
  final String content;
  final DateTime timeCreated;

  Log({
    required this.id,
    required this.title,
    required this.content,
    required this.timeCreated,
  });

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "title": title,
      "content": content,
      "timeCreated": timeCreated,
    };
  }

  factory Log.fromMap(Map<String, dynamic> map) {
    return Log(
        id: map['id'],
        content: map['content'],
        title: map['title'],
        timeCreated: map['timeCreated'].toDate());
  }

  String getTitle() {
    if (DateTime.tryParse(this.title) == null) {
      // our title is not a datetime anymore
      return title;
    } else {
      // title is still datetime
      return DateFormat('dd MM yyyy').format(timeCreated);
    }
  }

  @override
  // TODO: implement hashCode
  int get hashCode => title.hashCode ^ content.hashCode ^ timeCreated.hashCode;
}

class LogService {
  FirebaseFirestore _firestore =
      FirebaseFirestore.instance; // Creater a new firestore connection

  // function to upload a log
  Future<bool> uploadLog(Log entry) async {
    try {
      await _firestore.collection('entries').add(entry.toMap());
    } catch (e) {
      print(e);
      return false; // failed to upload log
    }

    return true; //succesfully uploaded the log entry
  }

  Future<bool> deleteLog(String hashCode) async {
    try {
      await _firestore.collection('entries').doc(hashCode.toString()).delete();
    } catch (e) {
      print(e);
      return false;
    }

    return true;
  }

  Stream<QuerySnapshot> getLastFiveLogs() async* {
    yield* _firestore
        .collection('entries')
        .where('timeCreated',
            isGreaterThanOrEqualTo: DateTime.now().subtract(Duration(days: 5)))
        .get()
        .asStream();
  }

  Future<DocumentSnapshot> getLog(String id) async {
    return await _firestore.collection('entries').doc(id).get();
  }
}
