import 'package:awsmlexam/main.dart';
import 'package:awsmlexam/providers/home_provider.dart';
import 'package:awsmlexam/providers/question_provider.dart';
import 'package:awsmlexam/screens/practice_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Size size;
  late HomeProvider provider;

  bool? isRandom = false;
  int? dropValue;
  late Map<String, int> items;

  //65 for real life Exam simulation
  int numberOfExamQuestions = 65;

  int start = 0, end = 0;
  late TextEditingController startController, endController;
  GlobalKey<FormState> rangeKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    items = {
      "5 Questions": 5,
      "10 Questions": 10,
      "20 Questions": 20,
      "30 Questions": 30,
      "40 Questions": 40,
      "50 Questions": 50,
    };

    startController = TextEditingController();
    endController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void getRange() {
    if (rangeKey.currentState?.validate() ?? true) {
      start = int.parse(startController.text);
      end = int.parse(endController.text);
      if (start < 2) {
        start = 1;
      } else if (start > end) {
        start = end - 5;
        if (start < 2) {
          start = 1;
        }
      }
      List<QuestionProvider> questions = provider.getQuestionsRange(start, end);
      startController.clear();
      endController.clear();
      FocusScope.of(context).unfocus();
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => PracticeScreen(questions, Mode.PRACTICE),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    provider = Provider.of<HomeProvider>(context, listen: false);
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xFFdde6e8),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: size.height * 0.08),
              Container(
                height: size.height * 0.36,
                width: size.width * 0.7,
                child: Neumorphic(
                  style: NeumorphicStyle(
                    shape: NeumorphicShape.flat,
                    lightSource: LightSource.top,
                    depth: 5,
                    surfaceIntensity: 0.8,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Let's Practise",
                          style: GoogleFonts.roboto(
                            fontSize: size.width * 0.04,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: size.height * 0.01),
                        Container(
                          width: size.width * 0.5,
                          child: DropdownButton(
                            isExpanded: true,
                            dropdownColor: Color(0xFFdde6e8),
                            icon: Icon(Icons.question_answer_sharp),
                            value: dropValue,
                            items: [
                              DropdownMenuItem(
                                child: Text("All Questions"),
                                value: provider.questions.length,
                              ),
                              ...items.entries.map((e) {
                                return DropdownMenuItem(
                                  child: Text(
                                    e.key,
                                    style: GoogleFonts.roboto(
                                      fontSize: size.width * 0.04,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  value: e.value,
                                );
                              }).toList()
                            ],
                            onChanged: (int? value) {
                              setState(() {
                                dropValue = value;
                              });
                            },
                            hint: Text(
                              "Select Questions",
                              style: GoogleFonts.roboto(
                                fontSize: size.width * 0.04,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                        IntrinsicWidth(
                          child: CheckboxListTile(
                            onChanged: (value) {
                              setState(() {
                                isRandom = value;
                              });
                            },
                            value: isRandom,
                            controlAffinity: ListTileControlAffinity.leading,
                            title: Text(
                              "Random Questions",
                              style: GoogleFonts.roboto(
                                fontSize: size.width * 0.035,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            print(dropValue);
                            List<QuestionProvider> questions =
                                provider.getQuestions(
                                    dropValue ?? -1, isRandom ?? false);
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) =>
                                    PracticeScreen(questions, Mode.PRACTICE),
                              ),
                            );
                          },
                          child: Text(
                            "Start",
                            style: GoogleFonts.roboto(
                              fontSize: size.width * 0.04,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: size.height * 0.05,
              ),
              Neumorphic(
                style: NeumorphicStyle(
                  shape: NeumorphicShape.flat,
                  lightSource: LightSource.top,
                  depth: 5,
                  surfaceIntensity: 0.8,
                ),
                child: Container(
                  height: size.height * 0.25,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Or choose a range of questions :",
                        style: GoogleFonts.roboto(
                          fontSize: size.width * 0.04,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      buildRange(),
                      SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () {
                          getRange();
                        },
                        child: Text(
                          "Start",
                          style: GoogleFonts.roboto(
                            fontSize: size.width * 0.04,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: size.height * 0.05,
              ),
              Container(
                height: size.height * 0.17,
                child: Column(
                  children: [
                    Divider(
                      thickness: 1,
                      height: size.height * 0.04,
                      indent: 20,
                      endIndent: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "OR",
                          style: GoogleFonts.roboto(
                            fontSize: size.width * 0.03,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: () {
                            List<QuestionProvider> questions = provider
                                .getQuestions(numberOfExamQuestions, true);
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  PracticeScreen(questions, Mode.EXAM),
                            ));
                          },
                          child: Text(
                            "Take a Test!",
                            style: GoogleFonts.roboto(
                              fontSize: size.width * 0.04,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildRange() {
    return Form(
      key: rangeKey,
      child: Container(
        width: size.width * 0.7,
        height: size.height * 0.1,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Start",
              style: GoogleFonts.roboto(
                fontSize: size.width * 0.035,
                fontWeight: FontWeight.w400,
              ),
            ),
            buildTextInput(startController),
            SizedBox(width: 15),
            Text(
              "End",
              style: GoogleFonts.roboto(
                fontSize: size.width * 0.035,
                fontWeight: FontWeight.w400,
              ),
            ),
            buildTextInput(endController),
          ],
        ),
      ),
    );
  }

  Widget buildTextInput(TextEditingController controller) {
    return Container(
      width: size.width * 0.2,
      height: size.height * 0.05,
      margin: EdgeInsets.only(left: 8),
      child: TextFormField(
        controller: controller,
        textAlign: TextAlign.start,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Theme.of(context).accentColor,
              width: 2,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Theme.of(context).primaryColor,
              width: 2,
            ),
          ),
        ),
        style: GoogleFonts.roboto(
          fontSize: size.width * 0.05,
        ),
        validator: (value) => controller == startController
            ? validator1(value, controller)
            : validator2(value, controller),
      ),
    );
  }

  String? validator1(String? value, TextEditingController controller) {
    if (value?.isEmpty ?? false) {
      return 'Required';
    } else {
      bool isNumber = int.tryParse(value ?? "") != null;
      if (!isNumber) {
        return 'Not a number';
      }
      return null;
    }
  }

  String? validator2(String? value, TextEditingController controller) {
    if (value?.isEmpty ?? false) {
      return 'Required';
    } else {
      bool isNumber = int.tryParse(value ?? "") != null;
      if (!isNumber) {
        return 'Not a number';
      } else {
        int e = int.parse(controller.text);
        if (e > provider.questions.length) {
          return 'Max ${provider.questions.length}';
        }
      }
      return null;
    }
  }
}
