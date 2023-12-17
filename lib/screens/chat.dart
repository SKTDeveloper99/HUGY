import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hugy/chat/chat.dart';
import 'package:hugy/chat/message.dart';

class ChatPage extends StatefulWidget {
  final DocumentSnapshot chat;
  const ChatPage({super.key, required this.chat});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  TextEditingController _messageController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Hugy Bot"),
        centerTitle: true,
      ),
      body: Container(
        color: Colors.white,
        child: Column(children: [
          Expanded(child: ListView()),
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
              onSubmitted: (value) {
                Message message = Message(
                  content: value,
                  isMe: true,
                  timeSent: DateTime.now(),
                );
                ChatService().addMessage(widget.chat.id, message);

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
  }
}
