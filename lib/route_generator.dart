import 'package:cuanto_falta_app/src/l10n/app_strings.dart';
import 'package:cuanto_falta_app/src/pages/home.dart';
import 'package:flutter/material.dart';

class RouteGenerator {
  static const String homeRoute = '/home';

  static Route<dynamic> generateRoute(
    RouteSettings settings, {
    required ValueChanged<ThemeMode> onThemeChanged,
    required ValueChanged<Locale> onLocaleChanged,
    required ThemeMode currentThemeMode,
    required Locale currentLocale,
  }) {
    switch (settings.name?.toLowerCase()) {
      case homeRoute:
      case '/':
        return MaterialPageRoute(
          builder: (_) => MyHomePage(
            onThemeChanged: onThemeChanged,
            onLocaleChanged: onLocaleChanged,
            currentThemeMode: currentThemeMode,
            currentLocale: currentLocale,
          ),
        );
      default:
        return MaterialPageRoute(
          builder: (context) {
            final strings = AppStrings.of(context);
            return Scaffold(
              appBar: AppBar(),
              body: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(strings.routeError),
                    const SizedBox(height: 12),
                    FilledButton(
                      onPressed: () => Navigator.of(context)
                          .pushNamedAndRemoveUntil(homeRoute, (_) => false),
                      child: Text(strings.backToHome),
                    )
                  ],
                ),
              ),
            );
          },
        );
    }
  }
}
