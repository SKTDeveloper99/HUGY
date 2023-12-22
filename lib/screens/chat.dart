import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hugy/auth/gpt.dart';
import 'package:hugy/chat/chat.dart';
import 'package:hugy/chat/message.dart';

class ChatPage extends StatefulWidget {
  final String chatId;
  const ChatPage({super.key, required this.chatId});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  TextEditingController _messageController = TextEditingController();

  Future<void> getBotResponse(String message) async {
    final bot_id = widget.chatId;

    //get response
    await getResponse(message)
        .then((value) => {
              //add response to chat
              ChatService().addMessage(
                  bot_id,
                  Message(
                      content: value, isMe: false, timeSent: DateTime.now()))
            })
        .catchError((error) => {
              ChatService().addMessage(
                  bot_id,
                  Message(
                      content: "Sorry, Cannot reach bot",
                      isMe: false,
                      timeSent: DateTime.now()))
            });
  }

  Widget textBubble(Message message) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Align(
        alignment: message.isMe ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          padding: const EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.blue,
          ),
          child: Container(
            child: Text(
              message.content,
              style: const TextStyle(fontSize: 20.0),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('chats')
            .doc(widget.chatId)
            .get()
            .asStream(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            Chat c = Chat.fromDocumentSnapshot(snapshot.data!);
            return Scaffold(
              appBar: AppBar(
                title: Text(c.chatName),
                centerTitle: true,
              ),
              body: Container(
                color: Colors.grey[200],
                child: Column(children: [
                  Expanded(
                      child: ListView(
                    children: [
                      for (var message in c.messages) textBubble(message)
                    ],
                  )),
                  Container(
                    height: 50,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: EdgeInsets.all(10),
                    child: TextField(
                      controller: _messageController,
                      onSubmitted: (value) async {
                        Message message = Message(
                          content: value,
                          isMe: true,
                          timeSent: DateTime.now(),
                        );
                        await ChatService().addMessage(widget.chatId, message);

                        await getBotResponse(message.content);

                        // setState
                        setState(() {
                          _messageController.clear();
                        }); // we will use streams later
                      },
                      style: TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ]),
              ),
            );
          } else {
            return CircularProgressIndicator();
          }
        });
  }
}
