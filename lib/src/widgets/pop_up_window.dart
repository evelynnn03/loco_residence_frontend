import 'package:flutter/material.dart';
import '../constants/global_variables.dart';
import 'buttons.dart';

class Popup {
  final String title;
  final Widget content;
  final List<ButtonConfig> buttons;
  final TextAlign textAlign;

  Popup({
    required this.title,
    required this.content,
    required this.buttons,
    this.textAlign = TextAlign.center,
  });

  Future<void> show(BuildContext context) async {
    Color popUpBackground = Theme.of(context).dialogBackgroundColor;
    // TextStyle? text = Theme.of(context).textTheme.bodyLarge ?? TextStyle();

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          title,
          style: GlobalVariables.bold20(context, GlobalVariables.primaryColor),
          textAlign: TextAlign.center,
        ),
        content: SingleChildScrollView(
          child: DefaultTextStyle(
            style: const TextStyle(color: GlobalVariables.primaryColor),
            textAlign: textAlign,
            child: content,
          ),
        ),
        backgroundColor: popUpBackground,
        actions: [
          for (var i = 0; i < buttons.length; i++)
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                MyButton(
                  onTap: () {
                    buttons[i].onPressed?.call();
                    Navigator.pop(context);
                  },
                  text: buttons[i].text,
                ),
                if (i < buttons.length - 1)
                  const SizedBox(height: 13), // Add SizedBox between buttons
              ],
            ),
        ],
      ),
    );
  }
}

class ButtonConfig {
  final String text;
  final VoidCallback? onPressed;

  ButtonConfig({required this.text, this.onPressed});
}

// Example usage:
// Popup(
//   title: 'Visitor Details',
//   content: 'Your content here',
//   buttons: [
//     ButtonConfig(
//       text: 'Confirm',
//       onPressed: () {
//         // Your logic when Confirm button is pressed
//       },
//     ),
//     ButtonConfig(
//       text: 'Assign Parking',
//       onPressed: () {
//         // Your logic when Assign Parking button is pressed
//       },
//     ),
//   ],
// ).show(context);
