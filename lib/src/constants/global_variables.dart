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
  static const white = Color(0xFFFFFFFF);

  static const feedbackSelected = Color.fromRGBO(151, 133, 221, 1);

  //for the guard Home page icon (Example: QR code icon)
  static const greyishPurple = Color(0xFFC6B7FF);
  //'Welcome to'
  static const darkPurple = Color(0xFF342763);
  //app Bar loco
  static const locoResidenceColor = Color(0xFF6F58C6);
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

  // Text Styles:
  // Responsive Text Styles
  static double responsiveFontSize(BuildContext context, double fontSize) {
    final screenWidth = MediaQuery.of(context).size.width;

    if (screenWidth < 380) {
      return fontSize * 0.8;
    } else if (screenWidth < 450) {
      return fontSize * 0.9;
    }
    return fontSize; // default font size
  }

  // Log in Title text style
  static TextStyle logInTitleStyle(BuildContext context) => TextStyle(
        fontSize: responsiveFontSize(context, 32),
        color: secondaryColor,
        fontWeight: FontWeight.bold,
      );

  // Log in Subtitle text style
  static TextStyle logInSubtitleStyle(BuildContext context) => TextStyle(
        fontSize: responsiveFontSize(context, 18.0),
        color: Colors.white24,
      );

  // Log in T&C style
  static TextStyle logInTCStyle(BuildContext context) => TextStyle(
        fontSize: responsiveFontSize(context, 14.0),
        color: white,
      );

  //
  static TextStyle headingStyle(BuildContext context) => TextStyle(
        fontSize: responsiveFontSize(context, 30.0),
        fontWeight: FontWeight.bold,
        color: primaryColor,
      );

  // welcome resident style
  static TextStyle welcomeStyle(BuildContext context) => TextStyle(
        fontSize: responsiveFontSize(context, 15.0),
        color: welcomeColor,
      );

  // App Bar texts (Settings/Payment/...)
  static TextStyle appbarStyle(BuildContext context, {Color? color}) =>
      TextStyle(
        fontSize: responsiveFontSize(context, 25.0),
        fontWeight: FontWeight.bold,
        color: color ?? primaryColor,
      );

  // Important Contacts' detail (phone num/address/etc)
  static TextStyle importantDetailStyle(BuildContext context) => TextStyle(
        fontSize: responsiveFontSize(context, 17.0),
        color: white,
      );

  // Service Contacts phone text style
  static TextStyle phoneTextStyle(BuildContext context,
          {bool isPressed = true}) =>
      TextStyle(
        fontSize: responsiveFontSize(context, 17.0),
        color: isPressed ? secondaryColor : white,
      );

  // Service Contacts' & Important Contacts' title (name/etc)
  static TextStyle importantTitleStyle(BuildContext context) => TextStyle(
        fontSize: responsiveFontSize(context, 24.0),
        fontWeight: FontWeight.bold,
        color: white,
      );

  // Bottom Nav Bar selected text
  static TextStyle selectedBottomNavStyle(BuildContext context) => TextStyle(
        fontSize: responsiveFontSize(context, 14.0),
        fontWeight: FontWeight.bold,
      );

  // Bottom Nav Bar unselected text
  static double unselectedBottomNavStyle(BuildContext context) {
    return responsiveFontSize(context, 13.0);
  }

  // Button text
  static TextStyle bold16(BuildContext context, {Color? color = white}) =>
      TextStyle(
        fontSize: responsiveFontSize(context, 16.0),
        fontWeight: FontWeight.bold,
        color: color,
      );

  // List Tile text (Invoice ...)
  static TextStyle listTextStyle(BuildContext context) => TextStyle(
        fontSize: responsiveFontSize(context, 16.0),
        color: Colors.black,
      );

  // No Results text (Visitor history serach)
  static TextStyle noResultStyle(BuildContext context) => TextStyle(
        fontSize: responsiveFontSize(context, 16.0),
        color: primaryGrey,
        fontWeight: FontWeight.bold,
      );

  // Visitor history container header (this week/month/etc)
  static TextStyle visitorHistoryTitleStyle(BuildContext context) => TextStyle(
        fontSize: responsiveFontSize(context, 16.0),
        fontWeight: FontWeight.bold,
        color: Colors.black54,
      );

  // Visitor history container subtitle (name)
  static TextStyle bold20(BuildContext context, Color color) => TextStyle(
        fontSize: responsiveFontSize(context, 20.0),
        color: color,
        fontWeight: FontWeight.bold,
      );

  // Visitor history container subtitle (name)
  static TextStyle visitorHistoryDetail(BuildContext context,
          {bool isBold = true}) =>
      TextStyle(
        fontSize: responsiveFontSize(context, 16.0),
        color: white,
        fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
      );

  // Text field label style
  static TextStyle labelStyle(BuildContext context) => TextStyle(
        color: textLabel,
        fontSize: responsiveFontSize(context, 16.0),
        fontWeight: FontWeight.w700,
      );

  // Text field
  static TextStyle floatingLabelStyle(BuildContext context) => TextStyle(
        color: textLabel,
        fontSize: responsiveFontSize(context, 15.0),
        fontWeight: FontWeight.bold,
      );

  // Bottom Sheet Title (Notifications)
  static TextStyle notifTitleStyle(BuildContext context) => TextStyle(
        color: primaryColor,
        fontSize: responsiveFontSize(context, 18.0),
        fontWeight: FontWeight.bold,
      );

  // Facility Info Title
  static TextStyle facilityTitleStyle(BuildContext context) => TextStyle(
        color: white,
        fontSize: responsiveFontSize(context, 40.0),
        fontWeight: FontWeight.bold,
      );

  // Facility Info Open time
  static TextStyle facilityOpenTimeStyle(BuildContext context) => TextStyle(
        color: Colors.white.withOpacity(0.8),
        fontSize: responsiveFontSize(context, 19),
        fontWeight: FontWeight.bold,
      );

  // Facility Info Details
  static TextStyle facilityDetailsStyle(BuildContext context) => TextStyle(
        color: Colors.white.withOpacity(0.8),
        fontSize: responsiveFontSize(context, 15),
        fontWeight: FontWeight.normal,
      );

  // Facility Info Booking "choose a date" etc style
  static TextStyle facilityBookingStyle(BuildContext context) => TextStyle(
        color: primaryColor,
        fontSize: responsiveFontSize(context, 25),
        fontWeight: FontWeight.bold,
      );

  // Icon style
  // Responsive Icon Size
  static double responsiveIconSize(BuildContext context, double iconSize) {
    final screenWidth = MediaQuery.of(context).size.width;

    if (screenWidth < 380) {
      return iconSize * 0.8;
    } else if (screenWidth < 450) {
      return iconSize * 0.9;
    }
    return iconSize; // default icon size
  }

  // Back Button
  static IconButton backButton(BuildContext context, {Color? color}) =>
      IconButton(
        icon: Icon(
          Icons.arrow_back_ios,
          color:
              color ?? primaryColor, // Default to primaryColor if color is null
        ),
        onPressed: () {
          Navigator.of(context).pop();
        },
      );
}
