import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/themes/theme_provider.dart';
import '../constants/global_variables.dart';

Widget homeTile(BuildContext context, int index, String tileName, IconData icon,
    bool isSelected) {
  final mode = Provider.of<ThemeProvider>(context);
  Color boxShadowColor = const Color.fromARGB(255, 42, 188, 69);

  return Container(
    width: double.infinity,
    padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 1),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(20),
      color: isSelected
          ? GlobalVariables.primaryColor
          : GlobalVariables.secondaryColor,
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
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(width: 10),
        Icon(
          icon,
          color: isSelected ? Colors.white : GlobalVariables.primaryColor,
          size: GlobalVariables.responsiveIconSize(context, 30.0),
        ),
        const SizedBox(width: 15),
        Text(
          tileName,
          style: GlobalVariables.bold20(
            context,
            isSelected ? Colors.white : GlobalVariables.primaryColor,
          ),
        ),
      ],
    ),
  );
}
