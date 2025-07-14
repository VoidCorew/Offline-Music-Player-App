import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class ThemeProvider extends ChangeNotifier {
  bool _isDark = false;
  // for saving selected theme
  final Box _settingsBox = Hive.box('settings');

  ThemeProvider() {
    _isDark = _settingsBox.get('isDark', defaultValue: false);
  }

  bool get isDark => _isDark;

  ThemeMode get currentTheme => _isDark ? ThemeMode.dark : ThemeMode.light;

  void toggleTheme() {
    _isDark = !_isDark;
    _settingsBox.put('isDark', _isDark);
    notifyListeners();
  }

  void setDark(bool value) {
    _isDark = value;
    _settingsBox.put('isDark', _isDark);
    notifyListeners();
  }
}
