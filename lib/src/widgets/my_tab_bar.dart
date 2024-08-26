import 'package:flutter/material.dart';
import '../constants/global_variables.dart';

class MyTabBar extends StatelessWidget {
  final List<String> tabLabels;
  final List<Widget> tabContents;

  const MyTabBar({
    super.key,
    required this.tabLabels,
    required this.tabContents,
  });

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabLabels.length,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: GlobalVariables.secondaryColor,
          bottom: TabBar(
            indicatorColor: GlobalVariables.primaryColor,
            tabAlignment: TabAlignment.fill,
            labelStyle: GlobalVariables.bold16(context),
            labelColor: GlobalVariables.primaryColor,
            unselectedLabelColor: GlobalVariables.tabNotSelected,
            tabs: tabLabels.map((label) => Tab(text: label)).toList(),
          ),
        ),
        body: TabBarView(
          children: tabContents,
        ),
      ),
    );
  }
}
