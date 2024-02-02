import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hugy/chat/chat.dart';
import 'package:hugy/screens/chat.dart';

List<Map<String, dynamic>> chatBots = [
  {
    "name": "June",
    "description": "Mental Health Expert",
    "behavior":
        "You are a mental health expert. You will give advice and useful information to users."
  },
  {
    "name": "Domino",
    "description": "Riddler",
    "behavior": "You are a playful bot. You will ask riddles to users."
  },
  {
    "name": "May",
    "description": "Humurous and helpful bot",
    "behavior":
        " Witty and Humorous: This character has a witty and humorous personality, using humor to relieve stress and confusion. They can offer lighthearted conversations and suggestions to help users relax in a fun atmosphere."
  },
  {
    "name": "April",
    "description": "Philosopher",
    "behavior":
        "AI can provide (methods and steps for thinking through issues), help users (analyze and evaluate different perspectives and values of life), as well as guide users to (deepen their thinking) about the meaning and value of life through (philosophical exercises and reflections)."
  }
];

class ContactsPage extends StatefulWidget {
  const ContactsPage({super.key});

  @override
  State<ContactsPage> createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  final TextEditingController _searchController = TextEditingController();

  Stream loadChats() {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    return FirebaseFirestore.instance
        .collection('chats')
        .where('owner', isEqualTo: userId)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Contacts"),
        actions: [
          IconButton(
            onPressed: () {
              TextEditingController botNameController = TextEditingController();
              // display dialog to add new bot
              /* showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                        title: Text("Add New Bot"),
                        content: TextField(
                          controller: _botNameController,
                          decoration: InputDecoration(
                            labelText: "Bot Name",
                          ),
                        ),
                        actions: [
                          TextButton(
                              onPressed: () async {
                                final user_id =
                                    FirebaseAuth.instance.currentUser!.uid;
                                Chat chat = Chat(
                                    chatName: _botNameController.text,
                                    id: (user_id.hashCode +
                                            Random().nextInt(100))
                                        .toString(),
                                    messages: [],
                                    owner: user_id);
                                await ChatService().createNewChat(chat);
                                Navigator.of(context).pop();
                              },
                              child: Text("Add")),
                          TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text("Cancel")),
                        ],
                      )); */
              showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return ListView.builder(
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(chatBots[index]["name"]),
                          subtitle: Text(chatBots[index]["description"]),
                          onTap: () async {
                            final userId =
                                FirebaseAuth.instance.currentUser!.uid;
                            Chat chat = Chat(
                                chatName: chatBots[index]["name"],
                                id: (userId.hashCode + Random().nextInt(100))
                                    .toString(),
                                messages: [],
                                owner: userId,
                                behavior: chatBots[index]["behavior"]);
                            await ChatService().createNewChat(chat);
                            Navigator.of(context).pop();
                          },
                        );
                      },
                      itemCount: chatBots.length,
                    );
                  });
            },
            icon: const Icon(Icons.person_add),
          ),
        ],
      ),
      body: Column(
        children: [
          TextField(
            controller: _searchController,
            decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Search',
                prefixIcon: Icon(Icons.search)),
          ),
          StreamBuilder(
              stream: loadChats(),
              builder: (ctx, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }

                final chatDocs = snapshot.data.docs;

                return Expanded(
                  child: ListView.builder(
                    itemCount: chatDocs.length,
                    itemBuilder: (ctx, index) {
                      return Dismissible(
                        confirmDismiss: (direction) {
                          return showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text("Delete Chat"),
                                  content: const Text(
                                      "Are you sure you want to delete this chat?"),
                                  actions: [
                                    TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop(false);
                                        },
                                        child: const Text("No")),
                                    TextButton(
                                        onPressed: () async {
                                          await ChatService().deleteChat(
                                              chatDocs[index]['id']);

                                          if (!mounted) return;
                                          Navigator.of(context).pop(true);
                                        },
                                        child: const Text("Yes")),
                                  ],
                                );
                              });
                        },
                        direction: DismissDirection.endToStart,
                        key: ValueKey(chatDocs[index]['id']),
                        child: ListTile(
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (BuildContext ctx) {
                              return ChatPage(
                                chatId: chatDocs[index]['id'],
                              );
                            }));
                          },
                          title: Text(chatDocs[index]['chatName']),
                        ),
                      );
                    },
                  ),
                );
              })
        ],
      ),
    );
  }
}
