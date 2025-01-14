import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/core.dart';

class ThemeNotifier extends StateNotifier<ThemeMode> {
  ThemeNotifier() : super(ThemeMode.system) {
    _initializeThemeFromSharedPrefs();
  }

  void _initializeThemeFromSharedPrefs() {
    final isDarkMode = SharedPrefs.instance.getBool(AppKeys.kDarkMode) ?? false;
    state = _getThemeMode(isDarkMode);
  }

  void changeTheme(bool isDarkMode) {
    state = _getThemeMode(isDarkMode);
    SharedPrefs.instance.setBool(AppKeys.kDarkMode, isDarkMode);
  }

  ThemeMode _getThemeMode(bool isDarkMode) {
    return isDarkMode ? ThemeMode.dark : ThemeMode.light;
  }
}
