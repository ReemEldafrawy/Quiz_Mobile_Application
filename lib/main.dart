import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import 'package:my_quiz/Provider/Question_provider.dart';
import 'package:my_quiz/Provider/Quiz_provider.dart';
import 'package:my_quiz/Provider/auth_provider.dart' as my_auth;
import 'package:my_quiz/Provider/local_provider.dart';
import 'package:my_quiz/localization/App_localization.dart';
import 'package:my_quiz/screens/login_screen.dart';
import 'package:my_quiz/screens/quiz_screen.dart';
//import 'package:my_quiz/screens/loader_border_screen.dart'; // ✅ استيراد شاشة الليدربورد
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  fb_auth.User? user = fb_auth.FirebaseAuth.instance.currentUser;

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => my_auth.AuthProvider()),
        ChangeNotifierProvider(create: (_) => QuizProvider()),
        ChangeNotifierProvider(create: (_) => QuestionProvider()),
        ChangeNotifierProvider(create: (_) => LocaleProvider()),
      ],
      child: MyApp(isLoggedIn: user != null),
    ),
  );
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;

  const MyApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    final localeProvider = Provider.of<LocaleProvider>(context);

    return MaterialApp(
      title: 'Quiz App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.purple,
        fontFamily: 'Cairo',
        scaffoldBackgroundColor: Colors.white,
      ),
      home: isLoggedIn ? const QuizScreen() : const LoginScreen(),

      // Localization
      locale: localeProvider.locale,
      supportedLocales: const [Locale('en'), Locale('ar')],
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
    );
  }
}
