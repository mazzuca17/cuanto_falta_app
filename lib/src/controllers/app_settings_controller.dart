import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppSettingsController {
  static const _themeModeKey = 'theme_mode';
  static const _localeCodeKey = 'locale_code';

  ThemeMode themeMode = ThemeMode.system;
  Locale locale = const Locale('es');

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final rawTheme = prefs.getString(_themeModeKey);
    final rawLocale = prefs.getString(_localeCodeKey);

    themeMode = ThemeMode.values.firstWhere(
      (item) => item.name == rawTheme,
      orElse: () => ThemeMode.system,
    );

    if (rawLocale != null && rawLocale.isNotEmpty) {
      locale = Locale(rawLocale);
    }
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    themeMode = mode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themeModeKey, mode.name);
  }

  Future<void> setLocale(Locale value) async {
    locale = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_localeCodeKey, value.languageCode);
  }
}
