import 'package:date_count_down/date_count_down.dart';
import 'package:flutter/material.dart';
import 'package:global_configuration/global_configuration.dart';

import 'route_generator.dart';

import 'src/helpers/app_config.dart' as config;

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
      locale: _setting.mobileLanguage.value,
      localizationsDelegates: [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      theme: _setting.brightness.value == Brightness.light
          ? ThemeData(
              // fontFamily: 'Poppins',
              fontFamily: 'Josefin Sans',
              primaryColor: Colors.white,
              floatingActionButtonTheme: FloatingActionButtonThemeData(
                  elevation: 0, foregroundColor: Colors.white),
              brightness: Brightness.light,
              accentColor: config.Colors().mainColor(1),
              dividerColor: config.Colors().accentColor(0.1),
              focusColor: config.Colors().accentColor(1),
              hintColor: config.Colors().secondColor(1),
              textTheme: TextTheme(
                headline5: TextStyle(
                    fontSize: 20.0,
                    color: config.Colors().secondColor(1),
                    height: 1.35),
                headline4: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w600,
                    color: config.Colors().secondColor(1),
                    height: 1.35),
                headline3: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w600,
                    color: config.Colors().secondColor(1),
                    height: 1.35),
                headline2: TextStyle(
                    fontSize: 22.0,
                    fontWeight: FontWeight.w700,
                    color: config.Colors().mainColor(1),
                    height: 1.35),
                headline1: TextStyle(
                    fontSize: 22.0,
                    fontWeight: FontWeight.w300,
                    color: config.Colors().secondColor(1),
                    height: 1.5),
                subtitle1: TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.w500,
                    color: config.Colors().secondColor(1),
                    height: 1.35),
                headline6: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                    color: config.Colors().mainColor(1),
                    height: 1.35),
                bodyText2: TextStyle(
                    fontSize: 12.0,
                    color: config.Colors().secondColor(1),
                    height: 1.35),
                bodyText1: TextStyle(
                    fontSize: 14.0,
                    color: config.Colors().secondColor(1),
                    height: 1.35),
                caption: TextStyle(
                    fontSize: 12.0,
                    color: config.Colors().accentColor(1),
                    height: 1.35),
              ),
            )
          : ThemeData(
              fontFamily: 'Poppins',
              primaryColor: Color(0xFF252525),
              brightness: Brightness.dark,
              scaffoldBackgroundColor: Color(0xFF2C2C2C),
              accentColor: config.Colors().mainDarkColor(1),
              dividerColor: config.Colors().accentColor(0.1),
              hintColor: config.Colors().secondDarkColor(1),
              focusColor: config.Colors().accentDarkColor(1),
              textTheme: TextTheme(
                headline5: TextStyle(
                    fontSize: 20.0,
                    color: config.Colors().secondDarkColor(1),
                    height: 1.35),
                headline4: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w600,
                    color: config.Colors().secondDarkColor(1),
                    height: 1.35),
                headline3: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w600,
                    color: config.Colors().secondDarkColor(1),
                    height: 1.35),
                headline2: TextStyle(
                    fontSize: 22.0,
                    fontWeight: FontWeight.w700,
                    color: config.Colors().mainDarkColor(1),
                    height: 1.35),
                headline1: TextStyle(
                    fontSize: 22.0,
                    fontWeight: FontWeight.w300,
                    color: config.Colors().secondDarkColor(1),
                    height: 1.5),
                subtitle1: TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.w500,
                    color: config.Colors().secondDarkColor(1),
                    height: 1.35),
                headline6: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                    color: config.Colors().mainDarkColor(1),
                    height: 1.35),
                bodyText2: TextStyle(
                    fontSize: 12.0,
                    color: config.Colors().secondDarkColor(1),
                    height: 1.35),
                bodyText1: TextStyle(
                    fontSize: 14.0,
                    color: config.Colors().secondDarkColor(1),
                    height: 1.35),
                caption: TextStyle(
                    fontSize: 12.0,
                    color: config.Colors().secondDarkColor(0.6),
                    height: 1.35),
              ),
            ),
    );
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
