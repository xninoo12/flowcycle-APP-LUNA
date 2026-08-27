import 'package:flutter/material.dart';

/// Central reactive controller for managing the active application locale and language preferences.
class LocaleController extends ChangeNotifier {
  static final LocaleController instance = LocaleController._internal();
  factory LocaleController() => instance;
  LocaleController._internal();

  Locale _currentLocale = const Locale('en');

  Locale get currentLocale => _currentLocale;

  static const List<Locale> supportedLocales = [
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('de'),
  ];

  static const Map<String, String> languageDisplayNames = {
    'en': 'English (US)',
    'es': 'Español (Spanish)',
    'fr': 'Français (French)',
    'de': 'Deutsch (German)',
  };

  static const Map<String, String> languageNativeNames = {
    'en': 'English',
    'es': 'Español',
    'fr': 'Français',
    'de': 'Deutsch',
  };

  static const Map<String, String> languageFlags = {
    'en': '🇺🇸',
    'es': '🇪🇸',
    'fr': '🇫🇷',
    'de': '🇩🇪',
  };

  String get currentLanguageName =>
      languageDisplayNames[_currentLocale.languageCode] ?? 'English (US)';

  String get currentLanguageFlag =>
      languageFlags[_currentLocale.languageCode] ?? '🇺🇸';

  void setLocale(Locale locale) {
    if (supportedLocales.any((l) => l.languageCode == locale.languageCode)) {
      if (_currentLocale.languageCode != locale.languageCode) {
        _currentLocale = locale;
        notifyListeners();
      }
    }
  }

  void setLanguageCode(String code) {
    setLocale(Locale(code));
  }
}
