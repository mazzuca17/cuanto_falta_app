import 'package:cuanto_falta_app/src/controllers/TimeController.dart';
import 'package:flutter/material.dart';
import 'package:date_count_down/date_count_down.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'dart:async';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Timer? timer;
  late TimeController timeController;

  @override
  void initState() {
    super.initState();
    timeController = TimeController();
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  DateTime calculateDueDate() {
    DateTime currentDate = DateTime.now();
    return DateTime(currentDate.year + 1, currentDate.month, currentDate.day,
        currentDate.hour, currentDate.minute, currentDate.second);
  }

  @override
  Widget build(BuildContext context) {
    double percentage = timeController.calculateTime();

    return Scaffold(
      backgroundColor: Color(0xFF252525),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              color: Color(0xFF252525),
              child: CircularPercentIndicator(
                header: Text(
                  "Año:",
                  style: TextStyle(
                    fontWeight: FontWeight.w300,
                    fontSize: 45.0,
                    color: Color(0xffF2F2F2),
                  ),
                ),
                radius: 200.0,
                lineWidth: 7.50,
                animation: false,
                percent: percentage / 100,
                center: Text(
                  "${percentage.toStringAsFixed(percentage.truncateToDouble() == percentage ? 0 : 2)} %",
                  style: TextStyle(
                    fontWeight: FontWeight.w300,
                    fontSize: 50.0,
                    color: Color(0xffF2F2F2),
                  ),
                ),
                backgroundColor: Color.fromARGB(255, 228, 228, 228),
                circularStrokeCap: CircularStrokeCap.round,
                progressColor: Color(0XFF3BD16F),
                curve: Curves.easeOutExpo,
                arcType: ArcType.FULL,
                arcBackgroundColor: Colors.blueGrey,
              ),
            ),
            Text(
              "Faltan:",
              style: TextStyle(
                fontWeight: FontWeight.w300,
                fontSize: 20.0,
                color: Color(0xffF2F2F2),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: CountDownText(
                due: calculateDueDate(),
                finishedText: "Done",
                showLabel: true,
                longDateName: true,
                daysTextLong: " D : ",
                hoursTextLong: " Hs : ",
                minutesTextLong: " Min : ",
                secondsTextLong: " Seg ",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 20.0,
                  color: Color(0xffF2F2F2),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
