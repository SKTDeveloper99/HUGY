import 'dart:io';
import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';

String? TOKEN = Platform.environment['token'];

Future<String> getResponse(String message) async {
  final openAI = OpenAI.instance.build(
      token: TOKEN!,
      baseOption: HttpSetup(receiveTimeout: const Duration(seconds: 5)));

  final completion = ChatCompleteText(messages: [
    Messages(
        role: Role.system,
        content:
            "You are a mental health expert. You will give advice and useful information to users."),
    Messages(role: Role.user, content: message)
  ], maxToken: 200, model: GptTurboChatModel());

  final res = await openAI
      .onChatCompletion(request: completion)
      .then((ChatCTResponse? response) => {
            if (response == null)
              {"Could not get response"}
            else
              {response.choices[0].message!.content}
          });

  return res.toString();
}
