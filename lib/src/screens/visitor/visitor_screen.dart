import 'package:flutter/material.dart';
import 'package:loco_frontend/src/widgets/my_tab_bar.dart';

import '../../widgets/visitor_history_tab.dart';
import '../../widgets/visitor_reg_tab.dart';

class VisitorScreen extends StatelessWidget {
  const VisitorScreen({Key? key}) : super(key: key);

  static const String routeName = '/visitor_screen';

  @override
  Widget build(BuildContext context) {
    return MyTabBar(
        tabLabels: ['Visitor Registration', 'Visitor History'],
        tabContents: [VisitorRegTab(), VisitorHistoryTab()]);
  }
}
