import 'package:flutter/material.dart';
import '../constants/global_variables.dart';

class MyTabBar extends StatelessWidget {
  const MyTabBar({
    super.key,
    required TabController tabController,
    required this.firstTabText,
    required this.secondTabText,
  }) : _tabController = tabController;

  final TabController _tabController;
  final String firstTabText;
  final String secondTabText;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45,
      decoration: BoxDecoration(
        color: GlobalVariables.primaryColor,
        borderRadius: BorderRadius.circular(50),
      ),
      child: TabBar(
        indicatorSize: TabBarIndicatorSize.tab,
        controller: _tabController,
        indicatorColor: GlobalVariables.primaryColor,
        indicator: BoxDecoration(
          color: GlobalVariables.secondaryColor,
          borderRadius: BorderRadius.circular(50),
        ),
        tabs: [
          Tab(
            child: Text(
              firstTabText,
              style: TextStyle(
                  color: GlobalVariables.backgroundColor,
                  fontWeight: _tabController.index == 0
                      ? FontWeight.bold
                      : FontWeight.normal),
            ),
          ),
          Tab(
            child: Text(
              secondTabText,
              style: TextStyle(
                  color: GlobalVariables.backgroundColor,
                  fontWeight: _tabController.index == 1
                      ? FontWeight.bold
                      : FontWeight.normal),
            ),
          ),
        ],
      ),
    );
  }
}
