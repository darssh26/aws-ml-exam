import 'package:awsmlexam/main.dart';
import 'package:awsmlexam/providers/home_provider.dart';
import 'package:awsmlexam/providers/question_provider.dart';
import 'package:awsmlexam/screens/practice_screen.dart';
import 'package:flutter/material.dart';
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
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    provider = Provider.of<HomeProvider>(context, listen: false);
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xFFdde6e8),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: size.height * 0.4,
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
                      DropdownButton(
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
                              child: Text(e.key),
                              value: e.value,
                            );
                          }).toList()
                        ],
                        onChanged: (int? value) {
                          setState(() {
                            dropValue = value;
                          });
                        },
                        hint: Text("Select Questions"),
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
                          title: Text("Random Questions"),
                        ),
                      ),
                      SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () {
                          print(dropValue);
                          List<QuestionProvider> questions = provider
                              .getQuestions(dropValue ?? -1, isRandom ?? false);
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
              height: size.height * 0.1,
            ),
            Container(
              height: size.height * 0.2,
              child: Column(
                children: [
                  Divider(
                    thickness: 1,
                    height: 30,
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
                          List<QuestionProvider> questions =
                              provider.getQuestions(65, true);
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
    );
  }
}
