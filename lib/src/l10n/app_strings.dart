import 'package:flutter/widgets.dart';

class AppStrings {
  AppStrings(this.locale);

  final Locale locale;

  static const supportedLocales = [Locale('es'), Locale('en')];

  static AppStrings of(BuildContext context) {
    final strings = Localizations.of<AppStrings>(context, AppStrings);
    assert(strings != null, 'AppStrings not found in context');
    return strings!;
  }

  static const LocalizationsDelegate<AppStrings> delegate =
      _AppStringsDelegate();

  static const Map<String, Map<String, String>> _localized = {
    'es': {
      'appTitle': 'Cuánto falta para...',
      'newEvent': 'Nuevo evento',
      'pickDateTime': 'Elegir fecha y hora',
      'cancel': 'Cancelar',
      'save': 'Guardar',
      'eventHint': 'Ej: Juntada fin de año',
      'loading': 'Cargando...',
      'myCountdowns': 'Mis cuentas regresivas',
      'noEvents': 'Todavía no cargaste eventos personalizados.',
      'activeEvent': 'Evento activo',
      'remaining': 'Faltan',
      'progressOf': 'Progreso de',
      'notifyWhenFinished': 'Notificarme cuando termine',
      'theme': 'Tema',
      'language': 'Idioma',
      'light': 'Claro',
      'dark': 'Oscuro',
      'system': 'Sistema',
      'routeError': 'Ruta no encontrada',
      'backToHome': 'Volver al inicio',
      'noSelectedEvent': 'Sin evento seleccionado',
      'eventFinishedTitle': 'Evento finalizado',
      'newYearTitle': '¡Feliz Año Nuevo!',
      'newYearBody': 'Arrancó el nuevo año.',
      'day': 'Día',
      'week': 'Semana',
      'month': 'Mes',
      'year': 'Año',
    },
    'en': {
      'appTitle': 'How long until...',
      'newEvent': 'New event',
      'pickDateTime': 'Pick date and time',
      'cancel': 'Cancel',
      'save': 'Save',
      'eventHint': 'Ex: New year meetup',
      'loading': 'Loading...',
      'myCountdowns': 'My countdowns',
      'noEvents': 'You have no custom events yet.',
      'activeEvent': 'Active event',
      'remaining': 'Remaining',
      'progressOf': 'Progress of',
      'notifyWhenFinished': 'Notify me when finished',
      'theme': 'Theme',
      'language': 'Language',
      'light': 'Light',
      'dark': 'Dark',
      'system': 'System',
      'routeError': 'Route not found',
      'backToHome': 'Go back home',
      'noSelectedEvent': 'No selected event',
      'eventFinishedTitle': 'Event finished',
      'newYearTitle': 'Happy New Year!',
      'newYearBody': 'The new year has started.',
      'day': 'Day',
      'week': 'Week',
      'month': 'Month',
      'year': 'Year',
    }
  };

  String _t(String key) {
    final lang = _localized.containsKey(locale.languageCode)
        ? locale.languageCode
        : 'es';
    return _localized[lang]![key] ?? key;
  }

  String get appTitle => _t('appTitle');
  String get newEvent => _t('newEvent');
  String get pickDateTime => _t('pickDateTime');
  String get cancel => _t('cancel');
  String get save => _t('save');
  String get eventHint => _t('eventHint');
  String get loading => _t('loading');
  String get myCountdowns => _t('myCountdowns');
  String get noEvents => _t('noEvents');
  String get activeEvent => _t('activeEvent');
  String get remaining => _t('remaining');
  String get progressOf => _t('progressOf');
  String get notifyWhenFinished => _t('notifyWhenFinished');
  String get theme => _t('theme');
  String get language => _t('language');
  String get light => _t('light');
  String get dark => _t('dark');
  String get system => _t('system');
  String get routeError => _t('routeError');
  String get backToHome => _t('backToHome');
  String get noSelectedEvent => _t('noSelectedEvent');
  String get eventFinishedTitle => _t('eventFinishedTitle');
  String get newYearTitle => _t('newYearTitle');
  String get newYearBody => _t('newYearBody');

  String labelForRange(String rangeKey) => _t(rangeKey);
}

class _AppStringsDelegate extends LocalizationsDelegate<AppStrings> {
  const _AppStringsDelegate();

  @override
  bool isSupported(Locale locale) => AppStrings.supportedLocales
      .any((l) => l.languageCode == locale.languageCode);

  @override
  Future<AppStrings> load(Locale locale) async => AppStrings(locale);

  @override
  bool shouldReload(covariant LocalizationsDelegate<AppStrings> old) => false;
}
