import 'package:flutter/material.dart';
import 'package:loco_frontend/src/widgets/visitor_history_tab.dart';
import '../../src/constants/global_variables.dart';

class VisitorInfo extends StatelessWidget {
  const VisitorInfo({super.key});
  static const String routeName = '/visitor-timestamp';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GlobalVariables.secondaryColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Visitor History',
          style: GlobalVariables.appbarStyle(
            context,
          ),
        ),
        centerTitle: true,
      ),
      body: const VisitorHistoryTab(userType: 'guard'),
    );
  }
}
