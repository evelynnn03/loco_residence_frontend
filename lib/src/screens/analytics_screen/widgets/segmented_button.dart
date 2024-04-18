import 'package:flutter/material.dart';

class MySegmentedButtonRow extends StatefulWidget {
  final Set<String> selected;
  final Function(Set<dynamic>)? onSelectionChanged;
  final List<ButtonSegment> segments;

  const MySegmentedButtonRow({
    super.key,
    required this.selected,
    required this.onSelectionChanged,
    required this.segments,
  });

  @override
  State<MySegmentedButtonRow> createState() => _MySegmentedButtonRowState();
}

class _MySegmentedButtonRowState extends State<MySegmentedButtonRow> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: SegmentedButton(
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all(Colors.white),
              backgroundColor: MaterialStateProperty.resolveWith(
                (states) {
                  if (states.contains(MaterialState.selected)) {
                    return Color.fromARGB(66, 255, 255, 255);
                  }
                  return Color.fromARGB(40, 32, 32, 32);
                },
              ),
            ),
            multiSelectionEnabled: false,
            emptySelectionAllowed: false,
            showSelectedIcon: false,
            selected: widget.selected,
            onSelectionChanged: widget.onSelectionChanged,
            segments: widget.segments,
          ),
        ),
      ],
    );
  }
}
