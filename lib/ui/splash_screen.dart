import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'dart:async';

import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(children: <Widget>[
      Expanded(
          flex: 6,
          child: Container(
            color: Color(0xffffffff),
            child: Stack(
              children: [
                Center(
                  child: Image.network(
                    "https://storage.googleapis.com/s3.codeapprun.io/userassets/sachindarde/zDdaMNIUETimg.png",
                    height: 100,
                  ),
                )
              ],
            ),
          )),
      Expanded(
          flex: 2,
          child: Container(
            width: MediaQuery.of(context).size.width,
            color: Color(0xffffffff),
            child: Column(
              children: [
                SizedBox(height: 15),
                Text(
                  "Todo - Personal Notebook",
                  style: GoogleFonts.nunito(
                      fontWeight: FontWeight.w800, fontSize: 25),
                ),
                SizedBox(height: 7),
                Text(
                  "One stop for all your todo's",
                  style: GoogleFonts.nunito(),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10),
                Center(
                  child: Container(
                    padding: EdgeInsets.only(
                        left: MediaQuery.of(context).size.width / 2 - 50),
                    child: CustomProgressBar(),
                  ),
                )
              ],
            ),
          ))
    ]));
  }
}

class CustomProgressBar extends StatefulWidget {
  @override
  _CustomProgressBar createState() => _CustomProgressBar();
}

class _CustomProgressBar extends State<CustomProgressBar> {
  final storage = new FlutterSecureStorage();
  int count = 1;
  double percentage = 0.0;
  @override
  void initState() {
    super.initState();
    Timer.periodic(new Duration(seconds: 1), (timer) {
      if (count == 5) {
        timer.cancel();
      } else {
        percentage = (count * 2) / 10;
        if (mounted) {
          setState(() {});
        }
        count++;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return LinearPercentIndicator(
      width: 100.0,
      lineHeight: 8.0,
      percent: percentage,
      progressColor: Color(0xff32a6de),
    );
  }
}
