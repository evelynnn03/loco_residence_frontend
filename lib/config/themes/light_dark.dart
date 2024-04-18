import 'package:flutter/material.dart';

import '../../src/constants/global_variables.dart';

class LightDark {
  static final lightTheme = ThemeData(
    primaryColor: GlobalVariables.primaryColor, // purple background color
    cardColor: GlobalVariables.primaryColor, // container color (box decoration)
    scaffoldBackgroundColor:
        GlobalVariables.backgroundColor, // white background color
    canvasColor: GlobalVariables.secondaryColor, // text field color
    indicatorColor: GlobalVariables.primaryColor,
    focusColor: GlobalVariables.secondaryColor,

    appBarTheme: const AppBarTheme(
      color: GlobalVariables.primaryColor,
      iconTheme: IconThemeData(
        color: GlobalVariables.backgroundColor,
      ),
    ),

    textTheme: const TextTheme(
      bodyMedium: TextStyle(
        color: GlobalVariables.darkPurple,
      ),
      bodySmall: TextStyle(
        color: GlobalVariables.primaryColor,
      ),
      bodyLarge: TextStyle(color: GlobalVariables.primaryColor),
    ),

    buttonTheme: ButtonThemeData(
      colorScheme: ColorScheme.light(
        primary: GlobalVariables.secondaryColor,
        secondary: GlobalVariables.feedbackSelected,
      ),
    ),

    dialogBackgroundColor: const Color.fromARGB(255, 235, 230, 255),

    bottomNavigationBarTheme:
        BottomNavigationBarThemeData(backgroundColor: Colors.white),
  );

  static final darkTheme = ThemeData(
    primaryColor: Color(0xFF110022),
    cardColor: Color(0xFF110022),
    scaffoldBackgroundColor: Color(0xFF110022),
    canvasColor: Color.fromARGB(255, 118, 118, 118),
    indicatorColor: GlobalVariables.greyishPurple,
    focusColor: Color.fromARGB(255, 58, 58, 58),
    appBarTheme: const AppBarTheme(
      color: GlobalVariables.greyishPurple,
      iconTheme: IconThemeData(color: GlobalVariables.secondaryColor),
    ),
    textTheme: const TextTheme(
      bodyMedium: TextStyle(
        color: GlobalVariables.secondaryColor,
      ),
      bodySmall: TextStyle(
        color: GlobalVariables.greyishPurple,
      ),
      bodyLarge: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
    ),
    buttonTheme: ButtonThemeData(
      colorScheme: ColorScheme.dark(
        primary: Color.fromARGB(255, 80, 80, 80),
        secondary: Color.fromARGB(255, 118, 118, 118),
      ),
    ),
    dialogBackgroundColor: Color.fromARGB(211, 0, 0, 0),
    bottomNavigationBarTheme:
        BottomNavigationBarThemeData(backgroundColor: Color(0xFF110022)),
  );
}

