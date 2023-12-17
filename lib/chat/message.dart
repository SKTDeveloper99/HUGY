import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final bool isMe;
  final String content;
  final DateTime timeSent;

  Message({
    required this.isMe,
    required this.content,
    required this.timeSent,
  });

  Map<String, dynamic> toMap() {
    return {
      'isMe': isMe,
      'content': content,
      'timeSent': timeSent,
    };
  }

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      isMe: map['isMe'],
      content: map['content'],
      timeSent: map['timeSent'].toDate(),
    );
  }
}
