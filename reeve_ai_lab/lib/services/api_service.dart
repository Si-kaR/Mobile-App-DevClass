import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  Future<String> fetchAIResponse(String message) async {
    try {
      final response = await http.post(
        Uri.parse('https://api.openai.com/v1/chat/completions'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'message': message}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['message'] != null) {
          return data['message'];
        } else {
          throw Exception("Invalid response structure");
        }
      } else {
        throw Exception("Failed to load AI response (${response.statusCode})");
      }
    } catch (e) {
      throw Exception("Oops! Something went wrong: $e");
    }
  }
}

// API Keys

// Key1
// const apikeyOpenReeveAi = "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";

// Key2
// const apikeyOpenReeveAi = "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";

// // Key3
// const apikeyOpenReeveAi =
//     "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";

// Key4 - uncomment this key and comment the rest to use this key

const apikeyOpenReeveAi =
    "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";
