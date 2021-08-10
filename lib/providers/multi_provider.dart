import 'package:awsmlexam/models/option.dart';
import 'package:awsmlexam/providers/question_provider.dart';

class MultiSelectProvider extends QuestionProvider {
  final String type, main, comment;
  final List select;
  final List options;

  MultiSelectProvider(
      this.type, this.main, this.comment, this.select, this.options);

  factory MultiSelectProvider.fromJson(Map<String, dynamic> json) {
    return MultiSelectProvider(json['type'], json['main'], json['comment'],
        json['select'], json['options']);
  }

  List<Option> getOptions() {
    return options.map((e) => Option.fromJson(e)).toList();
  }
}
