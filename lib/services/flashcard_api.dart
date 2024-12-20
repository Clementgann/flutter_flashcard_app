import 'dart:convert';
import 'package:flutter_flashcard_app/models/flashcard_model.dart';
import 'package:http/http.dart' as http;

class FlashcardApi {
  static const String apiUrl = 'https://66f529e19aa4891f2a241d3b.mockapi.io/api/v1/getQuizList';

  Future<List<Flashcard>> fetchFlashcards() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        List jsonResponse = json.decode(response.body);
        return jsonResponse.map((data) => Flashcard.fromJson(data)).toList();
      } else {
        throw Exception('Failed to load flashcards');
      }
    } catch (e) {
      throw Exception('Error fetching flashcards: $e');
    }
  }
}
