import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants/global_variables.dart';
import '../../config/themes/theme_provider.dart';
import 'reset_password_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final mode = Provider.of<ThemeProvider>(context);
    Color boxShadowColor = Color.fromRGBO(130, 101, 234, 0.769);
    Color cardColor = Theme.of(context).cardColor;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Settings',
          style: TextStyle(
              color: Theme.of(context).textTheme.bodySmall?.color ??
                  GlobalVariables.primaryColor,
              fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        // foregroundColor: GlobalVariables.backgroundColor,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 15.0, right: 15, bottom: 15),
            child: Container(
              height: 80,
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(10),
                boxShadow: mode.isDark
                    ? [
                        BoxShadow(
                          color: boxShadowColor,
                          offset: const Offset(
                            0.0,
                            0.0,
                          ),
                          blurRadius: 8.0,
                          spreadRadius: 0.0,
                        ), //BoxShadow
                        //BoxShadow
                      ]
                    : null,
              ),
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Reset Password ',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, ResetPassword.routeName);
                      },
                      child: Icon(
                        Icons.arrow_circle_right_outlined,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              left: 15,
              right: 15,
            ),
            child: Container(
              height: 80,
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(10),
                boxShadow: mode.isDark
                    ? [
                        BoxShadow(
                          color: boxShadowColor,
                          offset: const Offset(
                            0.0,
                            0.0,
                          ),
                          blurRadius: 8.0,
                          spreadRadius: 0.0,
                        ), //BoxShadow
                        //BoxShadow
                      ]
                    : null,
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Light/Dark Mode ',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        mode.changeTheme();
                      },
                      child: Icon(
                        mode.isDark ? Icons.light_mode : Icons.dark_mode,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
