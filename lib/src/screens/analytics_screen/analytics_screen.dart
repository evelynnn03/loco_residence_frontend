import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../constants/global_variables.dart';
import 'widgets/segmented_button.dart';
import 'package:lottie/lottie.dart';
import '../../../config/themes/theme_provider.dart';
import 'widgets/week_chart.dart';

class AnalyticsScreen extends StatefulWidget {
  static const String routeName = '/analytics_screen';

  const AnalyticsScreen({super.key});
  @override
  _AnalyticsScreenState createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String selectedDay = '';
  DateTime currentDate = DateTime.now();
  bool peakHour = false;
  bool showBottomIndicator = false;

  Map<String, List<String>> animationLink = {
    'no packed': [
      'https://lottie.host/7a5fa5b3-db75-45ae-b3ad-28a253d24aa3/8Yu5rVrOje.json',
      'Good to Go :)'
    ],
    'packed': [
      'https://lottie.host/b4639572-042b-48a9-82a7-424c2f5b985f/q4y66yBCjt.json',
      'Peak Hour :('
    ]
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.index = 0; // This Week
    selectedDay = 'Monday';
  }

  bool isGymClosed() {
    DateTime fixedDateTime = DateTime(2024, 8, 2, 17, 5);
    // DateTime now = DateTime.now();
    int currentHour = fixedDateTime.hour;
    int currentMinute = fixedDateTime.minute;

    if (currentHour < 6 ||
        (currentHour == 22 && currentMinute > 0) ||
        currentHour > 22) {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    Color backgroundColor = Theme.of(context).primaryColor;
    final mode = Provider.of<ThemeProvider>(context);
    Color boxShadowColor = Color.fromRGBO(130, 101, 234, 0.769);

    //to show in the indicator at the bottom
    // DateTime now = DateTime.now();
    // DateTime todayWithCurrentTime =
    //     DateTime(now.year, now.month, now.day, now.hour, now.minute);

    DateTime fixedDateTime = DateTime(2024, 8, 2, 17, 5);
    int currentHour = fixedDateTime.hour;
    int currentMinutes = fixedDateTime.minute;
    String formattedHour;
    String formattedMinute;
    if (currentHour < 10) {
      formattedHour = currentHour.toString().padLeft(2, '0');
    } else {
      formattedHour = currentHour.toString();
    }
    if (currentMinutes < 10) {
      formattedMinute = currentMinutes.toString().padLeft(2, '0');
    } else {
      formattedMinute = currentMinutes.toString();
    }

    return Scaffold(
      backgroundColor: GlobalVariables.primaryColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          'Gym Visits',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: GlobalVariables.backgroundColor,
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: GlobalVariables.backgroundColor,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 35),
              child: MySegmentedButtonRow(
                selected:
                    _tabController.index == 0 ? {'This Week'} : {'Last Week'},
                onSelectionChanged: (newSelection) {
                  setState(() {
                    _tabController.index =
                        newSelection.first == 'This Week' ? 0 : 1;
                  });
                },
                segments: const [
                  ButtonSegment(
                    value: 'This Week',
                    label: Text('This Week'),
                  ),
                  ButtonSegment(
                    value: 'Last Week',
                    label: Text('Last Week'),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 35.0),
              child: MySegmentedButtonRow(
                selected: {selectedDay},
                onSelectionChanged: (newSelection) {
                  setState(() {
                    selectedDay = newSelection.first;
                  });
                },
                segments: const [
                  ButtonSegment(
                    value: 'Monday',
                    label: Text('M'),
                  ),
                  ButtonSegment(
                    value: 'Tuesday',
                    label: Text('T'),
                  ),
                  ButtonSegment(
                    value: 'Wednesday',
                    label: Text('W'),
                  ),
                  ButtonSegment(
                    value: 'Thursday',
                    label: Text('T'),
                  ),
                  ButtonSegment(
                    value: 'Friday',
                    label: Text('F'),
                  ),
                  ButtonSegment(
                    value: 'Saturday',
                    label: Text('S'),
                  ),
                  ButtonSegment(
                    value: 'Sunday',
                    label: Text('S'),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 70,
            ),
            _tabController.index == 0
                ? Expanded(
                    child: WeekChart(
                      week: 'this_week',
                      selectedDay: selectedDay,
                      onPeakHourDetected: (peakHourBool) {
                        if (peakHour != peakHourBool) {
                          setState(
                            () {
                              peakHour = peakHourBool;
                            },
                          );
                        }
                      },
                      showBottomIndicator: (bool) {
                        if (showBottomIndicator != bool) {
                          setState(
                            () {
                              showBottomIndicator = bool;
                            },
                          );
                        }
                      },
                    ),
                  )
                : Expanded(
                    child: WeekChart(
                      week: 'last_week',
                      selectedDay: selectedDay,
                      onPeakHourDetected: (peakHourBool) {
                        if (peakHour != peakHourBool) {
                          setState(() {
                            peakHour = peakHourBool;
                          });
                        }
                      },
                      showBottomIndicator: (bool) {
                        if (showBottomIndicator != bool) {
                          setState(() {
                            showBottomIndicator = bool;
                          });
                        }
                      },
                    ),
                  ),
            Container(
              height: 150,
              decoration: BoxDecoration(
                color: mode.isDark ? Theme.of(context).cardColor : Colors.white,
                boxShadow: mode.isDark
                    ? [
                        BoxShadow(
                          color: boxShadowColor,
                          offset: const Offset(
                            0.0,
                            0.0,
                          ),
                          blurRadius: 8.0,
                          spreadRadius: 0.0,
                        ), //BoxShadow
                        //BoxShadow
                      ]
                    : null,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: showBottomIndicator
                  ? Row(
                      children: [
                        isGymClosed()
                            ? Lottie.network(animationLink['packed']![0])
                            : peakHour
                                ? Lottie.network(animationLink['packed']![0])
                                : Lottie.network(
                                    animationLink['no packed']![0]),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Current Time: $formattedHour $formattedMinute',
                              style: TextStyle(
                                  color: GlobalVariables.secondaryGrey),
                            ),
                            Text(
                              isGymClosed()
                                  ? 'Gym is closed'
                                  : peakHour
                                      ? animationLink['packed']![1]
                                      : animationLink['no packed']![1],
                              style: TextStyle(
                                  color: GlobalVariables.primaryColor,
                                  fontSize: 28,
                                  fontWeight: FontWeight.w600),
                            ),
                          ],
                        )
                      ],
                    )
                  : Container(),
            ),
          ],
        ),
      ),
    );
  }
}
