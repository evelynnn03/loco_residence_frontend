import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  bool _isDark = false;
  bool get isDark => _isDark;

  // SharedPreferences key for the theme preference
  static const String _themeKey = 'theme';

  ThemeProvider() {
    // Load the theme preference from SharedPreferences when the provider is initialized
    _loadThemePreference();
  }

  // Load the theme preference from SharedPreferences
  Future<void> _loadThemePreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _isDark = prefs.getBool(_themeKey) ?? false;
    notifyListeners();
  }

  // Toggle the theme and save the preference to SharedPreferences
  void changeTheme() async {
    _isDark = !_isDark;
    notifyListeners();
    // Save the theme preference to SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(_themeKey, _isDark);
    print(isDark);
  }
}
