import 'package:flutter/material.dart';

class ThemeController {
  static final ValueNotifier<ThemeMode> mode =
      ValueNotifier<ThemeMode>(ThemeMode.dark);

  static void toggle() {
    final next =
        mode.value == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    mode.value = next;
  }
}
