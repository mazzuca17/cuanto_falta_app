import 'package:date_count_down/date_count_down.dart';
import 'package:flutter/material.dart';

import 'route_generator.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Cuánto Falta para?',
        initialRoute: '/Splash',
        onGenerateRoute: RouteGenerator.generateRoute,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          // fontFamily: 'Poppins',
          fontFamily: 'Josefin Sans',
          primaryColor: Colors.white,
          floatingActionButtonTheme: FloatingActionButtonThemeData(
              elevation: 0, foregroundColor: Colors.white),
          brightness: Brightness.light,
          accentColor: Color(0xFF3300C9),
          dividerColor: Color(0xFF3300C9),
          focusColor: Color(0xFF3300C9),
          hintColor: Color(0xFF3300C9),
          textTheme: TextTheme(
            headline5: TextStyle(
                fontSize: 20.0, color: Color(0xFF3300C9), height: 1.35),
            headline4: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.w600,
                color: Color(0xFF3300C9),
                height: 1.35),
            headline3: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w600,
                color: Color(0xFF3300C9),
                height: 1.35),
            headline2: TextStyle(
                fontSize: 22.0,
                fontWeight: FontWeight.w700,
                color: Color(0xFF3300C9),
                height: 1.35),
            headline1: TextStyle(
                fontSize: 22.0,
                fontWeight: FontWeight.w300,
                color: Color(0xFF3300C9),
                height: 1.5),
            subtitle1: TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.w500,
                color: Color(0xFF3300C9),
                height: 1.35),
            headline6: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w600,
                color: Color(0xFF3300C9),
                height: 1.35),
            bodyText2: TextStyle(
                fontSize: 12.0, color: Color(0xFF3300C9), height: 1.35),
            bodyText1: TextStyle(
                fontSize: 14.0, color: Color(0xFF3300C9), height: 1.35),
            caption: TextStyle(
                fontSize: 12.0, color: Color(0xFF3300C9), height: 1.35),
          ),
        ));
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Countdown Timer:',
            ),
            CountDownText(
              due: DateTime.utc(2050),
              finishedText: "Done",
              showLabel: true,
              longDateName: true,
              style: TextStyle(color: Colors.blue),
            ),
            Text(
              'Countdown Timer with custom label:',
            ),
            CountDownText(
              due: DateTime.parse("20-01-01 00:00:00"),
              finishedText: "Done",
              showLabel: true,
              longDateName: true,
              daysTextLong: " DAYS ",
              hoursTextLong: " HOURS ",
              minutesTextLong: " MINUTES ",
              secondsTextLong: " SECONDS ",
              style: TextStyle(color: Colors.blue),
            )
          ],
        ),
      ),
    );
  }
}
