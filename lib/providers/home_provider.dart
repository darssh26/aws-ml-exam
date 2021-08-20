import 'dart:convert';

import 'package:awsmlexam/providers/mcq_provider.dart';
import 'package:awsmlexam/providers/multi_provider.dart';
import 'package:awsmlexam/providers/question_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class HomeProvider extends ChangeNotifier {
  List<QuestionProvider> _questions = [];

  List<QuestionProvider> get questions => _questions;

  bool timerPaused = false;
  bool timerReset = false;

  void resetTimer() {
    timerPaused = false;
    timerReset = true;
    notifyListeners();
  }

  //List<QuestionProvider> get questions => _questions;

  Future getData() async {
    String data = await loadJson("assets/jsons/main.json");
    _getQuestions(data);
  }

  Future<String> loadJson(fileName) async {
    return await rootBundle.loadString(fileName);
  }

  void _getQuestions(String data) {
    var jsonData = jsonDecode(data);
    List ques = jsonData['questions'];

    _questions = ques.map((json) {
      if (json['type'] == "mcq") {
        return MCQProvider.fromJson(json);
      }
      return MultiSelectProvider.fromJson(json);
    }).toList();
  }

  List<QuestionProvider> getQuestions(int count, bool random) {
    List<QuestionProvider> list = [..._questions];
    if (random) list.shuffle();
    if (count != -1) list = list.take(count).toList();
    return list;
  }

  List<QuestionProvider> getQuestionsRange(int start, int end) {
    List<QuestionProvider> list = [..._questions];
    list = list.sublist(start - 1, end);
    return list;
  }
}
