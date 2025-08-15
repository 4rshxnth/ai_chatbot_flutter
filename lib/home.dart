import 'package:chatbot/services.dart';
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

  List<Map<String, String>> messages = [];

  void sendMessage() async {
    if (send.text.trim().isEmpty) return;

    String userInput = send.text.trim();

    setState(() {
      messages.add({'sender': 'user', 'text': userInput});
      Loading = true;
      response = '';
    });

    final reply = await chatbot(userInput);
    final cleanedReply = _cleanMarkdown(reply);

    setState(() {
      response = cleanedReply;
      messages.add({'sender': 'bot', 'text': response});
      Loading = false;
    });

    send.clear();
  }

  /// Cleans up markdown formatting by fixing incomplete bold and removing bad asterisks
  String _cleanMarkdown(String text) {
    // Fix incomplete bold like "**Hello" → "**Hello**"
    String fixedBold = text.replaceAllMapped(RegExp(r'\*\*(\w+)(?!\*\*)'), (
      match,
    ) {
      return '**${match.group(1)}**';
    });

    // Remove single '*' that is not part of italic formatting
    String cleanedSingles = fixedBold.replaceAllMapped(
      RegExp(r'(^|\s)\*(?!\S)|\*(?=\s|$)'),
      (match) {
        return match.group(1) ?? '';
      },
    );

    return cleanedSingles;
  }

  /// Parses markdown for **bold** and *italic*
  List<TextSpan> _parseMarkdown(String text) {
    final cleanedText = _cleanMarkdown(text);
    final List<TextSpan> spans = [];

    // Match **bold**, *italic*, or normal text
    final RegExp markdownRegex = RegExp(r'(\*\*(.*?)\*\*|\*(.*?)\*)');
    int currentIndex = 0;

    for (final match in markdownRegex.allMatches(cleanedText)) {
      if (match.start > currentIndex) {
        spans.add(
          TextSpan(text: cleanedText.substring(currentIndex, match.start)),
        );
      }

      if (match.group(2) != null) {
        // Bold text
        spans.add(
          TextSpan(
            text: match.group(2),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        );
      } else if (match.group(3) != null) {
        // Italic text
        spans.add(
          TextSpan(
            text: match.group(3),
            style: const TextStyle(fontStyle: FontStyle.italic),
          ),
        );
      }

      currentIndex = match.end;
    }

    if (currentIndex < cleanedText.length) {
      spans.add(TextSpan(text: cleanedText.substring(currentIndex)));
    }

    return spans;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundImage: AssetImage('assets/chatbot_logo.png'),
          ),
        ),
        actions: [
          Icon(Icons.settings, color: Colors.white, size: 30),
          SizedBox(width: 20),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: messages.isEmpty
                ? Center(
                    child: Text(
                      "Ask something...",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: EdgeInsets.all(20.0),
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final msg = messages[index];
                      final isUser = msg['sender'] == 'user';

                      return Container(
                        margin: EdgeInsets.symmetric(vertical: 6),
                        alignment: isUser
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Container(
                          padding: EdgeInsets.all(12),
                          constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width * 0.9,
                          ),
                          decoration: BoxDecoration(
                            color: isUser
                                ? Colors.grey[900]
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: RichText(
                            text: TextSpan(
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: isUser
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                              children: _parseMarkdown(msg['text']!),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
          if (Loading)
            Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: CircularProgressIndicator(color: Colors.white),
            ),
          Container(
            padding: EdgeInsets.all(10.0),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: send,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hint: Text(
                        '  Type a message...',
                        style: TextStyle(color: Colors.white60, fontSize: 18),
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
                  onPressed: sendMessage,
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
