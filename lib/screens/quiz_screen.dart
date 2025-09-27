import 'package:flutter/material.dart';
import 'package:my_quiz/Provider/Quiz_provider.dart';
import 'package:my_quiz/Widgets/answer_option.dart';
import 'package:my_quiz/screens/Question_screen.dart';
import 'package:my_quiz/screens/login_screen.dart';
import '../widgets/custom_button.dart';
import '../core/constants.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QuizScreen extends StatelessWidget {
  const QuizScreen({super.key});

  IconData getCategoryIcon(String name) {
    switch (name.toLowerCase()) {
      case 'science':
        return Icons.science;
      case 'history':
        return Icons.history_edu;
      case 'sports':
        return Icons.sports_soccer;
      case 'math':
        return Icons.calculate;
      default:
        return Icons.category;
    }
  }

  Future<void> logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('email');
    await prefs.remove('password');
    await prefs.setBool('isLoggedIn', false); // ← أضفنا ده
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final quizProvider = Provider.of<QuizProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('Quiz App', style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () => logout(context),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.emoji_emotions_outlined,
                    color: primaryColor,
                    size: 18,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    "${quizProvider.lives}",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: primaryColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: quizProvider.isLoading
            ? const Center(child: CircularProgressIndicator())
            : quizProvider.isError
            ? const Center(child: Text('Failed to load categories'))
            : Column(
                children: [
                  const SizedBox(height: 16),
                  Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    width: 70,
                    height: 70,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        begin: Alignment.centerRight,
                        end: Alignment.centerLeft,
                        colors: [Colors.yellow, primaryColor],
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Container(
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                        child: Center(
                          child: Text(
                            "${quizProvider.score}",
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: primaryColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: RichText(
                      text: TextSpan(
                        text: "${quizProvider.selectedIndex + 1}",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.yellow,
                        ),
                        children: [
                          TextSpan(
                            text: " / ${quizProvider.categories.length}",
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Choose a category',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  ...List.generate(quizProvider.categories.length, (index) {
                    final cat = quizProvider.categories[index];
                    return AnswerOption(
                      text: cat.name,
                      icon: getCategoryIcon(cat.name),
                      isSelected: quizProvider.selectedIndex == index,
                      onTap: () {
                        quizProvider.selectCategory(index);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const QuestionScreen(),
                          ),
                        );
                      },
                    );
                  }),
                  Expanded(
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 36),
                        child: CustomButton(
                          onPressed: () {
                            quizProvider.nextQuestion();
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
