import 'package:flutter/material.dart';

import 'visitor_map.dart';
import 'resident_map.dart';
import '../../src/widgets/my_tab_bar.dart';
import '../../src/constants/global_variables.dart';

class ParkingMapTab extends StatefulWidget {
  static const String routeName = '/parking-map-tab';
  final int? initialTabIndex;
  final String? visitorId;
  const ParkingMapTab({super.key, this.initialTabIndex, this.visitorId});

  @override
  State<ParkingMapTab> createState() => _ParkingMapTabState();
}

class _ParkingMapTabState extends State<ParkingMapTab>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  //In the initState method, _tabController.addListener(_handleTabSelection); sets up the listener. When a tab is selected, _handleTabSelection is executed automatically. Inside _handleTabSelection, you can add logic to update the state or perform any actions you need when a tab is selected.
  @override
  void initState() {
    super.initState();
    int initialIndex = widget.initialTabIndex ?? 0;

    _tabController =
        TabController(length: 2, vsync: this, initialIndex: initialIndex);
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
        backgroundColor: GlobalVariables.white,
        appBar: AppBar(
          foregroundColor: GlobalVariables.white,
          backgroundColor: GlobalVariables.white,
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
                tabLabels: ['Resident', 'Visitor'],
                tabContents: [
                  ResidentMap(),
                  VisitorMap(
                    vistorId: widget.visitorId,
                  )
                ],
              ),
            ),
            // Expanded(
            //   child: TabBarView(
            //     controller: _tabController,
            //     children: [
            //       //1st tab
            //       const ResidentMap(),

            //       //2nd tab
            //       VisitorMap(
            //         vistorId: widget.visitorId,
            //       )
            //     ],
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
