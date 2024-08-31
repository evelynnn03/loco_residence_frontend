import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';

class WeekChart extends StatelessWidget {
  final String week;
  final String selectedDay;
  final Function(bool) onPeakHourDetected;
  final Function(bool) showBottomIndicator;

  final List<Color> gradientColors = [
    Color.fromARGB(77, 255, 255, 255),
    Color.fromARGB(73, 255, 255, 255),
    Color.fromARGB(32, 255, 255, 255),
  ];

  WeekChart(
      {Key? key,
      required this.week,
      required this.selectedDay,
      required this.onPeakHourDetected,
      required this.showBottomIndicator})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('WeekChart: week - $week, selectedDay - $selectedDay');

    final CollectionReference visitCollection =
        FirebaseFirestore.instance.collection('Facility Visit');

    // DateTime staticDate = DateTime(2024, 1, 8);
    // DateTime now = DateTime(2024, 1, 8, 6);

    DateTime currentDate = DateTime(2024, 2, 8, 17, 5);
    int currentHour = currentDate.hour;
    DateTime thisWeekStart =
        currentDate.subtract(Duration(days: currentDate.weekday - 1));
    DateTime lastWeekStart = thisWeekStart.subtract(const Duration(days: 7));

    return Padding(
      padding: const EdgeInsets.all(8.0),
      // change to futreBuilder if want static dates (1-7, 8-11), change snapshots() to get()
      child: FutureBuilder<QuerySnapshot>(
        future: visitCollection.orderBy('visit_date').get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            print('Error fetching data: ${snapshot.error}');
            return Text('Error: ${snapshot.error}');
          } else {
            print(currentDate);
            List<DocumentSnapshot> documents = snapshot.data!.docs;

            // Map to store the count for each visit time
            Map<int, int> visitTimeCounts = {};

            for (int i = 0; i < documents.length; i++) {
              Map<String, dynamic>? visit =
                  documents[i].data() as Map<String, dynamic>?;
              print('visit: $visit');

              if (visit != null) {
                String visitDate = visit['visit_date'];
                print('visitDateTime: $visitDate');
                DateTime visitDateTime =
                    DateFormat('dd/MM/yyyy').parse(visitDate);

                // Check if the visit is within the desired week range
                if ((week == 'this_week' &&
                        visitDateTime.isAfter(
                          thisWeekStart.subtract(
                            const Duration(days: 1),
                          ),
                        ) &&
                        visitDateTime.isBefore(
                          thisWeekStart.add(
                            const Duration(days: 7),
                          ),
                        )) ||
                    (week == 'last_week' &&
                        visitDateTime.isAfter(
                          lastWeekStart.subtract(
                            const Duration(days: 1),
                          ),
                        ) &&
                        visitDateTime.isBefore(
                          lastWeekStart.add(
                            const Duration(days: 7),
                          ),
                        ))) {
                  // Check if the visit is on the selected day
                  if (DateFormat('EEEE').format(visitDateTime).toLowerCase() ==
                      selectedDay.toLowerCase()) {
                    dynamic checkinTime = visit['check_in_time'];
                    dynamic checkoutTime = visit['check_out_time'];
                    print('visitDateTimeee: $visitDate');
                    print('selectedDay: $selectedDay');
                    print('checkoutTime: $checkoutTime');
                    print('checkinTime: $checkinTime');

                    if (checkinTime is String) {
                      int checkinHour =
                          int.tryParse(checkinTime.split(':')[0]) ?? 0;
                      visitTimeCounts[checkinHour] =
                          (visitTimeCounts[checkinHour] ?? 0) + 1;

                      // Check if there's a different check-out time
                      if (checkoutTime is String &&
                          checkoutTime != checkinTime) {
                        int checkoutHour =
                            int.tryParse(checkoutTime.split(':')[0]) ?? 0;

                        for (int hour = checkinHour + 1;
                            hour <= checkoutHour;
                            hour++) {
                          visitTimeCounts[hour] =
                              (visitTimeCounts[hour] ?? 0) + 1;
                        }
                      }
                    } else {
                      print('Invalid checkinTime format: $checkinTime');
                    }
                  }
                }
              }
            }
            print('sorted visit: $visitTimeCounts');
            List<MapEntry<int, int>> sortedVisitCounts = visitTimeCounts.entries
                .toList()
              ..sort((a, b) => a.key.compareTo(b.key));
            Future.delayed(const Duration(seconds: 0), () {
              showBottomIndicator(true); // Pass the boolean data
            });

            return Padding(
              padding: EdgeInsets.only(
                right: 30.0,
                bottom: MediaQuery.of(context).size.height * 0.03,
              ),
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(
                    show: true,
                    horizontalInterval: 1.0,
                    verticalInterval: 2.0,
                    getDrawingHorizontalLine: (value) {
                      if (value == 0) {
                        return const FlLine(
                            color: Color(0xff37434d), strokeWidth: 1);
                      }
                      return const FlLine(
                        color: Color(0xff37434d),
                        strokeWidth: 0.2,
                      );
                    },
                    getDrawingVerticalLine: (value) {
                      if (value == 0) {
                        return const FlLine(
                            color: Color(0xff37434d), strokeWidth: 1);
                      }
                      return const FlLine(
                        color: Color(0xff37434d),
                        strokeWidth: 0.2,
                      );
                    },
                  ),
                  titlesData: FlTitlesData(
                    leftTitles: const AxisTitles(
                      axisNameWidget: Text(
                        'No of visitors',
                        style: TextStyle(color: Colors.white60),
                      ),
                      sideTitles: SideTitles(
                        getTitlesWidget: leftTitleWidgets,
                        showTitles: true,
                        reservedSize: 22,
                        interval: 2,
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      axisNameWidget: const Text(
                        'Hours',
                        style: TextStyle(color: Colors.white60),
                      ),
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: 2,
                        getTitlesWidget: (value, meta) {
                          int hour = value.toInt();
                          if (hour >= 6 && hour <= 22 && hour % 2 == 0) {
                            return Text(
                              '$hour',
                              style: const TextStyle(
                                color: Colors.white60,
                              ),
                            );
                          }
                          return const Text('');
                        },
                      ),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: false,
                      ),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: false,
                      ),
                    ),
                  ),
                  borderData: FlBorderData(
                    show: true,
                    border: Border.all(color: Colors.white, width: 1),
                  ),
                  minY: 0,
                  lineBarsData: [
                    LineChartBarData(
                      spots: List.generate(
                        9,
                        (index) {
                          int hour = 6 + index * 2;
                          // Find the count for the current hour, use 0 if not found
                          double count = sortedVisitCounts
                              .firstWhere((entry) => entry.key == hour,
                                  orElse: () => MapEntry(hour, 0))
                              .value
                              .toDouble();

                          // Get the current hour

                          // Check the conditions and print the desired message
                          if (hour == currentHour && count < 5) {
                            Future.delayed(
                              const Duration(seconds: 0),
                              () {
                                onPeakHourDetected(
                                    false); // Pass the boolean data
                              },
                            );
                          } else if (hour == currentHour &&
                              count >= 5 &&
                              count <= 10) {
                            Future.delayed(
                              const Duration(seconds: 0),
                              () {
                                onPeakHourDetected(
                                    false); // Pass the boolean data
                              },
                            );
                          } else if (hour == currentHour && count > 10) {
                            Future.delayed(const Duration(seconds: 0), () {
                              onPeakHourDetected(true); // Pass the boolean data
                            });
                          }
                          return FlSpot(hour.toDouble(), count);
                        },
                      ),
                      isCurved: true,
                      color: Colors.white,
                      barWidth: 3,
                      isStrokeCapRound: true,
                      dotData: const FlDotData(show: false),
                      belowBarData: BarAreaData(
                        show: true,
                        gradient: LinearGradient(
                            colors: gradientColors,
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}

Widget leftTitleWidgets(double value, TitleMeta meta) {
  final style = TextStyle(color: Colors.white60);

  final intValue = value.toInt();

  return Text(
    intValue.toString(),
    style: style,
    textAlign: TextAlign.center,
  );
}
