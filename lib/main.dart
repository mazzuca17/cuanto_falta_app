import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
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
        initialRoute: '/Home',
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
          dividerColor: Color(0xFF3300C9),
          focusColor: Color(0xFF3300C9),
          hintColor: Color(0xFF3300C9),
          textTheme: TextTheme(
           
          ),
        ));
  }
}
