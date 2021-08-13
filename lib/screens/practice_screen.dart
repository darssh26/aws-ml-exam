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
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
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

  //to add review feature
  late List<QuestionProvider> questions;
  late bool markedForReview;
  List<QuestionProvider> markedQuestions = [];
  late int markedScore;
  late bool isReviewing;

  @override
  void initState() {
    super.initState();
    index = 0;
    score = 0;
    markedScore = 0;
    questions = widget.questions;
    total = questions.length;

    red = Color(0xFFFF4848).withOpacity(0.7);
    green = Color(0xFF29BB89).withOpacity(0.7);

    player.init();

    isReviewing = false;
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  void getQuestion() {
    if (isNew) {
      markedForReview = false;
      if (questions[index].runtimeType == MCQProvider) {
        mcq = questions[index] as MCQProvider;
        options = mcq?.getOptions() ?? <Option>[];
        options.shuffle();
        selectedValue = -1;
        isNew = false;
      } else if (questions[index].runtimeType == MultiSelectProvider) {
        multi = questions[index] as MultiSelectProvider;
        select = multi?.select ?? [];
        options = multi?.getOptions() ?? <Option>[];
        bools = List.generate(options.length, (index) => false);
        selectedBoxes = [];
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
        backgroundColor: Color(0xFFdde6e8),
        body: Column(
          children: [
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: Icon(Icons.arrow_back),
                ),
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

  Widget buildMarkForReview() {
    return InkWell(
      onTap: () {
        setState(() {
          if (markedForReview) {
            markedQuestions.remove(questions[index]);
          } else {
            markedQuestions.add(questions[index]);
          }
          markedForReview = !markedForReview;
        });
      },
      child: Container(
        padding: EdgeInsets.only(right: 5),
        child: Stack(
          children: [
            Opacity(
              opacity: markedForReview ? 1 : 0,
              child: Icon(
                Icons.star,
                color: Colors.amber,
              ),
            ),
            Icon(
              Icons.star_border_outlined,
            )
          ],
        ),
      ),
    );
  }

  Widget buildButton() {
    if (questions[index].runtimeType == MCQProvider) {
      return IgnorePointer(
        ignoring: selectedValue == -1 ? true : false,
        child: button("mcq"),
      );
    }
    return IgnorePointer(
      ignoring: selectedBoxes.length != select.length ? true : false,
      child: button("multi"),
    );
  }

  void multiSubmit() {
    if (submitted == false) {
      setState(() {
        select.sort();
        selectedBoxes.sort();
        bool success = listEquals(select, selectedBoxes);
        if (success) {
          playSound("happy");
          if (!markedForReview) {
            score++;
          } else {
            markedScore++;
          }
        } else {
          playSound("sad");
        }
        submitted = true;
      });
    } else {
      if (index < total - 1) {
        setState(() {
          submitted = false;
          isNew = true;
          index++;
        });
      } else {
        goToResultScreen();
      }
    }
  }

  void mcqSubmit() {
    if (submitted == false) {
      setState(() {
        if (selectedValue == 1) {
          playSound("happy");
          if (!markedForReview) {
            score++;
          } else {
            markedScore++;
          }
        } else {
          playSound("sad");
        }
        submitted = true;
        if (index == total - 1) {
          done = true;
        }
      });
    } else {
      if (index < total - 1) {
        setState(() {
          submitted = false;
          isNew = true;
          index++;
        });
      } else {
        if (widget.mode == Mode.EXAM) {
          if (markedQuestions.length > 0) {
            _showAlertDialog();
          } else {
            goToResultScreen();
          }
        } else {
          goToResultScreen();
        }
      }
    }
  }

  void _showAlertDialog() {
    showDialog(
      context: context,
      builder: (_) {
        return StatefulBuilder(builder: (context, _setState) {
          return AlertDialog(
            title: Text(
              "Finish Exam",
              style: GoogleFonts.roboto(
                color: Theme.of(context).primaryColor,
              ),
            ),
            content: Container(
              height: size.height * 0.15,
              child: Text(
                  "You have marked ${markedQuestions.length} questions for review. Do you want to review them?"),
            ),
            actions: <Widget>[
              ElevatedButton(
                child: Text(
                  'Yes',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  setState(() {
                    Navigator.of(context).pop();
                    questions = markedQuestions;
                    markedQuestions = [];
                    total = questions.length;
                    index = 0;
                    submitted = false;
                    done = false;
                    isNew = true;
                    isReviewing = true;
                  });
                },
              ),
              ElevatedButton(
                child: Text('No'),
                onPressed: () {
                  score += markedScore;
                  goToResultScreen();
                },
              )
            ],
          );
        });
      },
    );
  }

  Widget button(String questionType) {
    return Container(
      width: size.width * 0.25,
      height: size.height * 0.055,
      margin: EdgeInsets.all(10),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
      ),
      child: NeumorphicButton(
        onPressed: () {
          if (questionType == "mcq") {
            mcqSubmit();
          } else {
            multiSubmit();
          }
        },
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
      child: Neumorphic(
        style: NeumorphicStyle(
          shape: NeumorphicShape.flat,
          lightSource: LightSource.top,
          depth: 5,
          surfaceIntensity: 0.8,
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 10, left: 8, right: 8),
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
        ),
      ),
    );
  }

  Widget buildMultiSelectOption(int key, int id, String title) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      child: Neumorphic(
        style: NeumorphicStyle(
          shape: NeumorphicShape.flat,
          lightSource: LightSource.top,
          depth: 3,
          surfaceIntensity: 0.8,
          color: widget.mode == Mode.PRACTICE
              ? submitted
                  ? select.contains(id)
                      ? green
                      : selectedBoxes.contains(id)
                          ? red
                          : null
                  : null
              : null,
        ),
        child: CheckboxListTile(
          value: bools[key],
          title: Text(title),
          onChanged: (val) {
            if (!submitted) {
              setState(() {
                bools[key] = val;
              });

              if (val == true) {
                selectedBoxes.add(id);
              } else {
                selectedBoxes.remove(id);
              }
            }
          },
          controlAffinity: ListTileControlAffinity.leading,
        ),
      ),
    );
  }

  Widget buildMCQ() {
    return Container(
      width: size.width,
      margin: EdgeInsets.all(10),
      child: Neumorphic(
        style: NeumorphicStyle(
          shape: NeumorphicShape.flat,
          lightSource: LightSource.top,
          depth: 5,
          surfaceIntensity: 0.8,
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 8, left: 8, right: 8),
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
        ),
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
          height: 1.3,
        ),
        children: [
          if (widget.mode == Mode.EXAM && !isReviewing && !submitted)
            WidgetSpan(
              child: buildMarkForReview(),
            ),
          ...subs.map((String e) {
            if (e.contains(".png") || e.contains(".jpg")) {
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
        ],
      ),
    );
  }

  Widget buildMCQOption(int value, String title) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      child: Neumorphic(
        style: NeumorphicStyle(
          shape: NeumorphicShape.flat,
          lightSource: LightSource.top,
          depth: 5,
          surfaceIntensity: 1,
          color: widget.mode == Mode.PRACTICE
              ? submitted
                  ? value == selectedValue
                      ? value == 1
                          ? green
                          : red
                      : value == 1
                          ? green
                          : null
                  : null
              : null,
        ),
        child: RadioListTile(
          value: value,
          groupValue: selectedValue,
          title: Text(title),
          onChanged: (_) {
            if (!submitted) {
              setState(() {
                selectedValue = value;
              });
            }
          },
        ),
      ),
    );
  }
}
