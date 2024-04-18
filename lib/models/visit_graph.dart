// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:intl/intl.dart';
// import 'package:flutter/material.dart';
// import 'package:fl_chart/fl_chart.dart';
// import 'package:sef_ass/constants/global_variables.dart';
// import '../widgets/segmented_button.dart';

// class MyHomePage extends StatefulWidget {
//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage>
//     with SingleTickerProviderStateMixin {
//   late TabController _tabController;
//   String selectedDay = 'Monday';

//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 2, vsync: this);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: GlobalVariables.primaryColor,
//       appBar: AppBar(
//         title: Text('Visit Dates'),
//       ),
//       body: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 35),
//             child: MySegmentedButtonRow(
//               selected:
//                   _tabController.index == 0 ? {'This Week'} : {'Last Week'},
//               onSelectionChanged: (newSelection) {
//                 setState(() {
//                   _tabController.index =
//                       newSelection.first == 'This Week' ? 0 : 1;
//                 });
//               },
//               segments: const [
//                 ButtonSegment(
//                   value: 'This Week',
//                   label: Text('This Week'),
//                 ),
//                 ButtonSegment(
//                   value: 'Last Week',
//                   label: Text('Last Week'),
//                 ),
//               ],
//             ),
//           ),
//           SizedBox(height: 20),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 35.0),
//             child: MySegmentedButtonRow(
//               selected: {selectedDay},
//               onSelectionChanged: (newSelection) {
//                 setState(() {
//                   selectedDay = newSelection.first;
//                 });
//               },
//               segments: const [
//                 ButtonSegment(
//                   value: 'Monday',
//                   label: Text('M'),
//                 ),
//                 ButtonSegment(
//                   value: 'Tuesday',
//                   label: Text('T'),
//                 ),
//                 ButtonSegment(
//                   value: 'Wednesday',
//                   label: Text('W'),
//                 ),
//                 ButtonSegment(
//                   value: 'Thursday',
//                   label: Text('T'),
//                 ),
//                 ButtonSegment(
//                   value: 'Friday',
//                   label: Text('F'),
//                 ),
//                 ButtonSegment(
//                   value: 'Saturday',
//                   label: Text('S'),
//                 ),
//                 ButtonSegment(
//                   value: 'Sunday',
//                   label: Text('S'),
//                 ),
//               ],
//             ),
//           ),
//           Expanded(
//             child: TabBarView(
//               controller: _tabController,
//               children: [
//                 WeekChart(week: 'this_week'),
//                 WeekChart(week: 'last_week'),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class WeekChart extends StatelessWidget {
//   final String week;

//   const WeekChart({Key? key, required this.week}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final CollectionReference visitCollection =
//         FirebaseFirestore.instance.collection('Facility Visit');

//     DateTime currentDate = DateTime.now();
//     DateTime thisWeekStart =
//         currentDate.subtract(Duration(days: (currentDate.weekday) % 7));
//     DateTime lastWeekStart = thisWeekStart.subtract(Duration(days: 7));

//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: Column(
//         children: [
//           Expanded(
//             child: FutureBuilder<QuerySnapshot>(
//               future: visitCollection.get(),
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return Center(
//                     child: Text(
//                       "loading...",
//                       style: TextStyle(color: Colors.white, fontSize: 18),
//                     ),
//                   );
//                 } else if (snapshot.hasError) {
//                   print('Error fetching data: ${snapshot.error}');
//                   return Text('Error: ${snapshot.error}');
//                 } else {
//                   List<DocumentSnapshot> documents = snapshot.data!.docs;

//                   // Map to store the count for each visit date
//                   Map<String, int> visitDateCounts = {};

//                   for (int i = 0; i < documents.length; i++) {
//                     Map<String, dynamic> visit =
//                         documents[i].data() as Map<String, dynamic>;
//                     String visitDate = visit['visit_date'];
//                     DateTime visitDateTime =
//                         DateFormat('dd/MM/yyyy').parse(visitDate);

//                     if (week == 'this_week' &&
//                         visitDateTime.isAfter(thisWeekStart)) {
//                       visitDateCounts[visitDate] =
//                           (visitDateCounts[visitDate] ?? 0) + 1;
//                     } else if (week == 'last_week' &&
//                         visitDateTime.isAfter(lastWeekStart) &&
//                         visitDateTime.isBefore(thisWeekStart)) {
//                       visitDateCounts[visitDate] =
//                           (visitDateCounts[visitDate] ?? 0) + 1;
//                     }
//                   }

//                   List<String> sortedDates = visitDateCounts.keys.toList()
//                     ..sort(); // Sort the dates

//                   return LineChart(
//                     LineChartData(
//                       titlesData: FlTitlesData(
//                         leftTitles: AxisTitles(
//                             sideTitles: SideTitles(
//                           showTitles: true,
//                           reservedSize: 35,
//                           interval: 1,
//                         )),
//                         bottomTitles: AxisTitles(
//                           sideTitles: SideTitles(
//                             showTitles: true,
//                             interval: 1,
//                             getTitlesWidget: (value, meta) {
//                               int index = value.toInt();
//                               if (index >= 0 && index < sortedDates.length) {
//                                 return Text(
//                                   sortedDates[index],
//                                   style: TextStyle(fontSize: 10),
//                                 );
//                               }
//                               return Text('');
//                             },
//                           ),
//                         ),
//                         topTitles: AxisTitles(
//                           sideTitles: SideTitles(
//                             showTitles: false,
//                           ),
//                         ),
//                         rightTitles: AxisTitles(
//                           sideTitles: SideTitles(
//                             showTitles: false,
//                           ),
//                         ),
//                       ),
//                       minY: 0,
//                       lineBarsData: [
//                         LineChartBarData(
//                           spots: sortedDates.asMap().entries.map((entry) {
//                             return FlSpot(
//                               entry.key.toDouble(),
//                               visitDateCounts[entry.value]!.toDouble(),
//                             );
//                           }).toList(),
//                           isCurved: true,
//                           color: Colors.blue,
//                           barWidth: 4,
//                           isStrokeCapRound: true,
//                           belowBarData: BarAreaData(show: false),
//                         ),
//                       ],
//                       // ... (rest of your chart configuration)
//                     ),
//                   );
//                 }
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
