import 'package:flutter/material.dart';
import '../constants/global_variables.dart';

class MyDropdownField extends StatefulWidget {
  final String? label;
  final String? hint;
  final String? helper;
  final List<String> items;
  final String? value;
  final void Function(String?)? onChanged;
  final double? width;
  final bool isCompact; // Add flag for compact mode

  const MyDropdownField({
    super.key,
    this.label,
    this.hint,
    this.helper,
    required this.items,
    this.value,
    this.onChanged,
    this.width,
    this.isCompact = false, // Default to false for normal mode
  });

  @override
  State<MyDropdownField> createState() => _MyDropdownFieldState();
}

class _MyDropdownFieldState extends State<MyDropdownField> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5.0),
        child: DropdownButtonFormField<String>(
          decoration: InputDecoration(
            labelText: widget.label,
            labelStyle: GlobalVariables.labelStyle(context),
            hintText: widget.hint,
            helperText: widget.helper,
            helperStyle: GlobalVariables.helperStyle(context),
            floatingLabelStyle: GlobalVariables.floatingLabelStyle(context),
            contentPadding: widget.isCompact
                ? const EdgeInsets.all(12)
                : const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.transparent),
              borderRadius: BorderRadius.circular(25),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                  color: GlobalVariables.primaryColor, width: 3),
              borderRadius: BorderRadius.circular(25),
            ),
            fillColor: Colors.white,
            filled: true,
            isDense: widget.isCompact, // Makes the field more compact
          ),
          alignment: Alignment.center,
          dropdownColor: GlobalVariables.white,
          menuMaxHeight: 300, // Limit menu height
          isExpanded: false, // Prevent expansion to full width
          icon: Icon(Icons.arrow_drop_down,
              size: widget.isCompact
                  ? GlobalVariables.responsiveIconSize(context, 20)
                  : GlobalVariables.responsiveIconSize(context, 20)),
          style: TextStyle(
            fontSize: widget.isCompact
                ? GlobalVariables.responsiveFontSize(context, 13)
                : GlobalVariables.responsiveFontSize(context, 14),
            overflow: TextOverflow.ellipsis,
          ),
          value: widget.value,
          items: widget.items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(
                item,
                style: TextStyle(
                  color: GlobalVariables.primaryGrey,
                  fontSize: widget.isCompact
                      ? GlobalVariables.responsiveFontSize(context, 14)
                      : GlobalVariables.responsiveFontSize(context, 15),
                  fontWeight: FontWeight.bold,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            );
          }).toList(),
          onChanged: widget.onChanged,
        ),
      ),
    );
  }
}
