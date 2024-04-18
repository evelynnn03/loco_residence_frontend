import 'package:flutter/material.dart';

import '../../constants/global_variables.dart';

class MyToggleSwitch extends StatefulWidget {
  MyToggleSwitch({
    Key? key,
    this.onToggle,
    required this.type,
  })  : assert(type == 'week' ||
            type == 'day'), //only type of week or day is accepted
        super(key: key);

  final Function(bool)? onToggle;
  final String type;

  @override
  _MyToggleSwitchState createState() => _MyToggleSwitchState();
}

class _MyToggleSwitchState extends State<MyToggleSwitch> {
  late List<bool> _isDaySelected;

  @override
  void initState() {
    // (index) => index == 0: This is a function that generates the value for each index. In this case, it returns true for the first element (index 0) and false for the rest. So, the resulting list will look like [true, false, false, false, false, false, false].
    super.initState();
    _isDaySelected = List.generate(
      7,
      (index) => index == 0,
    ); // Initialize with Monday selected
  }

  bool _isFirstTabSelected = true;

  @override
  Widget build(BuildContext context) {
    Widget _buildToggleTab(String text, int tabIndex, String type) {
      bool isSelected = type == 'week'
          ? _isFirstTabSelected == (tabIndex == 0)
          : _isDaySelected[tabIndex];

      return GestureDetector(
        onTap: () {
          setState(() {
            if (type == 'week') {
              _isFirstTabSelected = tabIndex == 0;
            } else if (type == 'day') {
              // Update the selected day
              for (int i = 0; i < _isDaySelected.length; i++) {
                //update the selected day to true, and the else will be false
                _isDaySelected[i] = i == tabIndex;
              }
            }
            widget.onToggle
                ?.call(isSelected); //update the _isDaySelected[tabIndex]
          });
        },
        child: Expanded(
          child: Container(
            // width: type == 'week'
            //     ? MediaQuery.of(context).size.width * 0.5
            //     : MediaQuery.of(context).size.width / 7,
            padding: EdgeInsets.symmetric(horizontal: 0),
            decoration: BoxDecoration(
              color: isSelected
                  ? GlobalVariables.secondaryColor
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(50),
            ),
            child: Center(
              child: Text(
                text,
                style: TextStyle(
                  color: isSelected
                      ? GlobalVariables.backgroundColor
                      : Colors.white,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: Container(
        height: 45,
        decoration: BoxDecoration(
          color: Color.fromARGB(40, 32, 32, 32),
          borderRadius: BorderRadius.circular(50),
        ),
        child: widget.type == 'week'
            ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildToggleTab('Last Week', 0, 'week'),
                  _buildToggleTab('This Week', 1, 'week'),
                ],
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildToggleTab('M', 0, 'day'),
                  _buildToggleTab('T', 1, 'day'),
                  _buildToggleTab('W', 2, 'day'),
                  _buildToggleTab('T', 3, 'day'),
                  _buildToggleTab('F', 4, 'day'),
                  _buildToggleTab('S', 5, 'day'),
                  _buildToggleTab('S', 6, 'day'),
                ],
              ),
      ),
    );
  }
}
