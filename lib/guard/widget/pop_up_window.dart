import 'package:flutter/material.dart';
import '../../common/buttons.dart';
import '../../constants/global_variables.dart';

class Popup {
  final String title;
  final Widget content;
  final List<ButtonConfig> buttons;

  Popup({
    required this.title,
    required this.content,
    required this.buttons,
  });

  Future<void> show(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          title,
          style: const TextStyle(
            color: GlobalVariables.primaryColor,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
          textAlign: TextAlign.center,
        ),
        content: content,
        actions: [
          for (var i = 0; i < buttons.length; i++)
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                MyButton(
                  onTap: () {
                    buttons[i].onPressed?.call();
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
