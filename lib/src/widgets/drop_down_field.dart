import 'package:flutter/material.dart';
import '../constants/global_variables.dart';

class MyDropdownField extends StatefulWidget {
  final String? label;
  final String? hint;
  final String? helper;
  final List<String> items;
  final String? value;
  final void Function(String?)? onChanged;

  const MyDropdownField({
    super.key,
    this.label,
    this.hint,
    this.helper,
    required this.items,
    this.value,
    this.onChanged,
  });

  @override
  State<MyDropdownField> createState() => _MyDropdownFieldState();
}

class _MyDropdownFieldState extends State<MyDropdownField> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: widget.label,
          labelStyle: GlobalVariables.labelStyle(context),
          hintText: widget.hint,
          helperText: widget.helper,
          helperStyle: GlobalVariables.helperStyle(context),
          floatingLabelStyle: GlobalVariables.floatingLabelStyle(context),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 15.0,
            vertical: 15.0,
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.transparent),
            borderRadius: BorderRadius.circular(25),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide:
                const BorderSide(color: GlobalVariables.primaryColor, width: 3),
            borderRadius: BorderRadius.circular(25),
          ),
          fillColor: Colors.white,
          filled: true,
        ),
        value: widget.value,
        items: widget.items.map((String item) {
          return DropdownMenuItem(
            value: item,
            child: Text(item),
          );
        }).toList(),
        onChanged: widget.onChanged,
      ),
    );
  }
}
