import 'package:flutter/material.dart';
import 'package:my_quiz/Provider/Question_provider.dart';
import 'package:my_quiz/screens/loader_border_screen.dart';
import 'package:provider/provider.dart';

class QuestionScreen extends StatelessWidget {
  const QuestionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<QuestionProvider>(context);

    if (provider.isQuizFinished) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Quiz Result"),
          backgroundColor: Colors.deepPurple,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Quiz Completed!",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: 300,
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        Text("Total Questions: ${provider.questions.length}"),
                        Text("Correct Answers: ${provider.score}"),
                        Text("Score: ${provider.score * 10}"),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => provider.resetQuiz(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 14,
                  ),
                ),
                child: const Text("Restart Quiz"),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LeaderboardScreen(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurpleAccent,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 14,
                  ),
                ),
                child: const Text("Details"),
              ),
            ],
          ),
        ),
      );
    }

    final question = provider.currentQuestion;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Quiz"),
        backgroundColor: Colors.deepPurple,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 16),
            Text(
              "Question ${provider.currentQuestionIndex + 1}/${provider.questions.length}",
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(question.text, style: const TextStyle(fontSize: 18)),
            ),
            const SizedBox(height: 20),
            ...question.options.map((option) {
              Color optionColor = Colors.purple[200]!;

              if (provider.isAnswered) {
                if (option.isCorrect) {
                  optionColor = Colors.purple;
                } else {
                  optionColor = Colors.purple.shade100;
                }
              }

              return Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: optionColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: () => provider.handleAnswer(option),
                  child: Text(option.text),
                ),
              );
            }).toList(),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: provider.isAnswered
                  ? () => provider.nextQuestion()
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  vertical: 14.0,
                  horizontal: 30.0,
                ),
              ),
              child: Text(
                provider.currentQuestionIndex < provider.questions.length - 1
                    ? "Next"
                    : "Finish",
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
