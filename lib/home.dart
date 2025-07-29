import 'package:flutter/material.dart';

class Chatbot extends StatefulWidget {
  const Chatbot({super.key});

  @override
  State<Chatbot> createState() => _ChatbotState();
}

class _ChatbotState extends State<Chatbot> {
  TextEditingController send = TextEditingController();
  bool Loading = false;
  String response = '';
  void sendMessage() async {
    if (send.text.trim().isEmpty) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.grey[850],
        leading: Padding(
          padding: const EdgeInsets.all(12.0),
          child: CircleAvatar(backgroundImage: AssetImage('assets/avatar.png')),
        ),
        actions: [
          Icon(Icons.settings, color: Colors.grey, size: 30),
          SizedBox(width: 20),
          Icon(Icons.more_vert, color: Colors.grey, size: 30),
          SizedBox(width: 20),
        ],
      ),

      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            padding: EdgeInsets.all(10),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: TextEditingController(),
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hint: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Text(
                          'Type a message...',
                          style: TextStyle(color: Colors.white60),
                        ),
                      ),
                      filled: true,
                      fillColor: Colors.grey[850],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.send, color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
