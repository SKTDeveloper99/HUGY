import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hugy/chat/message.dart';

class Chat {
  List<Message> messages;
  String chatName;
  String owner;
  String id; //hashcode of user and bot

  Chat({
    required this.chatName,
    required this.messages,
    required this.owner,
    required this.id,
  });

  Map<String, dynamic> toMap() {
    return {
      'messages': messages.map((x) => x.toMap()).toList(),
      'owner': owner,
      'id': id,
      'chatName': chatName,
    };
  }

  factory Chat.fromMap(Map<String, dynamic> map) {
    return Chat(
      messages:
          List<Message>.from(map['messages']?.map((x) => Message.fromMap(x))),
      owner: map['owner'],
      id: map['id'],
      chatName: map['chatName'],
    );
  }

  factory Chat.fromJson(Map<String, dynamic> json) {
    return Chat(
        chatName: json["chatName"],
        id: json["id"],
        messages: json["messages"],
        owner: json["owner"]);
  }

  Chat.fromDocumentSnapshot(DocumentSnapshot documentSnapshot)
      : id = documentSnapshot.id,
        chatName = documentSnapshot['chatName'],
        owner = documentSnapshot['owner'],
        messages = List<Message>.from(
            documentSnapshot['messages']?.map((x) => Message.fromMap(x)));
}

Stream getChatStream(String chatId) {
  return FirebaseFirestore.instance.collection('chats').doc(chatId).snapshots();
}

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<bool> createNewChat(Chat chat) async {
    try {
      await _firestore.collection('chats').doc(chat.id).set(chat.toMap());
    } catch (e) {
      print(e);
      return false; //unsuccessful
    }
    return true; //successful
  }

  Future<bool> addMessage(String chatId, Message message) async {
    try {
      await _firestore.doc('chats/$chatId').update({
        'messages': FieldValue.arrayUnion([message.toMap()])
      });
    } catch (e) {
      print(e);
      return false; //unsuccessful
    }
    return true;
  }
}
