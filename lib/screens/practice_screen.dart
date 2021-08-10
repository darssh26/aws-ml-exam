import 'package:awsmlexam/main.dart';
import 'package:awsmlexam/models/option.dart';
import 'package:awsmlexam/providers/mcq_provider.dart';
import 'package:awsmlexam/providers/multi_provider.dart';
import 'package:awsmlexam/providers/question_provider.dart';
import 'package:awsmlexam/screens/result_screen.dart';
import 'package:awsmlexam/utils/media_finder.dart';
import 'package:awsmlexam/utils/sound_player.dart';
import 'package:awsmlexam/widgets/header.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PracticeScreen extends StatefulWidget {
  final List<QuestionProvider> questions;
  final Mode mode;
  const PracticeScreen(this.questions, this.mode, {Key? key}) : super(key: key);

  @override
  _PracticeScreenState createState() => _PracticeScreenState();
}

class _PracticeScreenState extends State<PracticeScreen> {
  late Size size;
  late int total, index, score;

  SoundPlayer player = SoundPlayer();

  MCQProvider? mcq;
  MultiSelectProvider? multi;

  late List<Option> options;
  int selectedValue = -1;
  bool submitted = false;

  late List select;
  List selectedBoxes = [], bools = [];

  bool isNew = true;

  bool done = false;
  late Color red, green;

  @override
  void initState() {
    super.initState();
    index = 0;
    score = 0;
    total = widget.questions.length;

    red = Color(0xFFFF4848);
    green = Color(0xFF29BB89);

    player.init();
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  void getQuestion() {
    if (isNew) {
      if (widget.questions[index].runtimeType == MCQProvider) {
        mcq = widget.questions[index] as MCQProvider;
        options = mcq?.getOptions() ?? <Option>[];
        options.shuffle();
        isNew = false;
      } else if (widget.questions[index].runtimeType == MultiSelectProvider) {
        multi = widget.questions[index] as MultiSelectProvider;
        select = multi?.select ?? [];
        options = multi?.getOptions() ?? <Option>[];
        bools = List.generate(options.length, (index) => false);
        options.shuffle();
        isNew = false;
      }
    }
  }

  void goToResultScreen() {
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => ResultScreen(total, score)));
  }

  void playSound(String feeling) {
    if (widget.mode == Mode.PRACTICE) {
      if (feeling == "happy") {
        player.playHappySound();
      } else {
        player.playSadSound();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    getQuestion();
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Row(
              children: [
                IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: Icon(Icons.arrow_back)),
                Expanded(
                  child: MyHeader(index, total, score, widget.mode),
                ),
              ],
            ),
            Expanded(
              child: ListView(
                children: [
                  buildQuestion(),
                  Align(
                    alignment: Alignment.centerRight,
                    child: buildButton(),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildButton() {
    if (widget.questions[index].runtimeType == MCQProvider) {
      return IgnorePointer(
        ignoring: selectedValue == -1 ? true : false,
        child: InkWell(
          onTap: () {
            if (submitted == false) {
              setState(() {
                if (selectedValue == 1) {
                  playSound("happy");
                  score++;
                } else {
                  playSound("sad");
                }
                submitted = true;

                if (index == widget.questions.length - 1) {
                  done = true;
                }
              });
            } else {
              if (index < widget.questions.length - 1) {
                setState(() {
                  selectedValue = -1;
                  submitted = false;
                  isNew = true;
                  index++;
                });
              } else {
                goToResultScreen();
              }
            }
          },
          child: button(),
        ),
      );
    }
    return IgnorePointer(
      ignoring: selectedBoxes.length != select.length ? true : false,
      child: InkWell(
        onTap: () {
          if (submitted == false) {
            setState(() {
              select.sort();
              selectedBoxes.sort();
              bool success = listEquals(select, selectedBoxes);
              if (success) {
                print("success");
                playSound("happy");
                score++;
              } else {
                print("false");
                playSound("sad");
              }
              submitted = true;
            });
          } else {
            if (index < widget.questions.length - 1) {
              setState(() {
                submitted = false;
                isNew = true;
                index++;
              });
            } else {
              goToResultScreen();
            }
          }
        },
        child: button(),
      ),
    );
  }

  Widget button() {
    return Container(
      width: size.width * 0.2,
      height: size.height * 0.055,
      alignment: Alignment.center,
      padding: EdgeInsets.all(5),
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: Colors.blue,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(4),
        boxShadow: [BoxShadow()],
      ),
      child: Text(
        submitted
            ? done
                ? "Finish"
                : "Next"
            : "Submit",
        style: GoogleFonts.roboto(
          fontSize: size.width * 0.04,
          fontWeight: FontWeight.w500,
          color: Colors.black,
        ),
      ),
    );
  }

  Widget buildQuestion() {
    if (widget.questions[index].runtimeType == MCQProvider) {
      return buildMCQ();
    }
    return buildMultiSelect();
  }

  Widget buildMultiSelect() {
    return Container(
      width: size.width,
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
        boxShadow: [BoxShadow(color: Colors.grey)],
      ),
      child: Column(
        children: [
          buildMain(multi?.main ?? ""),
          SizedBox(
            height: size.height * 0.04,
          ),
          ...options.asMap().entries.map((e) {
            return buildMultiSelectOption(e.key, e.value.id, e.value.value);
          }).toList()
        ],
      ),
    );
  }

  Widget buildMultiSelectOption(int key, int id, String title) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: widget.mode == Mode.PRACTICE
            ? submitted
                ? select.contains(id)
                    ? green
                    : selectedBoxes.contains(id)
                        ? red
                        : Colors.white
                : Colors.white
            : Colors.white,
        border: Border.all(),
        borderRadius: BorderRadius.circular(5),
      ),
      child: CheckboxListTile(
        value: bools[key],
        title: Text(title),
        onChanged: (val) {
          setState(() {
            bools[key] = val;
            print(bools);
          });

          if (val == true) {
            selectedBoxes.add(id);
          } else {
            selectedBoxes.remove(id);
          }

          print(selectedBoxes);
        },
        controlAffinity: ListTileControlAffinity.leading,
      ),
    );
  }

  Widget buildMCQ() {
    return Container(
      width: size.width,
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
          boxShadow: [BoxShadow(color: Colors.grey)]),
      child: Column(
        children: [
          buildMain(mcq?.main ?? ""),
          SizedBox(
            height: size.height * 0.04,
          ),
          ...options.map((e) {
            return buildMCQOption(e.id, e.value);
          }).toList()
        ],
      ),
    );
  }

  Widget buildMain(String txt) {
    String mainText = txt;
    List<String> subs = [];
    subs = mainText.split("---");
    return Text.rich(
      TextSpan(
        style: GoogleFonts.roboto(
          fontSize: size.width * 0.04,
          fontWeight: FontWeight.w500,
        ),
        children: subs.map((String e) {
          if (e.contains(".png") || e.contains(".jpg")) {
            print(e);
            return WidgetSpan(
              child: Container(
                width: size.width,
                height: size.height * 0.2,
                padding: EdgeInsets.all(5),
                child: FittedBox(
                  fit: BoxFit.contain,
                  child: MediaFinder.getImage(e),
                ),
              ),
            );
          }
          return TextSpan(text: e);
        }).toList(),
      ),
    );
  }

  Widget buildMCQOption(int value, String title) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: widget.mode == Mode.PRACTICE
            ? submitted
                ? value == selectedValue
                    ? value == 1
                        ? green
                        : red
                    : value == 1
                        ? green
                        : Colors.white
                : Colors.white
            : Colors.white,
        border: Border.all(),
        borderRadius: BorderRadius.circular(5),
      ),
      child: RadioListTile(
        value: value,
        groupValue: selectedValue,
        title: Text(title),
        onChanged: (_) {
          setState(() {
            selectedValue = value;
          });
        },
      ),
    );
  }
}
