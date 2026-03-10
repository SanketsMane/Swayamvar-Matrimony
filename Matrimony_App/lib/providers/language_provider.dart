import 'package:flutter/material.dart';
import '../helpers/shared_pref.dart';

class LanguageProvider with ChangeNotifier {
  Locale _appLocale = const Locale('en'); // Sanket: Default English

  Locale get appLocale => _appLocale;

  LanguageProvider() {
    _loadLocale();
  }

  void _loadLocale() {
    String? languageCode = SharedPref().language;
    if (languageCode != null) {
      _appLocale = Locale(languageCode);
    } else {
      // Sanket: Fallback to English if no language is saved
      _appLocale = const Locale('en');
    }
    notifyListeners();
  }

  void setLocale(Locale type) async {
    if (_appLocale == type) return;

    if (type == const Locale("mr")) {
      _appLocale = const Locale("mr");
      SharedPref().language = "mr";
    } else {
      _appLocale = const Locale("en");
      SharedPref().language = "en";
    }
    notifyListeners();
  }
}
