import 'dart:convert';
import 'package:google_generative_ai/google_generative_ai.dart';

import '../models/budget.dart';

class GeminiService {
  final GenerativeModel _model;

  GeminiService({required GenerativeModel model}) : _model = model;

  Future<List<Budget>> processUserRequest(String userMessage) async {
    final prompt =
        """
      The user wants to create budgets. Analyze the following message and extract budget details (name, amount, and a suitable category). 
      Respond ONLY with a JSON array of budget objects. If no budgets can be extracted, return an empty array.
      Example JSON format: 
      [{"name": "school", "amount": 50000.0, "category": "Education"}, {"name": "groceries", "amount": 100000.0, "category": "Food"}]

      User message: $userMessage
    """;

    final content = [Content.text(prompt)];
    final response = await _model.generateContent(content);
    final geminiResponse = response.text;

    if (geminiResponse != null) {
      try {
        final jsonString = _extractJsonString(geminiResponse);
        if (jsonString.isNotEmpty) {
          final List<dynamic> jsonList = jsonDecode(jsonString);
          return jsonList.map((json) => Budget.fromJson(json)).toList();
        }
      } catch (e) {
        print('Error parsing Gemini response as JSON: $e');
      }
    }
    return [];
  }

  String _extractJsonString(String text) {
    final startIndex = text.indexOf('[');
    final endIndex = text.lastIndexOf(']');
    if (startIndex != -1 && endIndex != -1 && endIndex > startIndex) {
      return text.substring(startIndex, endIndex + 1);
    }
    return '';
  }

  Future<String> getChatResponse(String userMessage) async {
    final content = [Content.text(userMessage)];
    final response = await _model.generateContent(content);
    return response.text ?? 'I\'m sorry, I couldn\'t process that.';
  }
}
