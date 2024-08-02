import 'package:flutter/material.dart';

class GlobalVariables {
  static const primaryColor = Color(0xFF0B3979);
  static const secondaryColor = Color(0xFFEDF0F5);
  static const bottomNavIcons = Color(0xFFD0E4FF);
  static const bottomNavSelectedIcons = Color(0xFFF7F2EC);
  static const welcomeColor = Color(0xFF6F96D1);
  static const textLabel = Color(0xFFB0B2B4);
  static const tabNotSelected = Color(0xFFA0AEC1);
  static const lightGrey = Color(0xFFD9D9D9); // remove card

  static const feedbackSelected = Color.fromRGBO(151, 133, 221, 1);

  //for the guard Home page icon (Example: QR code icon)
  static const greyishPurple = Color(0xFFC6B7FF);
  //'Welcome to'
  static const darkPurple = Color(0xFF342763);
  //app Bar loco
  static const locoResidenceColor = Color(0xFF6F58C6);
  static const backgroundColor = Color(0xFFFFFFFF);
  //the opacity still need to change
  static const analyticsBarColor = Color.fromARGB(18, 24, 24, 24);
  //the opacity still need to change
  static const analyticsBarSelectorhColor = Color.fromARGB(18, 255, 255, 255);
  //for the Hola XXX
  static const primaryGrey = Color(0xFFAFAFAF);
  //for the small small grey words
  static const secondaryGrey = Color(0xFF808080);

//can put in container -> boxdecoration -> gradient: GlobleVariables.purpleGradient
  static const purpleGradient = LinearGradient(
    colors: [
      Color.fromRGBO(129, 101, 234, 1),
      Color.fromRGBO(178, 158, 255, 1),
    ],
    stops: [0.5, 1.0],
  );
}
