import 'package:awsmlexam/models/option.dart';
import 'package:awsmlexam/providers/question_provider.dart';

class MCQProvider extends QuestionProvider {
  final String type, main, comment;
  final List options;

  MCQProvider(this.type, this.main, this.comment, this.options);

  factory MCQProvider.fromJson(Map<String, dynamic> json) {
    return MCQProvider(
        json['type'], json['main'], json['comment'], json['options']);
  }

  List<Option> getOptions() {
    return options.map((e) => Option.fromJson(e)).toList();
  }
}
