// Define the colors
import 'package:flutter/material.dart';

const Color primaryColor = Color(0xFF8c4742);
const Color secondaryColor = Color(0xFFc4673d);
const Color tertiaryColor = Color(0xFF1f3b54);
const Color successColor = Color(0xFF61a720);
const Color infoColor = Color(0xFFc38f37);
const Color warningColor = Color(0xFFfec16f);
const Color dangerColor = Color(0xFF982828);
const Color lightColor = Color(0xFFebdfd8);
const Color darkColor = Color(0xFF191d00);
const Color accentColor1 = Color(0xFF6e444c);
const Color accentColor2 = Color(0xFF916364);
const Color accentColor3 = Color(0xFFa6c198);

// Define your theme
final ThemeData flutterHMIColour = ThemeData(
  colorScheme: ColorScheme.fromSeed(
      seedColor: primaryColor,
      primary: primaryColor,
      secondary: secondaryColor,
      tertiary: tertiaryColor,
      error: dangerColor,
      outline: accentColor1,
      background: lightColor,
      surface: lightColor,
      inverseSurface: darkColor,
      inversePrimary: lightColor,
      brightness: Brightness.light),
  useMaterial3: true,
  // Default app bar theme
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.transparent,
    centerTitle: true,
    titleTextStyle: TextStyle(
      color: darkColor,
    ),
  ),
  // Default snack bar theme
  snackBarTheme: const SnackBarThemeData(
    actionTextColor: Colors.white,
    contentTextStyle: TextStyle(color: Colors.white),
    insetPadding: EdgeInsets.all(20.0),
    // set indicator color
    behavior: SnackBarBehavior.floating,
  ),
  // Default input decoration theme
  inputDecorationTheme: const InputDecorationTheme(
    border: OutlineInputBorder(),
    contentPadding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: primaryColor,
      foregroundColor: lightColor,
      disabledForegroundColor: Colors.white,
      disabledBackgroundColor: Colors.grey,
    ),
  ),
);
