import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Chatpage extends StatefulWidget {
  const Chatpage({super.key});

  @override
  _ChatpageState createState() => _ChatpageState();
}

class _ChatpageState extends State<Chatpage> {
  // List to store chat messages (user and AI)
  final List<Map<String, String>> messages = [];

  // Controller for the text input field
  final TextEditingController _controller = TextEditingController();

  // Function to handle sending a message
  void _sendMessage() async {
    String userMessage = _controller.text;
    if (userMessage.isEmpty) return;

    setState(() {
      // Add user message to the chat
      messages.add({'sender': 'User', 'message': userMessage});
      _controller.clear(); // Clear the input field
    });

    // Simulate AI response (you can replace this with actual AI interaction)
    var url = Uri.http('192.168.18.190:5000', '/ChatPrompt'); // Corrected Uri
    var response = await http.post(url, body: {'message': userMessage});
    String aiResponse = "AI: Response to '${response.body}'";

    setState(() {
      messages.add({'sender': 'AI', 'message': aiResponse});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Chat Page')),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  var message = messages[index];
                  return Align(
                    alignment: message['sender'] == 'User'
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12.0, vertical: 8.0),
                        decoration: BoxDecoration(
                          color: message['sender'] == 'User'
                              ? Colors.blueAccent
                              : Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          message['message']!,
                          style: TextStyle(
                            color: message['sender'] == 'User'
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: const InputDecoration(
                        hintText: 'Type a message...',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: _sendMessage,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
