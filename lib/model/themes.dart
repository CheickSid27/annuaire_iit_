import 'package:flutter/material.dart';

class AppThemes {


  static const primaryColor = Color.fromARGB(255, 240, 3, 3);
  static const secondaryColor = Color.fromARGB(255, 240, 2, 2);
  static const tertiaryColor = Color.fromARGB(214, 253, 41, 41);

  static final MaterialColor materialColor = MaterialColor(0xFFFD297D, swatch);

  static final Map<int, Color> swatch = {
    50: Color.fromARGB(24, 253, 41, 41),
    100: Color.fromARGB(51, 226, 152, 152),
    200: Color.fromARGB(75, 253, 41, 41),
    300: Color.fromARGB(102, 253, 41, 41),
    400: Color.fromARGB(126, 253, 41, 41),
    500: Color.fromARGB(153, 253, 41, 41),
    600: Color.fromARGB(177, 253, 41, 41),
    700: Color.fromARGB(204, 253, 41, 41),
    800: Color.fromARGB(228, 253, 41, 41),
    900: Color.fromARGB(255, 253, 41, 41),
  };


  static final lightTheme = ThemeData(
    brightness: Brightness.light,
     primarySwatch: materialColor,
          colorScheme: ThemeData().colorScheme.copyWith(
              primary: primaryColor,
              secondary: secondaryColor,
              tertiary: tertiaryColor),
    // Définissez d'autres attributs de style pour le mode clair
  );

  static final darkTheme = ThemeData(
    brightness: Brightness.dark,
     primarySwatch: materialColor,
          colorScheme: ThemeData().colorScheme.copyWith(
              primary: primaryColor,
              secondary: secondaryColor,
              tertiary: tertiaryColor),
    // Définissez d'autres attributs de style pour le mode sombre
  );
}
