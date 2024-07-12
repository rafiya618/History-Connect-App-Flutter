import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mc_history_gemini/hotel_booking/model/api_key.dart';
import 'package:mc_history_gemini/hotel_booking/model/chat_model.dart';
import 'package:http/http.dart' as http;
import 'package:mc_history_gemini/hotel_booking/hotel_app_theme.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  List<ChatModel> chatList = [];
  final TextEditingController controller = TextEditingController();

  void onSendMessage() async {
    final model = ChatModel(isMe: true, message: controller.text);

    chatList.insert(0, model);
    controller.clear();

    setState(() {});

    final geminiModel = await sendRequestToGemini(model);

    chatList.insert(0, geminiModel);
    setState(() {});
  }

  Future<ChatModel> sendRequestToGemini(ChatModel model) async {
    String url =
        "https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent?key=${GeminiApiKey.api_key}";

    Map<String, dynamic> body = {
      "contents": [
        {
          "parts": [
            {"text": model.message},
          ],
        },
      ],
    };

    Uri uri = Uri.parse(url);

    final result = await http.post(
      uri,
      headers: {"Content-Type": "application/json"},
      body: json.encode(body),
    );

    print(result.statusCode);
    print(result.body);

    final decodedJson = json.decode(result.body);

    String message = decodedJson['candidates'][0]['content']['parts'][0]['text'];

    return ChatModel(isMe: false, message: message);
  }

  List<TextSpan> parseMessage(String message) {
    final regex = RegExp(r'\*\*(.*?)\*\*');
    final spans = <TextSpan>[];
    final matches = regex.allMatches(message);

    int start = 0;
    for (final match in matches) {
      if (start != match.start) {
        spans.add(TextSpan(text: message.substring(start, match.start)));
      }
      spans.add(TextSpan(
        text: match.group(1),
        style: const TextStyle(fontWeight: FontWeight.bold),
      ));
      start = match.end;
    }
    if (start < message.length) {
      spans.add(TextSpan(text: message.substring(start)));
    }
    return spans;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ask Gemini",style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 22,
        ),),
        backgroundColor: HotelAppTheme.buildLightTheme().primaryColor,
      ),
      body: Column(
        children: [
          Expanded(
            flex: 10,
            child: ListView.builder(
              reverse: true,
              itemCount: chatList.length,
              itemBuilder: (context, index) {
                final chat = chatList[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(
                    alignment: chat.isMe ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      decoration: BoxDecoration(
                        color: chat.isMe ? Colors.blue[50] : Colors.black87,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.all(12),
                      child: RichText(
                        text: TextSpan(
                          style: TextStyle(
                            color: chat.isMe ? Colors.blue[900] : Colors.white,
                          ),
                          children: parseMessage(chat.message),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: SizedBox(
              height: 60,
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: controller,
                      decoration: InputDecoration(
                        hintText: "Message",
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: onSendMessage,
                    icon: const Icon(Icons.send),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
