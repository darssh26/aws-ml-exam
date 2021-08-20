import 'dart:async';

import 'package:awsmlexam/providers/home_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class TimerWidget extends StatefulWidget {
  final String time;
  final Function onFinish;

  const TimerWidget(this.time, this.onFinish, {Key? key}) : super(key: key);
  @override
  _TimerWidgetState createState() => _TimerWidgetState();
}

class _TimerWidgetState extends State<TimerWidget> {
  late Size size;
  late String time;
  late int minutes;
  late int seconds;
  Timer? timer;
  late Duration interval;

  late Color color;

  void pauseTimer() {
    if (timer != null) {
      timer?.cancel();
      timer = null;
    }
  }

  void startTimer() {
    pauseTimer();
    timer = Timer.periodic(interval, (Timer timer) {
      if (minutes == 0) {
        if (seconds > 0) {
          setState(() {
            seconds--;
          });
        } else {
          widget.onFinish();
          timer.cancel();
        }
      } else {
        if (seconds > 0) {
          setState(() {
            seconds--;
          });
        } else {
          setState(() {
            minutes--;
            seconds = 59;
          });
        }
      }
    });
  }

  @override
  void initState() {
    super.initState();
    interval = Duration(seconds: 1);
    color = Colors.white.withOpacity(0.0);
    time = widget.time;
    minutes = int.parse(time.substring(0, time.lastIndexOf(":")));
    seconds = int.parse(time.substring(time.lastIndexOf(':') + 1));
    startTimer();
  }

  String getTime() {
    String m;
    String s;
    if (minutes < 10) {
      m = '0' + minutes.toString();
    } else {
      m = minutes.toString();
    }

    if (seconds < 10) {
      s = '0' + seconds.toString();
    } else {
      s = seconds.toString();
    }

    //print(m + ':' + s);
    return m + ':' + s;
  }

  @override
  void dispose() {
    if (timer != null) {
      timer?.cancel();
      timer = null;
    }
    super.dispose();
  }

  late HomeProvider provider;

  @override
  Widget build(BuildContext context) {
    provider = Provider.of<HomeProvider>(context);
    size = MediaQuery.of(context).size;
    if (provider.timerPaused) {
      pauseTimer();
    } else {
      if (provider.timerReset) {
        time = widget.time;
        minutes = int.parse(time.substring(0, time.lastIndexOf(":")));
        seconds = int.parse(time.substring(time.lastIndexOf(':') + 1));
        startTimer();
      } else {
        startTimer();
      }
    }

    return Container(
      width: size.width * 0.23,
      height: size.height * 0.04,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Container(
            width: size.width * 0.15,
            padding: EdgeInsets.symmetric(horizontal: 5),
            alignment: Alignment.center,
            child: FittedBox(
              fit: BoxFit.fill,
              child: Text(
                getTime(),
                style: GoogleFonts.roboto(
                  color: Colors.black,
                  fontSize: size.width * 0.035,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
