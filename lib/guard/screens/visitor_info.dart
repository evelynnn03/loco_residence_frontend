import 'package:flutter/material.dart';
import 'package:loco_frontend/src/widgets/my_tab_bar.dart';
import 'package:loco_frontend/src/widgets/visitor_history_tab.dart';
import 'package:loco_frontend/src/widgets/visitor_timestamps.dart';

class VisitorInfo extends StatelessWidget {
  const VisitorInfo({super.key});
  static const String routeName = '/visitor-timestamp';

  @override
  Widget build(BuildContext context) {
    return const MyTabBar(tabLabels: [
      'Visitor Details',
      'Visitor Timestamp'
    ], tabContents: [
      VisitorHistoryTab(
        userType: 'guard',
      ),
      VisitorTimestamp()
    ]);
  }
}
