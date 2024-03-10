import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:hugy/chat/message.dart';

String? TOKEN = Platform.environment['token'];

Future<List<String>> getPreviousMessages(String chatId) async {
  // get last 5 messages from chat
  final chat =
      await FirebaseFirestore.instance.collection('chats').doc(chatId).get();

/*
  // order by last timeSent and retrieve last 5 or less
  final messages = chat['messages'].sublist(
      chat['messages'].length - 5 < 0 ? 0 : chat['messages'].length - 5,
      chat['messages'].length);
      */

  List<String> messages = [];

  for (var message in chat['messages']) {
    messages.add(message['content']);
  }

  return messages;
}
/** 

Future<String> getResponse(
    String message, String behavior, String chatId) async {
  FirebaseFirestore fs = FirebaseFirestore.instance;
  final OpenAIKey = await fs.collection('keys').doc('openai_key').get();
  final data = OpenAIKey.data()?['data'];

  final openAI = OpenAI.instance.build(
    token: data,
  );

  var lastMessages = await getPreviousMessages(chatId);

  final completion = ChatCompleteText(
      messages: [
            Messages(role: Role.system, content: behavior).toJson(),
            Messages(role: Role.user, content: message).toJson()
          ] +
          lastMessages.map((e) => e.toJson()).toList(),
      maxToken: 200,
      model: GptTurboChatModel());

  final res = await openAI
      .onChatCompletion(request: completion)
      .then((ChatCTResponse? response) => {
            if (response == null)
              {"Could not get response"}
            else
              response.choices[0].message!.content
          });

  return res.toString();
}


*/

Future<String?> getResponse(
    String message, String behavior, String chatId) async {
  var apiKey = await FirebaseFirestore.instance
      .collection("keys")
      .doc('openai_key')
      .get();

  final model =
      GenerativeModel(model: 'gemini-pro', apiKey: apiKey.data()?['data']);
  var lastMessages = await getPreviousMessages(chatId);

  // combine last messages into one string
  var longHistory = lastMessages.join("\n");

  List<Content> content = [
    Content.text(behavior + '\n' + longHistory + '\n' + message)
  ];

  try {
    final response = await model.generateContent(content);
    return response.text;
  } catch (e) {
    return "Sorry, I cannot reach the bot";
  }
}
