import 'package:awsmlexam/providers/home_provider.dart';
import 'package:awsmlexam/screens/home_screen.dart';
import 'package:awsmlexam/utils/media_finder.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late Size size;
  late HomeProvider provider;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      getData();
    });
  }

  void getData() {
    MediaFinder.getDocumentsDirectory();
    provider = Provider.of<HomeProvider>(context, listen: false);
    provider.getData();

    Future.delayed(Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => HomeScreen(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(
      body: Center(
        child: Container(
          width: size.width * 0.8,
          alignment: Alignment.center,
          child: Text(
            "AWS Machine Learning Speciality Practice Exam",
            style: GoogleFonts.roboto(
              fontSize: size.width * 0.04,
              fontWeight: FontWeight.w500,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
