import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_quiz/services/quiz_firestore_service.dart';

final _auth = FirebaseAuth.instance;
final _quizService = QuizFirestoreService();

void submitQuiz({
  required String category,
  required int totalQuestions,
  required int correctAnswers,
  required int score,
}) {
  final user = _auth.currentUser;

  if (user != null) {
    _quizService.saveQuizResult(
      userId: user.uid,
      category: category,
      totalQuestions: totalQuestions,
      correctAnswers: correctAnswers,
      score: score,
      timestamp: DateTime.now(),
    );
  }
}
