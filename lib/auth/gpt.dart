import 'dart:io';
import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

String? TOKEN = Platform.environment['token'];

Future<List<Messages>> getPreviousMessages(String chatId) async {
  // get last 5 messages from chat
  final chat =
      await FirebaseFirestore.instance.collection('chats').doc(chatId).get();

  // order by last timeSent and retrieve last 5 or less
  final messages = chat['messages'].sublist(
      chat['messages'].length - 5 < 0 ? 0 : chat['messages'].length - 5,
      chat['messages'].length);

  return [
    for (var message in messages)
      Messages(
          role: message['isMe'] ? Role.user : Role.system,
          content: message['content'])
  ];
}

Future<String> getResponse(
    String message, String behavior, String chatId) async {
  FirebaseFirestore fs = FirebaseFirestore.instance;
  final OpenAIKey = await fs.collection('keys').doc('openai_key').get();
  final data = OpenAIKey.data()?['data'];

  final openAI = OpenAI.instance.build(
      token: data,
      baseOption: HttpSetup(receiveTimeout: const Duration(seconds: 5)));

  var lastMessages = await getPreviousMessages(chatId);

  final completion = ChatCompleteText(
      messages: [
            Messages(role: Role.system, content: behavior),
            Messages(role: Role.user, content: message)
          ] +
          lastMessages,
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
