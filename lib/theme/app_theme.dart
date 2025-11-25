import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

ThemeData buildDarkTheme() {
  return ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: AppColors.background,
    cardColor: AppColors.surface,
    textTheme: GoogleFonts.poppinsTextTheme(
      ThemeData.dark().textTheme,
    ).apply(bodyColor: Colors.white, displayColor: Colors.white),
    colorScheme: ColorScheme.dark(
      primary: AppColors.accent,
      secondary: AppColors.muted,
      surface: AppColors.surface,
    ),
    iconTheme: const IconThemeData(color: Colors.white),
  );
}
