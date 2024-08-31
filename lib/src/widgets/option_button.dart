import 'package:flutter/material.dart';
import 'package:loco_frontend/src/constants/global_variables.dart';

class OptionButton extends StatefulWidget {
  final String text;
  final Color color;
  final bool isChosen;
  final Function(bool) onSelected;
  const OptionButton({
    super.key,
    required this.text,
    required this.color,
    required this.isChosen,
    required this.onSelected,
  });

  @override
  State<OptionButton> createState() => _OptionButtonState();
}

class _OptionButtonState extends State<OptionButton> {
  @override
  Widget build(BuildContext context) {
    double containerHeight = MediaQuery.of(context).size.height * 0.08;
    return InkWell(
      borderRadius: BorderRadius.circular(15),
      onTap: () {
        //The onSelected callback is responsible for updating the selection state
        widget.onSelected(!widget.isChosen);
      },
      splashColor: Colors.white.withOpacity(0.2),
      child: Ink(
        child: Center(
          child: Text(
            widget.text,
            style: GlobalVariables.bold16(context),
          ),
        ),
        height: containerHeight,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: widget.color,
        ),
      ),
    );
  }
}
