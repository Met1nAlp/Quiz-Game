import 'package:html_unescape/html_unescape.dart';

class Question {
  final String category;
  final String question;
  final List<String> options;
  final String correctAnswer;

  Question({
    required this.category,
    required this.question,
    required this.options,
    required this.correctAnswer,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    final unescape = HtmlUnescape();
    List<String> options = List.from(json['incorrect_answers'])
      ..add(json['correct_answer'])
      ..shuffle();
    return Question(
      category: unescape.convert(json['category']),
      question: unescape.convert(json['question']),
      options: options.map((option) => unescape.convert(option)).toList(),
      correctAnswer: unescape.convert(json['correct_answer']),
    );
  }
}