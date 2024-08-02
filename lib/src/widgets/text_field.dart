import 'package:flutter/material.dart';
import 'package:loco_frontend/src/constants/global_variables.dart';

class MyTextField extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  final bool?
      obscureText; // Only for password: to hide the text entered, eg:  abc -> ...
  final int? maxLines;
  final bool? isDescriptionBox;
  final TextInputType
      keyboardType; // Which type of keyboard to show user, eg: phone number, so just digits
  final VoidCallback?
      onTap; // Currently only for when register visitor date, pop up the calendar
  final String? Function(String?)? validator; // Added validator parameter
  final IconData? prefixIcon; // Added parameter for prefix icon
  final IconData? suffixIcon; // Added parameter for icon
  final int? maxLength;
  final bool enabled;

  const MyTextField({
    super.key,
    this.isDescriptionBox,
    this.maxLines,
    required this.controller,
    required this.labelText,
    this.obscureText,
    required this.keyboardType,
    this.onTap,
    this.validator,
    this.prefixIcon,
    this.suffixIcon,
    this.maxLength,
    this.enabled = true,
  });

  @override
  State<MyTextField> createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: TextFormField(
        maxLines: widget.maxLines ?? 1,
        maxLength: widget.maxLength,
        controller: widget.controller,
        obscureText: widget.obscureText ?? false,
        keyboardType: widget.keyboardType,
        onTap: widget.onTap,
        validator: (value) {
          // If a custom validator is provided, use it
          if (widget.validator != null) {
            return widget.validator!(value);
          }
          // Default behavior: if value is empty, show error
          else if (value!.isEmpty) {
            return 'Please enter ${widget.labelText}';
          }
          return null;
        },
        decoration: InputDecoration(
          prefix: widget.isDescriptionBox == true
              ? Padding(
                  padding: EdgeInsets.only(top: 35, left: 15),
                )
              : null,
          labelText: widget.labelText,
          labelStyle: TextStyle(
            color: GlobalVariables.textLabel,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
          floatingLabelStyle: TextStyle(
            color: GlobalVariables.textLabel,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
          prefixIcon: widget.prefixIcon != null
              ? Icon(widget.prefixIcon, color: GlobalVariables.tabNotSelected)
              : null,

          // Visibility of password field
          suffixIcon: widget.suffixIcon != null
              ? GestureDetector(
                  onTap: () {
                    if (widget.onTap != null) {
                      widget.onTap!();
                    }
                  },
                  child: Icon(
                    widget.obscureText ?? false
                        ? Icons.visibility_off
                        : Icons.visibility,
                    color: GlobalVariables.tabNotSelected,
                    size: 23,
                  ),
                )
              : null,

          contentPadding: EdgeInsets.symmetric(
            horizontal: 15.0,
            vertical: 15.0,
          ),

          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.transparent),
            borderRadius: widget.isDescriptionBox == true
                ? BorderRadius.all(
                    Radius.circular(15),
                  ) // Add closing parenthesis here
                : BorderRadius.all(
                    Radius.circular(25),
                  ),
          ),

          focusedBorder: OutlineInputBorder(
            borderSide:
                BorderSide(color: GlobalVariables.primaryColor, width: 3),
            borderRadius: widget.isDescriptionBox == true
                ? BorderRadius.all(
                    Radius.circular(15),
                  )
                : BorderRadius.all(
                    Radius.circular(25),
                  ),
          ),

          fillColor: Colors.white,
          filled: true,

          // Customize the appearance during error state
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red),
            borderRadius: widget.isDescriptionBox == true
                ? BorderRadius.all(
                    Radius.circular(20),
                  ) // Add closing parenthesis here
                : BorderRadius.all(
                    Radius.circular(25),
                  ),
          ),

          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red, width: 3),
            borderRadius: widget.isDescriptionBox == true
                ? BorderRadius.all(
                    Radius.circular(20),
                  )
                : BorderRadius.all(
                    Radius.circular(25),
                  ),
          ),

          enabled: widget.enabled,

          // disabledBorder: OutlineInputBorder(
          //   borderSide: BorderSide(color: Colors.transparent),
          //   borderRadius: widget.isDescriptionBox == true
          //       ? BorderRadius.all(
          //           Radius.circular(15),
          //         ) // Add closing parenthesis here
          //       : BorderRadius.all(
          //           Radius.circular(25),
          //         ),
          // ),
        ),
      ),
    );
  }
}
