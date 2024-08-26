import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../config/themes/theme_provider.dart'; // Adjust the path
import '../constants/global_variables.dart'; // Adjust the path

typedef OnTap = void Function();

class HorizontalTiles extends StatefulWidget {
  const HorizontalTiles({
    super.key,
    required this.title,
    required this.icon,
    this.routeName,
    this.isDropdown = false,
    this.children = const [],
    this.tileColor = GlobalVariables.secondaryColor,
    this.textColor = GlobalVariables.primaryColor,
    this.iconSize = 40,
    this.dropdownHeight = 0,
  });

  final String title;
  final IconData icon;
  final String? routeName;
  final bool isDropdown;
  final List<Widget> children;
  final Color tileColor;
  final Color textColor;
  final double iconSize;
  final double dropdownHeight;

  @override
  State<HorizontalTiles> createState() => _HorizontalTilesState();
}

class _HorizontalTilesState extends State<HorizontalTiles> {
  bool _isExpanded = false;

  void _toggleDropdown() {
    if (widget.isDropdown) {
      setState(() {
        _isExpanded = !_isExpanded;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final mode = Provider.of<ThemeProvider>(context);
    Color boxShadowColor = Color.fromRGBO(30, 24, 49, 0.769);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () {
            _toggleDropdown();

            // Navigate only if routeName is provided and not a dropdown
            if (!widget.isDropdown &&
                widget.routeName != null &&
                widget.routeName!.isNotEmpty) {
              Navigator.pushNamed(context, widget.routeName!);
            }
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.1,
              decoration: BoxDecoration(
                color: widget.tileColor,
                borderRadius: BorderRadius.circular(25),
                boxShadow: mode.isDark
                    ? [
                        BoxShadow(
                          color: boxShadowColor,
                          offset: const Offset(0.0, 0.0),
                          blurRadius: 8.0,
                          spreadRadius: 0.0,
                        ),
                      ]
                    : null,
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.title,
                      style: GlobalVariables.bold20(context, widget.textColor),
                    ),
                    Icon(
                      widget.isDropdown
                          ? (_isExpanded
                              ? Icons.expand_less
                              : Icons.expand_more)
                          : widget.icon,
                      color: widget.textColor,
                      size: GlobalVariables.responsiveIconSize(
                          context, widget.iconSize),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        if (_isExpanded && widget.isDropdown)
          Container(
            height: widget.dropdownHeight,
            child: SingleChildScrollView(
              child: Column(
                children: widget.children,
              ),
            ),
          ),
      ],
    );
  }
}
