import 'package:cloud_firestore/cloud_firestore.dart';

class QuizFirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> saveQuizResult({
    required String userId,
    required String category,
    required int totalQuestions,
    required int correctAnswers,
    required int score,
    required DateTime timestamp,
  }) async {
    await _firestore.collection('quiz_results').add({
      'userId': userId,
      'category': category,
      'totalQuestions': totalQuestions,
      'correctAnswers': correctAnswers,
      'score': score,
      'timestamp': timestamp,
    });
  }
}
