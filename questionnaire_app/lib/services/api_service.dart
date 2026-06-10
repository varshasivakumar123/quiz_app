import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  Future<List<dynamic>> generateQuestions(String topic) async {
    final response = await http.post(
      Uri.parse('http://localhost:5000/generate'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'topic': topic,
      }),
    );

    return jsonDecode(response.body)['questions'];
  }
}