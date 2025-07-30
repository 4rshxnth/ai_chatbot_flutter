import 'package:http/http.dart' as http;
import 'dart:convert';

Future<String> chatbot(String usertext) async {
  final response = await http.post(
    Uri.parse(
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=AIzaSyDlq1R73oBp1lRsV5ZdAZoSY8xdClCgpQI',
    ),
    headers: {"Content-Type": "application/json"},
    body: jsonEncode({
      "contents": [
        {
          "parts": [
            {"text": usertext},
          ],
        },
      ],
    }),
  );

  if (response.statusCode == 200) {
    final json = jsonDecode(response.body);
    return json['candidates'][0]["content"]["parts"][0]["text"];
  } else {
    return "Something went wrong:";
  }
}
