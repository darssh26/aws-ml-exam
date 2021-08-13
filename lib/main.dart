import 'package:awsmlexam/providers/home_provider.dart';
import 'package:awsmlexam/providers/question_provider.dart';
import 'package:awsmlexam/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:provider/provider.dart';

enum Mode { EXAM, PRACTICE }

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (context) => HomeProvider(),
      ),
      ChangeNotifierProvider(
        create: (context) => QuestionProvider(),
      )
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  final int primary = 0xFF00C1D4;
  @override
  Widget build(BuildContext context) {
    return NeumorphicApp(
      title: 'AWS ML Specialty Exam',
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
      materialTheme: ThemeData(
        primarySwatch: MaterialColor(primary, <int, Color>{
          50: Color(primary),
          100: Color(primary),
          200: Color(primary),
          300: Color(primary),
          400: Color(primary),
          500: Color(primary),
          600: Color(primary),
          700: Color(primary),
          800: Color(primary),
          900: Color(primary),
        }),
      ),
    );
  }
}
