import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:loco_frontend/src/constants/global_variables.dart';
import 'package:loco_frontend/src/widgets/calendar.dart';
import 'package:loco_frontend/src/widgets/text_field.dart';
import 'pop_up_window.dart';

class VisitorHistoryTab extends StatefulWidget {
  const VisitorHistoryTab({super.key});

  @override
  State<VisitorHistoryTab> createState() => _VisitorHistoryTabState();
}

class _VisitorHistoryTabState extends State<VisitorHistoryTab> {
  final TextEditingController _searchTextController = TextEditingController();
  // list of static visitors, will access the resident's name through the registration of visitor
  final List<Map<String, dynamic>> visitorData = [
    {
      'name': 'Visitor 1',
      'phone': '+6011-2334567',
      'checkin': DateTime(2024, 8, 8, 12, 30),
      'checkout': DateTime(2024, 8, 8, 14, 30),
      'purpose': 'Visitor',
      'carplate': 'ABC1234',
      'residentName': 'John Doe'
    },
    {
      'name': 'Visitor 2',
      'phone': '+6012-3456789',
      'checkin': DateTime(2024, 8, 7, 14, 30),
      'purpose': 'Delivery',
      'residentName': 'Jane Smith'
    },
    {
      'name': 'Visitor 3',
      'phone': '+6013-4567890',
      'checkin': DateTime(2024, 8, 6, 20, 13),
      'purpose': 'Constructor',
      'carplate': 'XYZ9876',
      'residentName': 'Robert Johnson'
    },
    {
      'name': 'Visitor 4',
      'phone': '+6014-5678901',
      'checkin': DateTime(2024, 7, 1, 23, 20),
      'checkout': DateTime(2024, 8, 2, 00, 15),
      'purpose': 'Visitor',
      'residentName': 'Emily Davis'
    },
    {
      'name': 'Visitor 5',
      'phone': '+6015-6789012',
      'checkin': DateTime(2024, 7, 31, 8, 15),
      'purpose': 'Visitor',
      'carplate': 'LMN4567',
      'residentName': 'Michael Brown'
    },
    // Add more data entries as needed...
  ];

  List<Map<String, dynamic>> filteredVisitorData = [];
  String _searchQuery = '';
  DateTime? _selectedDate;

  // by default, all data will be displayed
  @override
  void initState() {
    super.initState();
    filteredVisitorData = visitorData;
  }

  // show the calendar (showDatePicker)
  // Future<void> _selectDate(BuildContext context) async {
  //   final calendarWidth = MediaQuery.of(context).size.width;
  //   final calendarHeight = MediaQuery.of(context).size.height * 0.5;
  //   // stores the date selected
  //   // final DateTime? pickedDate = await showDatePicker(
  //   //   context: context,
  //   //   initialDate: DateTime.now(),
  //   //   firstDate: DateTime(2022), // starts from year 2022
  //   //   lastDate: DateTime(2101), // ends year 2101
  //   // );

  //   final DateTime? pickedDate = await showDialog<DateTime>(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return Dialog(
  //         child: SingleChildScrollView(
  //           child: ConstrainedBox(
  //             constraints: BoxConstraints(
  //               maxWidth: calendarWidth,
  //               maxHeight: calendarHeight,
  //             ),
  //             child: CalendarDatePicker(
  //               initialDate: null,
  //               firstDate: DateTime(2022),
  //               lastDate: DateTime(2101),
  //               onDateChanged: (DateTime selectedDates) {
  //                 Navigator.of(context).pop(selectedDates);
  //               },
  //             ),
  //           ),
  //         ),
  //       );

  //     },
  //   );

  //   if (pickedDate != null && pickedDate != _selectedDate) {
  //     setState(() {
  //       // Strip the time component from pickedDate
  //       _selectedDate =
  //           DateTime(pickedDate.year, pickedDate.month, pickedDate.day);

  //       // Format the selected date to 'dd/MM/yyyy' and assigns it to the _searchTextController.text
  //       _searchTextController.text =
  //           DateFormat('dd/MM/yyyy').format(_selectedDate!);

  //       // Filter the visitors based on the selected date
  //       _filterVisitors(_searchTextController.text);
  //     });
  //   }
  // }

  void _onDateSelected(DateTime date) {
    setState(() {
      // Strip the time component from pickedDate
      _selectedDate = DateTime(date.year, date.month, date.day);

      // Format the selected date to 'dd/MM/yyyy' and assigns it to the _searchTextController.text
      _searchTextController.text =
          DateFormat('dd/MM/yyyy').format(_selectedDate!);

      // Filter the visitors based on the selected date
      _filterVisitors(_searchTextController.text);
    });
  }

  // filter the visitor data list for searching
  void _filterVisitors(String query) {
    final searchQuery = query.toLowerCase();
    final selectedDate = _selectedDate;

    // function to strip time from a DateTime object
    DateTime _stripTime(DateTime dateTime) {
      return DateTime(dateTime.year, dateTime.month, dateTime.day);
    }

    // check if the search query is a date
    bool _isDateQuery = false;
    DateTime? _dateQuery;
    try {
      // if it is a date, then set _isDateQuery to true
      _dateQuery = DateFormat('dd/MM/yyyy').parseStrict(query);
      _isDateQuery = true;
    } catch (e) {
      _isDateQuery = false;
    }

    if (searchQuery.isEmpty) {
      // If search query is empty, show all data
      setState(() {
        filteredVisitorData = visitorData;
      });
    } else {
      final results = visitorData.where((visitor) {
        final name = visitor['name'].toLowerCase();
        final carplate = visitor['carplate']?.toLowerCase() ?? '';
        final residentName = visitor['residentName']?.toLowerCase() ?? '';
        final checkinDate = _stripTime(visitor['checkin'] as DateTime);
        final checkoutDate = visitor['checkout'] != null
            ? _stripTime(visitor['checkout'] as DateTime)
            : null;

        // If the query is a date, match it against the check-in and check-out dates
        if (_isDateQuery) {
          return (checkinDate == _stripTime(_dateQuery!)) ||
              (checkoutDate != null && checkoutDate == _stripTime(_dateQuery!));
        }

        // Otherwise, match against name, carplate, and residentName
        final matchesQuery = name.contains(searchQuery) ||
            carplate.contains(searchQuery) ||
            residentName.contains(searchQuery);

        // Check if the selected date matches the checkin or checkout date
        final dateMatches = selectedDate == null ||
            checkinDate == _stripTime(selectedDate) ||
            (checkoutDate != null && checkoutDate == _stripTime(selectedDate));

        return matchesQuery && dateMatches;
      }).toList();

      // The filtered results are stored in filteredVisitorData, and the search query is stored in _searchQuery.
      setState(() {
        filteredVisitorData = results;
        _searchQuery = query;
      });
    }
  }

  // function for the header text
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
    // Sort the visitorData list by date in descending order (newest first)
    filteredVisitorData.sort((a, b) {
      DateTime aDate = a['checkout'] ?? a['checkin'];
      DateTime bDate = b['checkout'] ?? b['checkin'];
      return bDate.compareTo(aDate);
    });

    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    double containerHeight = screenHeight * 0.18;
    double boxHeight = screenHeight * 0.03;
    double boxWidth = screenWidth * 0.25;
    double sizedBoxHeight(double height) {
      if (height < 600)
        return 10;
      else
        return 12;
    }

    return Scaffold(
      backgroundColor: GlobalVariables.secondaryColor,
      body: Column(
        children: [
          // search bar (can search by name, carplate, resident name)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 15),
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
                    DateTime? pickedDate =
                        await showCalendar(context, minDate: DateTime(2022), maxDate: DateTime.now());

                    // When a date is selected, apply it
                    if (pickedDate != null) {
                      _onDateSelected(pickedDate);
                    }
                  },
                ),
              ],
            ),
          ),
          Expanded(
            // for the fading effect
            child: ShaderMask(
              shaderCallback: (Rect bounds) {
                return LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent, // No effect at the top
                    Colors.white.withOpacity(0.3), // Fades to white
                  ],
                  stops: [0.5, 1.0],
                ).createShader(bounds);
              },
              blendMode: BlendMode.dstOut,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: filteredVisitorData.isEmpty
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
                        itemCount: filteredVisitorData.length,
                        itemBuilder: (BuildContext context, int index) {
                          final visitor = filteredVisitorData[index];
                          final checkinDate = visitor['checkin'] as DateTime;
                          final checkoutDate = visitor['checkout'] as DateTime?;
                          final date = checkoutDate ?? checkinDate;
                          final headerText = _getHeaderText(date);
                          final carplate = visitor['carplate'];
                          final residentName = visitor['residentName'];
                          final phone = visitor['phone'];
                          final purpose = visitor['purpose'];

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: sizedBoxHeight(screenHeight)),

                              // the header text 'Today' / 'This Week', etc
                              if (index == 0 ||
                                  _getHeaderText(visitorData[index - 1]
                                              ['checkout'] ??
                                          visitorData[index - 1]['checkin']) !=
                                      headerText)
                                Padding(
                                  padding: const EdgeInsets.only(left: 20.0),
                                  child: Text(
                                    headerText,
                                    style: GlobalVariables
                                        .visitorHistoryTitleStyle(context),
                                  ),
                                ),
                              SizedBox(
                                height: sizedBoxHeight(screenHeight),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15.0),

                                // container for the visitor details
                                child: GestureDetector(
                                  onTap: () {
                                    Popup(
                                      title: visitor['name'],
                                      content: SizedBox(
                                        height: 80,
                                        child: Center(
                                          child: Text(
                                            'Car Plate : $carplate\n'
                                            'Phone       : $phone\n'
                                            'Purpose   : $purpose\n'
                                            'Added by : $residentName',
                                            textAlign: TextAlign.left,
                                          ),
                                        ),
                                      ),
                                      buttons: [
                                        ButtonConfig(
                                            text: 'Close', onPressed: () {})
                                      ],
                                    ).show(context);
                                  },
                                  child: Container(
                                    height: containerHeight,
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
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            visitor['name'],
                                            style: GlobalVariables.bold20(
                                                context, GlobalVariables.white),
                                          ),
                                          SizedBox(
                                              height:
                                                  sizedBoxHeight(screenHeight)),

                                          // checked-in date and time
                                          Row(
                                            children: [
                                              Container(
                                                height: boxHeight,
                                                width: boxWidth,
                                                decoration: BoxDecoration(
                                                    color: Colors.green,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            25.0)),
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
                                                DateFormat('dd/MM/yyyy hh:mm a')
                                                    .format(checkinDate),
                                                style: GlobalVariables
                                                    .visitorHistoryDetail(
                                                  context,
                                                  isBold: false,
                                                ),
                                              )
                                            ],
                                          ),
                                          const SizedBox(height: 10),

                                          // if the check-out date is available, then there will be the checked-out date and time
                                          if (checkoutDate != null)
                                            Row(
                                              children: [
                                                Container(
                                                  height: boxHeight,
                                                  width: boxWidth,
                                                  decoration: BoxDecoration(
                                                      color: Colors.red,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              25.0)),
                                                  child: Center(
                                                    child: Text('Checked-out',
                                                        style: GlobalVariables
                                                            .visitorHistoryDetail(
                                                                context)),
                                                  ),
                                                ),
                                                const SizedBox(width: 10),
                                                Text(
                                                    DateFormat(
                                                            'dd/MM/yyyy hh:mm a')
                                                        .format(checkoutDate),
                                                    style: GlobalVariables
                                                        .visitorHistoryDetail(
                                                      context,
                                                      isBold: false,
                                                    )),
                                              ],
                                            ),
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
      ),
    );
  }
}
