import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  Future<List<dynamic>> generateBriefQuestions(String topic) async {
  final response = await http.post(
    Uri.parse('http://localhost:5000/generate-brief'),
    headers: {
      'Content-Type': 'application/json',
    },
    body: jsonEncode({
      'topic': topic,
    }),
  );

  print(response.body);

  final decoded = jsonDecode(response.body);

  if (decoded is List) {
    return decoded;
  }

  if (decoded is Map && decoded.containsKey("data")) {
    return jsonDecode(decoded["data"]);
  }

  throw Exception("Unexpected response format");
}

  Future<List<dynamic>> generateFlashcards(String topic) async {
    final response = await http.post(
      Uri.parse('http://localhost:5000/generate-flashcards'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'topic': topic,
      }),
    );

    print("RAW RESPONSE:");
    print(response.body);

    final responseData = jsonDecode(response.body);

    print("DECODED:");
    print(responseData);

    return jsonDecode(responseData["data"]);
  }
}