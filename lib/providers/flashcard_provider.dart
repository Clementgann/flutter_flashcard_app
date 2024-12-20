import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_flashcard_app/models/flashcard_model.dart';
import 'package:flutter_flashcard_app/services/flashcard_api.dart';

class FlashcardProvider with ChangeNotifier {
  List<Flashcard> _flashcards = [];
  bool _isLoading = false;
  String _currentAnswer = '';
  int _currentIndex = -1;  // To track the current flashcard
  String _message = '';
  bool _isSubmitButtonDisabled = false;  // Flag to disable/enable the submit button

  List<Flashcard> get flashcards => _flashcards;
  bool get isLoading => _isLoading;
  String get currentAnswer => _currentAnswer;
  String get message => _message;
  bool get isSubmitButtonDisabled => _isSubmitButtonDisabled;

  // Public getter for _currentIndex
  int get currentIndex => _currentIndex;

  // Regex for validating integer or decimal input
  final RegExp _validNumberRegex = RegExp(r'^\-?\d*\.?\d+$');

  // TextEditingController for answer input
  final TextEditingController _answerController = TextEditingController();

  TextEditingController get answerController => _answerController;

  Future<void> fetchFlashcards() async {
    _isLoading = true;
    notifyListeners();

    try {
      _flashcards = await FlashcardApi().fetchFlashcards();
      if (_flashcards.isNotEmpty) {
        _loadNextQuestion();
      }
    } catch (e) {
      print('Error fetching flashcards: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  // Move to the next random question
  void _loadNextQuestion() {
    if (_flashcards.isNotEmpty) {
      _currentIndex = Random().nextInt(_flashcards.length);
      _currentAnswer = '';  // Clear the answer field
      _message = '';        // Clear any previous message
      _answerController.clear(); // Clear the text field
      _isSubmitButtonDisabled = false;  // Enable the submit button
    }
    notifyListeners();
  }

  // Normalize the input and correct answer to handle decimals
  bool _isCorrectAnswer(String userInput, String correctAnswer) {
    try {
      double userAnswer = double.parse(userInput.trim());
      double correct = double.parse(correctAnswer.trim());

      // Compare normalized values, e.g., 64 and 64.0 should match
      return userAnswer == correct;
    } catch (e) {
      return false; // Invalid number input
    }
  }

  // Check if the answer is correct
  void submitAnswer() {
    if (_currentIndex != -1 && _flashcards.isNotEmpty) {
      Flashcard currentFlashcard = _flashcards[_currentIndex];

      // Disable submit button temporarily
      _isSubmitButtonDisabled = true;
      notifyListeners();

      // Validate the input as a valid number (integer or decimal)
      if (!_validNumberRegex.hasMatch(_currentAnswer.trim())) {
        _message = 'Please enter a valid number.';
      } else {
        // Check if the normalized user answer matches the correct answer
        if (_isCorrectAnswer(_currentAnswer, currentFlashcard.answer)) {
          _message = 'Correct!';
        } else {
          _message = 'Wrong! The correct answer is: ${currentFlashcard.answer}';
        }
      }

      // Load the next random question after a delay (simulate delay for feedback)
      Future.delayed(const Duration(seconds: 2), _loadNextQuestion);
      notifyListeners();
    }
  }

  void updateAnswer(String value) {
    _currentAnswer = value;
    notifyListeners();
  }
}
