import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final themeProvider = StateNotifierProvider<ThemeNotifier, ThemeMode>((ref) {
  return ThemeNotifier();
});

class ThemeNotifier extends StateNotifier<ThemeMode> {
  static const _themeKey = 'is_dark_theme';

  ThemeNotifier() : super(ThemeMode.light) {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      state = prefs.getBool(_themeKey) ?? false
          ? ThemeMode.dark
          : ThemeMode.light;
    } catch (_) {
      state = ThemeMode.light;
    }
  }

  Future<void> toggleTheme() async {
    await setThemeMode(
        state == ThemeMode.light ? ThemeMode.dark : ThemeMode.light);
  }

  /// **New method** so ProfileScreen can directly set the mode
  Future<void> setThemeMode(ThemeMode mode) async {
    state = mode;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_themeKey, state == ThemeMode.dark);
    } catch (e) {
      debugPrint('Failed to save theme preference: $e');
    }
  }
}
