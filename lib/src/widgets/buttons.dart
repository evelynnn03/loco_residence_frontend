import 'package:flutter/material.dart';
import '../constants/global_variables.dart';

class MyButton extends StatelessWidget {
  final Function()? onTap;
  final String text;
  final Color color;
  final Color textColor;

  const MyButton({super.key, this.onTap, required this.text, this.color = GlobalVariables.primaryColor, this.textColor = GlobalVariables.white});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0),
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(25)),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 7.0),
              child: Text(
                text,
                style: GlobalVariables.bold16(context, color: textColor),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
