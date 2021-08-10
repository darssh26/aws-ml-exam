import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class ResultScreen extends StatefulWidget {
  final int total, score;
  const ResultScreen(this.total, this.score, {Key? key}) : super(key: key);

  @override
  _ResultScreenState createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  late Size size;

  late int score;
  late String pass;

  @override
  void initState() {
    super.initState();
    score = (widget.score / widget.total * 100).ceil();
    if (score < 75) {
      pass = "Faild";
    } else {
      pass = "Passed";
    }
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          foregroundColor: Colors.white,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          title: Text(
            "Score",
            style: GoogleFonts.roboto(
              fontSize: size.width * 0.05,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          centerTitle: true,
          iconTheme: IconThemeData(color: Colors.black87),
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(Icons.arrow_back),
          ),
        ),
        body: Container(
          width: size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buildGuage(),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("Keep Going"),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildGuage() {
    return Container(
      width: size.width * 0.8,
      child: SfRadialGauge(axes: <RadialAxis>[
        RadialAxis(
            useRangeColorForAxis: true,
            minimum: 0,
            maximum: 100,
            ranges: <GaugeRange>[
              GaugeRange(startValue: 0, endValue: 75, color: Colors.red),
              GaugeRange(startValue: 75, endValue: 100, color: Colors.green)
            ],
            pointers: <GaugePointer>[
              NeedlePointer(value: score.toDouble())
            ],
            annotations: <GaugeAnnotation>[
              GaugeAnnotation(
                widget: Container(
                  child: Text(
                    '$score%\n$pass',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                angle: 90,
                positionFactor: 0.7,
              ),
            ])
      ]),
    );
  }
}
