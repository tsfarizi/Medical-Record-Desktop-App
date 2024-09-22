import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:medgis_app/utils/theme/color_scheme.dart';

ThemeData themeData = ThemeData(
    visualDensity: VisualDensity.adaptivePlatformDensity,
    textTheme: TextTheme(
        headlineLarge: TextStyle(
            color: colorScheme.primary,
            fontWeight: FontWeight.bold,
            letterSpacing: 2),
        bodyLarge: TextStyle(
            color: colorScheme.onSurface, fontWeight: FontWeight.bold)),
    fontFamily: GoogleFonts.poppins().fontFamily,
    iconTheme: IconThemeData(color: colorScheme.secondary),
    iconButtonTheme: IconButtonThemeData(
        style: ButtonStyle(
            iconColor: WidgetStatePropertyAll(colorScheme.primary))),
    colorScheme: colorScheme);
