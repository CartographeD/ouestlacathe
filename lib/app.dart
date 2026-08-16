import 'package:flutter/material.dart';

import 'screens/home_screen.dart';
import 'theme/light_theme.dart';
import 'theme/dark_theme.dart';

class CatheApp extends StatelessWidget {
  const CatheApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Où est la Cathé ?",

      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.system,

      home: const HomeScreen(),
    );
  }
}