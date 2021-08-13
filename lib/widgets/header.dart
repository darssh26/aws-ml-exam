import 'package:awsmlexam/main.dart';
import 'package:awsmlexam/widgets/timer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class MyHeader extends StatelessWidget {
  final int index, total, score;
  final Mode mode;
  const MyHeader(this.index, this.total, this.score, this.mode, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 30,
      margin: EdgeInsets.all(8),
      //padding: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(5),
      ),
      child: Neumorphic(
        child: Padding(
          padding: const EdgeInsets.all(5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Question ${index + 1}/$total",
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              buildRightWidget()
            ],
          ),
        ),
      ),
    );
  }

  Widget buildRightWidget() {
    if (mode == Mode.PRACTICE) {
      return Text(
        "Score ${(score / total * 100).ceil()}%",
        style: TextStyle(fontWeight: FontWeight.w500),
      );
    }
    return Container(
      child: TimerWidget("180:0", () {}),
    );
  }
}
