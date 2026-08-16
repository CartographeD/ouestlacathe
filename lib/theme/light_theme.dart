import 'package:flutter/material.dart';

final ThemeData lightTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.light,

  fontFamily: 'Outfit',

  scaffoldBackgroundColor: const Color(0xffFAF8F3),

  colorScheme: const ColorScheme.light(
    primary: Color(0xffD64045),
    surface: Color(0xffFAF8F3),
  ),

  dividerColor: const Color(0xffE5E2DB),

  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xffFAF8F3),
    elevation: 0,
    centerTitle: true,
  ),

  textTheme: const TextTheme(
    headlineLarge: TextStyle(
      color: Color(0xff1C1C1C),
      fontWeight: FontWeight.bold,
    ),
    headlineMedium: TextStyle(
      color: Color(0xff1C1C1C),
      fontWeight: FontWeight.bold,
    ),
    bodyLarge: TextStyle(
      color: Color(0xff1C1C1C),
    ),
    bodyMedium: TextStyle(
      color: Color(0xff6A6A6A),
    ),
  ),
);