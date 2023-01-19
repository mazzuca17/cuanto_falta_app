import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'route_generator.dart';
import 'package:google_fonts/google_fonts.dart';

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
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: [
          const Locale('en'), // Inglés
          const Locale('es'), // Español
        ],
        theme: ThemeData(
          fontFamily: 'Poppins',
          primaryColor: Color(0xFF252525),
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
