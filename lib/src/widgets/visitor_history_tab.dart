import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:loco_frontend/src/constants/global_variables.dart';
import 'package:loco_frontend/src/provider/visitor_provider.dart';
import 'package:loco_frontend/src/widgets/calendar.dart';
import 'package:loco_frontend/src/widgets/text_field.dart';
import 'package:provider/provider.dart';
import 'pop_up_window.dart';
import '../models/visitor.dart';

class VisitorHistoryTab extends StatefulWidget {
  const VisitorHistoryTab({super.key});

  @override
  State<VisitorHistoryTab> createState() => _VisitorHistoryTabState();
}

class _VisitorHistoryTabState extends State<VisitorHistoryTab> {
  final TextEditingController _searchTextController = TextEditingController();
  List<Visitor> filteredVisitors = [];
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<VisitorProvider>(context, listen: false).fetchAllVisitors();
    });
  }

  void _onDateSelected(DateTime date) {
    setState(() {
      _selectedDate = DateTime(date.year, date.month, date.day);
      _searchTextController.text =
          DateFormat('dd/MM/yyyy').format(_selectedDate!);
      _filterVisitors(_searchTextController.text);
    });
  }

  // filter according to user's search text
  void _filterVisitors(String query) {
    final visitorProvider =
        Provider.of<VisitorProvider>(context, listen: false);
    final allVisitors = visitorProvider.visitors;
    final searchQuery = query.toLowerCase();

    DateTime? stripTime(DateTime? dateTime) {
      return dateTime != null
          ? DateTime(dateTime.year, dateTime.month, dateTime.day)
          : null;
    }

    bool isDateQuery = false;
    DateTime? dateQuery;
    try {
      dateQuery = DateFormat('dd/MM/yyyy').parseStrict(query);
      isDateQuery = true;
    } catch (e) {
      isDateQuery = false;
    }

    setState(() {
      if (searchQuery.isEmpty) {
        filteredVisitors = allVisitors;
      } else {
        filteredVisitors = allVisitors.where((visitor) {
          final name = visitor.fullName.toLowerCase();
          final phone = visitor.hpNumber.toLowerCase();
          final carplate = visitor.carPlateNo.toLowerCase();
          final checkInDate = (visitor.checkInDate);
          final checkOutDate = (visitor.checkOutDate) ?? '';

          if (isDateQuery) {
            final queryDate = stripTime(dateQuery!);
            return (checkInDate == queryDate) || (checkOutDate == queryDate);
          }

          final matchesQuery = name.contains(searchQuery) ||
              phone.contains(searchQuery) ||
              carplate.contains(searchQuery);

          final dateMatches = _selectedDate == null ||
              checkInDate == stripTime(_selectedDate) ||
              (checkOutDate == stripTime(_selectedDate));

          return matchesQuery && dateMatches;
        }).toList();
      }
    });
  }

  // method for the header text
  String _getHeaderText(DateTime date) {
    final today = DateTime.now();
    final thisWeekStart = today.subtract(Duration(days: today.weekday - 1));

    if (date.isAtSameMomentAs(today) ||
        date.isAfter(today.subtract(const Duration(days: 1)))) {
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
    return Scaffold(
      backgroundColor: GlobalVariables.secondaryColor,
      body: Consumer<VisitorProvider>(
        builder: (context, visitorProvider, child) {
          if (visitorProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          // Get the filtered visitor list or the full visitor list
          final visitors =
              filteredVisitors.isEmpty && _searchTextController.text.isEmpty
                  ? visitorProvider.visitors
                  : filteredVisitors;

          // Filter visitors to show only those whose check-in or check-out dates are before today
          final today = DateTime.now();
          final pastVisitors = visitors.where((visitor) {
            DateTime? checkInDate = visitor.checkInDate;
            DateTime? checkOutDate = visitor.checkOutDate;

            // If check-out exists, use that, otherwise use check-in
            final displayDate = checkOutDate ?? checkInDate;

            // Display only visitors whose check-in/check-out date is before today
            return displayDate
                .isBefore(DateTime(today.year, today.month, today.day));
          }).toList();

          // Sort the visitors by their check-in or check-out date in descending order
          pastVisitors.sort((a, b) {
            DateTime aDate = a.checkOutDate ?? a.checkInDate;
            DateTime bDate = b.checkOutDate ?? b.checkInDate;
            return bDate.compareTo(aDate);
          });

          final screenHeight = MediaQuery.of(context).size.height;
          final screenWidth = MediaQuery.of(context).size.width;
          double containerHeight = screenHeight * 0.18;
          double boxHeight = screenHeight * 0.03;
          double boxWidth = screenWidth * 0.25;

          return Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 15.0, horizontal: 15),
                child: Row(
                  children: [
                    Expanded(
                      child: MyTextField(
                        controller: _searchTextController,
                        keyboardType: TextInputType.text,
                        hintText: 'Search...',
                        prefixIcon: Icons.search,
                        onChanged: _filterVisitors,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.date_range,
                        color: GlobalVariables.primaryColor,
                      ),
                      onPressed: () async {
                        DateTime? pickedDate = await showCalendar(
                          context,
                          minDate: DateTime(2022),
                          maxDate: DateTime.now(),
                        );
                        if (pickedDate != null) {
                          _onDateSelected(pickedDate);
                        }
                      },
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ShaderMask(
                  shaderCallback: (Rect bounds) {
                    return LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.white.withOpacity(0.3),
                      ],
                      stops: [0.5, 1.0],
                    ).createShader(bounds);
                  },
                  blendMode: BlendMode.dstOut,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: pastVisitors.isEmpty
                        ? Column(
                            children: [
                              Center(
                                child: Text(
                                  'No Results',
                                  style: GlobalVariables.noResultStyle(context),
                                ),
                              ),
                            ],
                          )
                        : ListView.builder(
                            itemCount: pastVisitors.length,
                            itemBuilder: (BuildContext context, int index) {
                              final visitor = pastVisitors[index];
                              final checkinDate = visitor.checkInDate;
                              final checkoutDate = visitor.checkOutDate;
                              final date = checkoutDate ?? checkinDate;
                              final headerText = _getHeaderText(date);

                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (index == 0 ||
                                      _getHeaderText(pastVisitors[index - 1]
                                                  .checkOutDate ??
                                              pastVisitors[index - 1]
                                                  .checkInDate) !=
                                          headerText)
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(left: 20.0),
                                      child: Text(
                                        headerText,
                                        style: GlobalVariables
                                            .visitorHistoryTitleStyle(context),
                                      ),
                                    ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 15.0, vertical: 15.0),
                                    child: GestureDetector(
                                      onTap: () {
                                        Popup(
                                          title: visitor.fullName,
                                          content: SizedBox(
                                            height: 80,
                                            child: Center(
                                              child: Text(
                                                'Car Plate : ${visitor.carPlateNo}\n'
                                                'Phone       : ${visitor.hpNumber}\n'
                                                'Purpose   : ${visitor.purpose}\n',
                                                textAlign: TextAlign.left,
                                              ),
                                            ),
                                          ),
                                          buttons: [
                                            ButtonConfig(
                                                text: 'Close',
                                                onPressed: () {}),
                                          ],
                                        ).show(context);
                                      },
                                      child: Container(
                                        height: containerHeight,
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          color: GlobalVariables.primaryColor,
                                          borderRadius:
                                              BorderRadius.circular(25.0),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(20.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                visitor.fullName,
                                                style: GlobalVariables.bold20(
                                                    context,
                                                    GlobalVariables.white),
                                              ),
                                              const SizedBox(height: 10),
                                              Row(
                                                children: [
                                                  Container(
                                                    height: boxHeight,
                                                    width: boxWidth,
                                                    decoration: BoxDecoration(
                                                      color: Colors.green,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              25.0),
                                                    ),
                                                    child: Center(
                                                      child: Text(
                                                        'Checked-in',
                                                        style: GlobalVariables
                                                            .visitorHistoryDetail(
                                                                context),
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 10),
                                                  Text(
                                                    DateFormat(
                                                            'dd/MM/yyyy  hh:mm a')
                                                        .format(checkinDate),
                                                    style: GlobalVariables
                                                        .visitorHistoryDetail(
                                                      context,
                                                      isBold: false,
                                                    ),
                                                  )
                                                ],
                                              ),
                                              if (checkoutDate != null) ...[
                                                const SizedBox(height: 10),
                                                Row(
                                                  children: [
                                                    Container(
                                                      height: boxHeight,
                                                      width: boxWidth,
                                                      decoration: BoxDecoration(
                                                        color: Colors.red,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(25.0),
                                                      ),
                                                      child: Center(
                                                        child: Text(
                                                          'Checked-out  hh:mm a',
                                                          style: GlobalVariables
                                                              .visitorHistoryDetail(
                                                                  context),
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(width: 10),
                                                    Text(
                                                      DateFormat('dd/MM/yyyy')
                                                          .format(checkoutDate),
                                                      style: GlobalVariables
                                                          .visitorHistoryDetail(
                                                        context,
                                                        isBold: false,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ],
                                          ),
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
            ],
          );
        },
      ),
    );
  }
}
