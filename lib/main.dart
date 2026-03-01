import 'package:cuanto_falta_app/route_generator.dart';
import 'package:cuanto_falta_app/src/controllers/app_settings_controller.dart';
import 'package:cuanto_falta_app/src/l10n/app_strings.dart';
import 'package:cuanto_falta_app/src/services/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.instance.init();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final AppSettingsController _settings = AppSettingsController();
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    await _settings.init();
    if (!mounted) return;
    setState(() {
      _loaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_loaded) {
      return const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(body: Center(child: CircularProgressIndicator())),
      );
    }

    return MaterialApp(
      title: 'Cuánto Falta para?',
      initialRoute: RouteGenerator.homeRoute,
      onGenerateRoute: (settings) => RouteGenerator.generateRoute(
        settings,
        onThemeChanged: (mode) async {
          await _settings.setThemeMode(mode);
          if (!mounted) return;
          setState(() {});
        },
        onLocaleChanged: (locale) async {
          await _settings.setLocale(locale);
          if (!mounted) return;
          setState(() {});
        },
        currentThemeMode: _settings.themeMode,
        currentLocale: _settings.locale,
      ),
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        AppStrings.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppStrings.supportedLocales,
      locale: _settings.locale,
      themeMode: _settings.themeMode,
      theme: ThemeData(
        fontFamily: 'Poppins',
        brightness: Brightness.light,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF3300C9)),
      ),
      darkTheme: ThemeData(
        fontFamily: 'Poppins',
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF4BF4A2),
          brightness: Brightness.dark,
        ),
      ),
    );
  }
}
