import 'package:flutter/material.dart';
import '../models/options.dart';
import '../models/question_options.dart';
import '../services/quiz_firestore_service.dart';

class QuestionProvider with ChangeNotifier {
  int _currentQuestionIndex = 0;
  int _score = 0;
  bool _isAnswered = false;
  bool _isQuizFinished = false;

  final List<Question> _questions = [
    Question(
      text: "What is the capital of France?",
      options: [
        Option(text: "Paris", isCorrect: true),
        Option(text: "London", isCorrect: false),
        Option(text: "Berlin", isCorrect: false),
        Option(text: "Madrid", isCorrect: false),
      ],
    ),
    Question(
      text: "Which planet is known as the Red Planet?",
      options: [
        Option(text: "Earth", isCorrect: false),
        Option(text: "Mars", isCorrect: true),
        Option(text: "Jupiter", isCorrect: false),
        Option(text: "Saturn", isCorrect: false),
      ],
    ),
    Question(
      text: "Who wrote 'Romeo and Juliet'?",
      options: [
        Option(text: "Charles Dickens", isCorrect: false),
        Option(text: "William Shakespeare", isCorrect: true),
        Option(text: "Jane Austen", isCorrect: false),
        Option(text: "Leo Tolstoy", isCorrect: false),
      ],
    ),
    Question(
      text: "What is the largest ocean on Earth?",
      options: [
        Option(text: "Atlantic Ocean", isCorrect: false),
        Option(text: "Indian Ocean", isCorrect: false),
        Option(text: "Arctic Ocean", isCorrect: false),
        Option(text: "Pacific Ocean", isCorrect: true),
      ],
    ),
  ];

  List<Question> get questions => _questions;
  int get currentQuestionIndex => _currentQuestionIndex;
  int get score => _score;
  bool get isAnswered => _isAnswered;
  bool get isQuizFinished => _isQuizFinished;

  Question get currentQuestion => _questions[_currentQuestionIndex];

  void handleAnswer(Option selectedOption) {
    if (!_isAnswered) {
      if (selectedOption.isCorrect) {
        _score++;
      }
      _isAnswered = true;
      notifyListeners();
    }
  }

  void nextQuestion() async {
    if (_currentQuestionIndex < _questions.length - 1) {
      _currentQuestionIndex++;
      _isAnswered = false;
    } else {
      _isQuizFinished = true;

      await QuizFirestoreService().saveQuizResult(
        userId: "guest_user", // ممكن تعدليها لو عندك login
        category: "General Knowledge",
        totalQuestions: _questions.length,
        correctAnswers: _score,
        score: _score * 10,
        timestamp: DateTime.now(),
      );
    }
    notifyListeners();
  }

  void resetQuiz() {
    _currentQuestionIndex = 0;
    _score = 0;
    _isAnswered = false;
    _isQuizFinished = false;
    notifyListeners();
  }
}
