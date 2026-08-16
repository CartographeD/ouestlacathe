import 'package:flutter/material.dart';

final ThemeData darkTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,

  fontFamily: 'Outfit',

  scaffoldBackgroundColor: const Color(0xff111111),

  colorScheme: const ColorScheme.dark(
    primary: Color(0xffD64045),
    surface: Color(0xff111111),
  ),

  dividerColor: const Color(0xff2A2A2A),

  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xff111111),
    elevation: 0,
    centerTitle: true,
  ),

  textTheme: const TextTheme(
    headlineLarge: TextStyle(
      color: Color(0xffF6F4EF),
      fontWeight: FontWeight.bold,
    ),
    headlineMedium: TextStyle(
      color: Color(0xffF6F4EF),
      fontWeight: FontWeight.bold,
    ),
    bodyLarge: TextStyle(
      color: Color(0xffF6F4EF),
    ),
    bodyMedium: TextStyle(
      color: Color(0xffA0A0A0),
    ),
  ),
);