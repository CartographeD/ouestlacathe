import 'package:flutter/material.dart';

class AppColors {
  // Couleur principale de l'application
  static const accent = Color(0xffD64045);

  // Fond
  static Color background(BuildContext context) {
    return Theme.of(context).scaffoldBackgroundColor;
  }

  // Texte principal
  static Color text(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? const Color(0xffF6F4EF)
        : const Color(0xff1C1C1C);
  }

  // Texte secondaire
  static Color secondary(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? const Color(0xff9B9B9B)
        : const Color(0xff6A6A6A);
  }

  // Séparateurs
  static Color divider(BuildContext context) {
    return Theme.of(context).dividerColor;
  }

  // Icônes
  static Color icon(BuildContext context) {
    return text(context);
  }

  // Cartes / panneaux
  static Color surface(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? const Color(0xff181818)
        : Colors.white;
  }
}