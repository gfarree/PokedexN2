import 'package:flutter/material.dart';

class ThemeProvider with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;

  ThemeMode get themeMode => _themeMode;

  void toggleTheme([bool? isDark]) {
    _themeMode = isDark != null
        ? (isDark ? ThemeMode.dark : ThemeMode.light)
        : (_themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light);
    notifyListeners();
  }
}