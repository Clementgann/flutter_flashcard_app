import 'package:flutter/material.dart';
import 'package:flutter_flashcard_app/providers/flashcard_provider.dart';
import 'package:provider/provider.dart';

class FlashcardScreen extends StatelessWidget {
  const FlashcardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final flashcardProvider = Provider.of<FlashcardProvider>(context);

    // Fetch flashcards if they haven't been loaded yet
    if (flashcardProvider.flashcards.isEmpty && !flashcardProvider.isLoading) {
      flashcardProvider.fetchFlashcards();
    }

    // Show loading indicator while data is being fetched
    if (flashcardProvider.isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Flashcards Quiz"),
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    // Check if there are no flashcards loaded
    if (flashcardProvider.flashcards.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Flashcards Quiz"),
        ),
        body: const Center(child: Text('No flashcards available')),
      );
    }

    // Get the current question using the currentIndex getter
    var currentFlashcard = flashcardProvider.flashcards[flashcardProvider.currentIndex];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Flashcards Quiz"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    currentFlashcard.question,
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: flashcardProvider.answerController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    onChanged: (value) {
                      flashcardProvider.updateAnswer(value);
                    },
                    decoration: const InputDecoration(
                      labelText: 'Enter your answer (Number only)',
                      border: OutlineInputBorder(),
                    ),
                    textInputAction: TextInputAction.done,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: flashcardProvider.isSubmitButtonDisabled
                        ? null  // Disable the button if it is disabled
                        : flashcardProvider.submitAnswer,
                    child: const Text('Submit'),
                  ),
                  const SizedBox(height: 20),
                  if (flashcardProvider.message.isNotEmpty)
                    Text(
                      flashcardProvider.message,
                      style: TextStyle(
                        fontSize: 18,
                        color: flashcardProvider.message == 'Correct!' ? Colors.green : Colors.red,
                      ),
                      textAlign: TextAlign.center,
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
