import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loco_frontend/src/constants/global_variables.dart';

class MyTextField extends StatefulWidget {
  final TextEditingController controller;
  final String? labelText;
  final String? hintText;
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
  final List<TextInputFormatter>? inputFormatters;
  final void Function(String)? onChanged;
  final bool validate;

  const MyTextField({
    super.key,
    this.isDescriptionBox,
    this.maxLines,
    required this.controller,
    this.labelText,
    this.hintText,
    this.obscureText,
    required this.keyboardType,
    this.onTap,
    this.validator,
    this.prefixIcon,
    this.suffixIcon,
    this.maxLength,
    this.enabled = true,
    this.inputFormatters,
    this.onChanged,
    this.validate = true,
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
        validator: widget.validate
            ? (value) {
                if (widget.validator != null) {
                  return widget.validator!(value);
                }
                if (value!.isEmpty) {
                  return 'Please enter ${widget.labelText}';
                }
                return null;
              }
            : null,
        decoration: InputDecoration(
          prefix: widget.isDescriptionBox == true
              ? const Padding(
                  padding: EdgeInsets.only(top: 35, left: 15),
                )
              : null,
          labelText: widget.labelText,
          hintText: widget.hintText,
          hintStyle: GlobalVariables.labelStyle(context),
          labelStyle: GlobalVariables.labelStyle(context),
          floatingLabelStyle: GlobalVariables.floatingLabelStyle(context),
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
                    size: GlobalVariables.responsiveIconSize(context, 23),
                  ),
                )
              : null,

          contentPadding: const EdgeInsets.symmetric(
            horizontal: 15.0,
            vertical: 15.0,
          ),

          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.transparent),
            borderRadius: widget.isDescriptionBox == true
                ? const BorderRadius.all(
                    Radius.circular(15),
                  ) // Add closing parenthesis here
                : const BorderRadius.all(
                    Radius.circular(25),
                  ),
          ),

          focusedBorder: OutlineInputBorder(
            borderSide:
                const BorderSide(color: GlobalVariables.primaryColor, width: 3),
            borderRadius: widget.isDescriptionBox == true
                ? const BorderRadius.all(
                    Radius.circular(15),
                  )
                : const BorderRadius.all(
                    Radius.circular(25),
                  ),
          ),

          fillColor: Colors.white,
          filled: true,

          // Customize the appearance during error state
          errorBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.red),
            borderRadius: widget.isDescriptionBox == true
                ? const BorderRadius.all(
                    Radius.circular(20),
                  ) // Add closing parenthesis here
                : const BorderRadius.all(
                    Radius.circular(25),
                  ),
          ),

          focusedErrorBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.red, width: 3),
            borderRadius: widget.isDescriptionBox == true
                ? const BorderRadius.all(
                    Radius.circular(20),
                  )
                : const BorderRadius.all(
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
        inputFormatters: widget.inputFormatters,
        onChanged: (text) {
          if (widget.onChanged != null) {
            widget.onChanged!(text.toUpperCase());
          }
        },
      ),
    );
  }
}
