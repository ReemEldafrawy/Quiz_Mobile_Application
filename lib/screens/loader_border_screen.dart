import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_quiz/Services/loaderboard_service.dart';

class LeaderboardScreen extends StatelessWidget {
  final LeaderboardService leaderboardService = LeaderboardService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("🏆leaderboard ")),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: leaderboardService.fetchLeaderboardData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No results yet"));
          }

          final results = snapshot.data!;
          return ListView.builder(
            itemCount: results.length,
            itemBuilder: (context, index) {
              final user = results[index];
              final timestamp = user['timestamp'] != null
                  ? DateFormat(
                      'yyyy-MM-dd HH:mm',
                    ).format(user['timestamp'].toDate())
                  : 'Unknown';

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  leading: CircleAvatar(child: Text('${index + 1}')),
                  title: Text('User ID: ${user['userId']}'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Category: ${user['category']}'),
                      Text(
                        'Correct: ${user['correctAnswers']} / ${user['totalQuestions']}',
                      ),
                      Text('Date: $timestamp'),
                    ],
                  ),
                  trailing: Text(
                    '${user['score']} pts',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
