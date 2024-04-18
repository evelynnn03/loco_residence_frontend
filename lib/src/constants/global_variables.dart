import 'package:flutter/material.dart';

class GlobalVariables {
  static const feedbackSelected = Color.fromRGBO(151, 133, 221, 1);
  static const primaryColor = Color(0xFF8165EA);
  static const secondaryColor = Color.fromRGBO(178, 158, 255, 1);
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
