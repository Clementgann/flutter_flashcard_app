import 'package:flutter/material.dart';
import 'package:flutter_flashcard_app/providers/flashcard_provider.dart';
import 'package:flutter_flashcard_app/screens/flashcard_screen.dart';
import 'package:provider/provider.dart';


void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => FlashcardProvider(),
      child: const FlashcardApp(),
    ),
  );
}

class FlashcardApp extends StatelessWidget {
  const FlashcardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flashcard App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const FlashcardScreen(),
    );
  }
}
