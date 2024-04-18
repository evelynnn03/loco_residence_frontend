import 'package:flutter/material.dart';

class FeedBackButton extends StatefulWidget {
  final String text;
  final Color color;
  final bool isChosen;
  final Function(bool) onSelected;
  const FeedBackButton({
    super.key,
    required this.text,
    required this.color,
    required this.isChosen,
    required this.onSelected,
  });

  @override
  State<FeedBackButton> createState() => _FeedBackButtonState();
}

class _FeedBackButtonState extends State<FeedBackButton> {

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(15),
      onTap: (){
        //The onSelected callback is responsible for updating the selection state
        widget.onSelected(!widget.isChosen);
      },
      splashColor: Colors.white.withOpacity(0.2),
      child: Ink(
        child: Center(
          child: Text(
            widget.text,
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        height: 70,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: widget.color,
        ),
      ),
    );
  }
}
