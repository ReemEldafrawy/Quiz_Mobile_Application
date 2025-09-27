import 'package:flutter/material.dart';
import 'package:my_quiz/models/question_options.dart';
import '../models/Questions.dart';
import '../Services/api_dio.dart';

class QuizProvider extends ChangeNotifier {
  int selectedIndex = -1;
  int score = 120;
  int lives = 5;
  List<Category> categories = [];
  List<Question> questions = []; // قائمة الأسئلة
  int currentQuestionIndex = 0; // مؤشر السؤال الحالي

  bool isLoading = true;
  bool isError = false;

  QuizProvider() {
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final data = await ApiService().fetchCategories();
      categories = data;
      isLoading = false;
      notifyListeners();
    } catch (e) {
      isError = true;
      isLoading = false;
      notifyListeners();
    }
  }

  void selectCategory(int index) {
    selectedIndex = index;
    notifyListeners();
  }

  void resetSelected() {
    selectedIndex = -1;
    notifyListeners();
  }

  void loadQuestions(List<Question> newQuestions) {
    questions = newQuestions;
    currentQuestionIndex = 0;
    notifyListeners();
  }

  void nextQuestion() {
    if (currentQuestionIndex < questions.length - 1) {
      currentQuestionIndex++;
      notifyListeners();
    }
  }

  Question get currentQuestion => questions[currentQuestionIndex];
}
