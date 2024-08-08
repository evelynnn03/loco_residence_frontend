import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:loco_frontend/src/constants/global_variables.dart';

class VisitorHistoryTab extends StatefulWidget {
  const VisitorHistoryTab({super.key});

  @override
  State<VisitorHistoryTab> createState() => _VisitorHistoryTabState();
}

class _VisitorHistoryTabState extends State<VisitorHistoryTab> {
  final List<Map<String, dynamic>> visitorData = [
    {
      'name': 'Visitor 1',
      'phone': '+6011-2334567',
      'date': DateTime(2024, 8, 8, 12, 30),
      'status': 'Checked-out'
    },
    {
      'name': 'Visitor 1',
      'phone': '+6012-3456789',
      'date': DateTime(2024, 8, 7, 14, 30),
      'status': 'Checked-in'
    },
    {
      'name': 'Visitor 2',
      'phone': '+6013-4567890',
      'date': DateTime(2024, 8, 6, 20, 13),
      'status': 'Checked-in'
    },
    {
      'name': 'Visitor 3',
      'phone': '+6014-5678901',
      'date': DateTime(2024, 8, 1, 23, 20),
      'status': 'Checked-out'
    },
    {
      'name': 'Visitor 3',
      'phone': '+6015-6789012',
      'date': DateTime(2024, 7, 31, 8, 15),
      'status': 'Checked-in'
    },
    {
      'name': 'Visitor 4',
      'phone': '+6016-7890123',
      'date': DateTime(2024, 6, 2, 16, 23),
      'status': 'Checked-out'
    },
    {
      'name': 'Visitor 4',
      'phone': '+6017-8901234',
      'date': DateTime(2024, 5, 28, 17, 25),
      'status': 'Checked-in'
    },
    {
      'name': 'Visitor 5',
      'phone': '+6018-9012345',
      'date': DateTime(2024, 4, 8, 13, 35),
      'status': 'Checked-out'
    },
    {
      'name': 'Visitor 5',
      'phone': '+6019-0123456',
      'date': DateTime(2024, 2, 8, 00, 50),
      'status': 'Checked-in'
    },
    {
      'name': 'Visitor 6',
      'phone': '+6020-1234567',
      'date': DateTime(2023, 8, 8, 9, 15),
      'status': 'Checked-in'
    },
    {
      'name': 'Visitor 7',
      'phone': '+6021-2345678',
      'date': DateTime(2022, 8, 8, 10, 47),
      'status': 'Checked-in'
    },
    {
      'name': 'Visitor 8',
      'phone': '+6022-3456789',
      'date': DateTime(2022, 12, 12, 19, 30),
      'status': 'Checked-in'
    },
  ];

  String _getHeaderText(DateTime date) {
    final today = DateTime.now();
    final thisWeekStart = today.subtract(Duration(days: today.weekday - 1));

    if (date.isAtSameMomentAs(today) ||
        date.isAfter(today.subtract(Duration(days: 1)))) {
      return 'Today';
    } else if (date.isAfter(thisWeekStart)) {
      return 'This Week';
    } else if (date.year == today.year && date.month == today.month) {
      return 'This Month';
    } else if (date.year == today.year) {
      return DateFormat.MMMM().format(date); // Display the month name
    } else {
      return date.year
          .toString(); // Display the year if it's from last year or older
    }
  }

  @override
  Widget build(BuildContext context) {
    // Sort the visitorData list by date in descending order (newest first)
    visitorData.sort((a, b) => b['date'].compareTo(a['date']));
    return Scaffold(
      backgroundColor: GlobalVariables.secondaryColor,
      body: Expanded(
        // for the fading effect
        child: ShaderMask(
          shaderCallback: (Rect bounds) {
            return LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent, // No effect at the top
                Colors.white.withOpacity(0.2), // Fades to white
              ],
              stops: [0.5, 1.0],
            ).createShader(bounds);
          },
          blendMode: BlendMode.dstOut,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 10.0),
            child: ListView.builder(
              itemCount: visitorData.length,
              itemBuilder: (BuildContext context, int index) {
                final visitor = visitorData[index];
                final date = visitor['date'] as DateTime;
                final status = visitor['status'] as String;
                final headerText = _getHeaderText(date);

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 15.0),
                    if (index == 0 ||
                        _getHeaderText(visitorData[index - 1]['date']) !=
                            headerText)
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: Text(
                          headerText,
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.black54,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    const SizedBox(height: 15.0),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: Container(
                        height: 120,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: GlobalVariables.primaryColor,
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 25.0,
                            vertical: 15.0,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    visitor['name'],
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    visitor['phone'],
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    height: 25,
                                    width: 100,
                                    decoration: BoxDecoration(
                                        color: status == 'Checked-in'
                                            ? Colors.green
                                            : Colors.red,
                                        borderRadius:
                                            BorderRadius.circular(25.0)),
                                    child: Center(
                                      child: Text(
                                        visitor['status'],
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    DateFormat('dd/MM/yyyy hh:mm a')
                                        .format(date),
                                    style: const TextStyle(color: Colors.white),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
