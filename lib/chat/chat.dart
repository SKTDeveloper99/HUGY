import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hugy/chat/message.dart';

class Chat {
  List<Message> messages;
  String chatName;
  String owner;
  String behavior;
  String id; //hashcode of user and bot

  Chat({
    required this.chatName,
    required this.messages,
    required this.owner,
    required this.behavior,
    required this.id,
  });

  Map<String, dynamic> toMap() {
    return {
      'messages': messages.map((x) => x.toMap()).toList(),
      'owner': owner,
      'id': id,
      'chatName': chatName,
      'behavior': behavior,
    };
  }

  factory Chat.fromMap(Map<String, dynamic> map) {
    return Chat(
      messages:
          List<Message>.from(map['messages']?.map((x) => Message.fromMap(x))),
      owner: map['owner'],
      id: map['id'],
      chatName: map['chatName'],
      behavior: map['behavior'],
    );
  }

  factory Chat.fromJson(Map<String, dynamic> json) {
    return Chat(
        chatName: json["chatName"],
        id: json["id"],
        messages: json["messages"],
        behavior: json["behavior"],
        owner: json["owner"]);
  }

  Chat.fromDocumentSnapshot(DocumentSnapshot documentSnapshot)
      : id = documentSnapshot.id,
        chatName = documentSnapshot['chatName'],
        owner = documentSnapshot['owner'],
        behavior = documentSnapshot['behavior'],
        messages = List<Message>.from(
            documentSnapshot['messages']?.map((x) => Message.fromMap(x)));
}

Stream getChatStream(String chatId) {
  return FirebaseFirestore.instance.collection('chats').doc(chatId).snapshots();
}

Future<String> getBehavior(String chatId) {
  return FirebaseFirestore.instance
      .collection('chats')
      .doc(chatId)
      .get()
      .then((value) => value['behavior']);
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

  Future<void> deleteChat(String chatId) async {
    await _firestore.collection('chats').doc(chatId).delete();
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
