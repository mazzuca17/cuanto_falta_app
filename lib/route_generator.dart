import 'package:flutter/material.dart';
import 'src/pages/splash_screnn.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    /// Obtener argumentos pasados al llamar a Navigator.pushNamed
    final args = settings.arguments;
    switch (settings.name) {
      case '/Splash':
        return MaterialPageRoute(
          builder: (_) => SplashScreen(),
        );
      default:
        // If there is no such named route in the switch statement, e.g. /third
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: SafeArea(
              child: Text(
                'Route Error',
              ),
            ),
          ),
        );
    }
  }
}
