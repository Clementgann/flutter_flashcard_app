class Flashcard {
  final String question;
  final String answer;

  Flashcard({required this.question, required this.answer});

  // From JSON
  factory Flashcard.fromJson(Map<String, dynamic> json) {
    return Flashcard(
      question: json['question'],  // Assuming the JSON key for question is 'question'
      answer: json['answer'],      // Assuming the JSON key for answer is 'answer'
    );
  }

  // To JSON
  Map<String, dynamic> toJson() {
    return {
      'question': question,
      'answer': answer,
    };
  }
}
