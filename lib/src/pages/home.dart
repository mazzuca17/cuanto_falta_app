import 'package:cuanto_falta_app/src/controllers/TimeController.dart';
import 'package:flutter/material.dart';
import 'package:date_count_down/date_count_down.dart';
import 'package:percent_indicator/percent_indicator.dart';
import '../controllers/TimeController.dart';
import 'dart:async';
import 'package:intl/intl.dart';


class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var percentage = 0.00;
  @override
  void initState() {
    Timer.periodic(new Duration(seconds: 1), (timer) {
      setState(() {
        percentage = TimeController().calculateTime();
        //print(percentage);
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(percentage);
    final f = NumberFormat("###.00");

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
                padding: EdgeInsets.all(10),
                child: CircularPercentIndicator(
                  //circular progress indicator
                  radius: 320.0, //radius for circle
                  lineWidth: 15.0, //width of circle line
                  animation:
                      false, //animate when it shows progress indicator first
                  percent: percentage /
                      100, //vercentage value: 0.6 for 60% (60/100 = 0.6)
                  center: Text(
                    "${percentage.toStringAsFixed(percentage.truncateToDouble() == percentage ? 0 : 2)} %",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
                  ), //center text, you can set Icon as well
                  footer: Text(
                    "Order this Month",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 17.0),
                  ), //footer text
                  backgroundColor:
                      Colors.lightGreen[300], //backround of progress bar
                  circularStrokeCap: CircularStrokeCap
                      .round, //corner shape of progress bar at start/end
                  progressColor: Colors.redAccent, //progress bar color
                )),
            Text(
              'Falta para el nuevo año:',
            ),
            CountDownText(
              due: DateTime.parse("2024-01-01 00:00:00"),
              finishedText: "Done",
              showLabel: true,
              longDateName: true,
              daysTextLong: " Días ",
              hoursTextLong: " Horas ",
              minutesTextLong: " Minutos ",
              secondsTextLong: " Segundos ",
              style: TextStyle(
                color: Colors.blue,
                fontSize: 20,
              ),
            )
          ],
        ),
      ),
    );
  }
}
