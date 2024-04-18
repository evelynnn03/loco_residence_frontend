
import 'package:flutter/material.dart';
import '../../src/utils/read data/visitor_details.dart';
import '../../src/widgets/my_tab_bar.dart';
import '../../src/constants/global_variables.dart';

class VisitorTimestamp extends StatefulWidget {
  static const String routeName = '/visitor-timestamp';
  const VisitorTimestamp({super.key});

  @override
  State<VisitorTimestamp> createState() => _VisitorTimestampState();
}

class _VisitorTimestampState extends State<VisitorTimestamp>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_handleTabSelection);
  }

  void _handleTabSelection() {
    setState(() {
      // Update the selected index when a tab is selected
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: GlobalVariables.backgroundColor,
        appBar: AppBar(
          foregroundColor: GlobalVariables.backgroundColor,
          backgroundColor: GlobalVariables.backgroundColor,
          shadowColor: Colors.transparent,
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: const Icon(
                  Icons.close,
                  color: GlobalVariables.primaryColor,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              );
            },
          ),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              child: MyTabBar(
                  firstTabText: 'Visitors',
                  secondTabText: 'Timestamp',
                  tabController: _tabController),
            ),
            Expanded(
                child: TabBarView(
              controller: _tabController,
              children: const [
                //1st tab
                VisitorDetails(tab: 1),

                //2nd tab
                VisitorDetails(tab: 2)
              ],
            )),
          ],
        ),
      ),
    );
  }
}
