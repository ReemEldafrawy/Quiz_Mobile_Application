import 'package:cloud_firestore/cloud_firestore.dart';

class LeaderboardService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>> fetchLeaderboardData() async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('quiz_results')
          .orderBy('score', descending: true)
          .get();

      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return {
          'userId': data['userId'] ?? '',
          'category': data['category'] ?? '',
          'score': data['score'] ?? 0,
          'correctAnswers': data['correctAnswers'] ?? 0,
          'totalQuestions': data['totalQuestions'] ?? 0,
          'timestamp': data['timestamp'],
        };
      }).toList();
    } catch (e) {
      print('Error loading leaderboard: $e');
      return [];
    }
  }
}
