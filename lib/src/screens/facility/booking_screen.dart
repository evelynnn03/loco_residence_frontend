import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:loco_frontend/src/constants/global_variables.dart';
import 'package:loco_frontend/src/widgets/bottom_sheet.dart';
import 'package:loco_frontend/src/widgets/buttons.dart';
import 'package:loco_frontend/src/widgets/calendar.dart';
import 'package:loco_frontend/src/widgets/pop_up_window.dart';
// import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class BookingScreen extends StatefulWidget {
  const BookingScreen({super.key});
  static const String routeName = '/booking_screen';

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  DateTime? selectedDate;
  String? selectedSlot;
  int isSlotSelected = -1;
  bool isSelected = false;

  final List<List<String>> rooms = [
    ['A1', 'Conference Room'],
    ['B2', 'Meeting Room'],
    ['C3', 'Private Office'],
  ];

  final List<String> slots = [
    '8:00 AM',
    '8:30 AM',
    '9:00 AM',
    '9:30 AM',
    '10:00 AM',
    '10:30 AM',
    '11:00 AM',
    '11:30 AM',
    '12:00 PM',
    '12:30 PM',
    '1:00 PM',
    '1:30 PM',
    '2:00 PM',
    '2:30 PM',
    '3:00 PM',
    '3:30 PM',
    '4:00 PM',
    '4:30 PM',
    '5:00 PM',
    '5:30 PM',
    '6:00 PM',
    '6:30 PM',
    '7:00 PM',
    '7:30 PM',
    '8:00 PM',
    '8:30 PM',
    '9:00 PM',
    '9:30 PM',
  ];

  final List<int> durations = [
    30,
    60,
    90,
    120,
    150,
    180,
    210,
    240,
    270,
    300,
    330,
    360,
    390,
    420,
    450,
    480,
    510,
    540,
    570,
    600,
    630,
    660,
    690,
    720,
    750,
    780,
    810,
    840
  ];

  List<int> availableDurations = [];
  int selectedIndex = 0; // Index of the selected duration in the list

  String _formatDuration(int minutes) {
    final int hours = minutes ~/ 60;
    final int mins = minutes % 60;

    if (minutes == 30) {
      return '30 minutes';
    } else if (mins == 0) {
      // 1 hour, 2 hours etc
      return '$hours hour${hours > 1 ? 's' : ''}';
    } else {
      // 1.5 hours, 2.5 hours etc
      return '$hours.${(mins / 60 * 10).round()} hours';
    }
  }

  // Get the available hours
  List<int> _getAvailableDurations() {
    if (selectedSlot == null) return [];

    DateFormat format = DateFormat("h:mm a");
    DateTime startTime = format.parse(selectedSlot!);
    DateTime endTime = format.parse("10:00 PM");

    int remainingMinutes = endTime.difference(startTime).inMinutes;
    remainingMinutes = max(remainingMinutes, 30);

    List<int> newAvailableDurations = [];
    for (int duration in durations) {
      if (duration <= remainingMinutes) {
        newAvailableDurations.add(duration);
      } else {
        break;
      }
    }
    return newAvailableDurations;
  }

  void _updateAvailableDurations() {
    setState(() {
      availableDurations = _getAvailableDurations();
      if (selectedIndex >= availableDurations.length) {
        selectedIndex =
            availableDurations.isNotEmpty ? availableDurations.length - 1 : 0;
      }
    });
  }

  // List the available slots of the day
  List<String> _getAvailableSlots() {
    DateTime now = DateTime.now();
    DateTime selectedDateTime = selectedDate ?? DateTime.now();

    bool isToday = DateFormat('dd/MM/yyyy').format(selectedDateTime) ==
        DateFormat('dd/MM/yyyy').format(now);

    if (isToday) {
      // Show slots after current time for today
      DateFormat slotFormat = DateFormat('h:mm a');
      DateTime currentTime =
          DateTime(now.year, now.month, now.day, now.hour, now.minute);
      List<String> availableSlots = [];

      for (String slot in slots) {
        try {
          DateTime slotTime = DateFormat('yyyy-MM-dd')
              .parse('${DateFormat('yyyy-MM-dd').format(selectedDateTime)}')
              .add(Duration(
                  hours: slotFormat.parse(slot).hour,
                  minutes: slotFormat.parse(slot).minute));
          if (slotTime.isAfter(currentTime)) {
            availableSlots.add(slot);
          }
        } catch (e) {
          print("Error parsing slot time: $e");
        }
      }
      return availableSlots;
    } else {
      // Show all slots for tomorrow
      return slots;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Facility Name fetched from the prev screen (Facility info screen)
    final String title = ModalRoute.of(context)?.settings.arguments as String;
    String formattedDate = selectedDate != null
        ? DateFormat('dd/MM/yyyy').format(selectedDate!)
        : 'Date not selected';

    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    // Update available durations when a slot is selected
    if (isSlotSelected != -1) {
      _updateAvailableDurations();
    }

    // Calculate the sized box height for time & duration title (Slots Avail, Duration)
    double titleSizedBoxHeight(double height) => height < 600 ? 8 : 10;
    double smallSizedBoxHeight(double height) => height < 600 ? 13 : 15;
    double buttonSizedBox(double height) => height < 600 ? 35 : 40;
    double marginSize(double width) => width < 380 ? 3 : (width < 450 ? 5 : 8);

    return Scaffold(
      backgroundColor: GlobalVariables.primaryColor,
      appBar: AppBar(
        backgroundColor: GlobalVariables.primaryColor,
        title: Text(
          title,
          style: GlobalVariables.appbarStyle(context,
              color: GlobalVariables.secondaryColor),
        ),
        leading: GlobalVariables.backButton(context,
            color: GlobalVariables.secondaryColor),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 10, horizontal: 25.0),
              child: CalendarWidget(
                minDate: DateTime.now(),
                maxDate:
                    DateTime(DateTime.now().year, DateTime.now().month + 1, 0),
                onDateSelected: (DateTime date) {
                  setState(() {
                    selectedDate = date;
                    formattedDate = selectedDate.toString();
                  });

                  print('Selected date: $formattedDate');
                },
                showNavigationArrow: false,
                isDialog: false,
              ),
            ),
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: GlobalVariables.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40.0),
                  topRight: Radius.circular(40.0),
                ),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: titleSizedBoxHeight(screenHeight)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: Text(
                        'Slots Available',
                        style: GlobalVariables.facilityBookingStyle(context),
                      ),
                    ),
                    SizedBox(height: smallSizedBoxHeight(screenHeight)),
                    SizedBox(
                      // Height to accommodate two rows
                      height: screenHeight * 0.15,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: (_getAvailableSlots().length / 2).ceil(),
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              // First row (odd indices)
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    // Store the selected string
                                    selectedSlot =
                                        _getAvailableSlots()[index * 2];
                                    isSlotSelected = index * 2;
                                  });
                                  print('$selectedSlot');
                                },
                                child: Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.22,
                                  height: screenHeight * 0.05,
                                  margin: EdgeInsets.symmetric(
                                    horizontal: marginSize(screenWidth),
                                    vertical: marginSize(screenWidth),
                                  ),
                                  decoration: BoxDecoration(
                                    color: isSlotSelected == index * 2
                                        ? GlobalVariables.primaryColor
                                        : GlobalVariables.secondaryColor,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Center(
                                    child: Text(
                                      // Ensure each row gets a different slot
                                      _getAvailableSlots()[index * 2],
                                      style: GlobalVariables.bookingTimeStyle(
                                        context,
                                        color: isSlotSelected == index * 2
                                            ? GlobalVariables.secondaryColor
                                            : GlobalVariables.primaryColor,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              // Second row (even indices)
                              // Check to avoid index overflow
                              if (index * 2 + 1 < _getAvailableSlots().length)
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      selectedSlot =
                                          _getAvailableSlots()[index * 2 + 1];
                                      isSlotSelected = index * 2 + 1;
                                    });
                                    print('$selectedSlot');
                                  },
                                  child: Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.22,
                                    height: screenHeight * 0.05,
                                    margin: EdgeInsets.symmetric(
                                        horizontal: marginSize(screenWidth),
                                        vertical: marginSize(screenWidth)),
                                    decoration: BoxDecoration(
                                      color: isSlotSelected == index * 2 + 1
                                          ? GlobalVariables.primaryColor
                                          : GlobalVariables.secondaryColor,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Center(
                                      child: Text(
                                        // Display the next slot for the second row
                                        _getAvailableSlots()[index * 2 + 1],
                                        style: GlobalVariables.bookingTimeStyle(
                                          context,
                                          color: isSlotSelected == index * 2 + 1
                                              ? GlobalVariables.secondaryColor
                                              : GlobalVariables.primaryColor,
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

                    // CupertinoTheme(
                    //   data: const CupertinoThemeData(
                    //     textTheme: CupertinoTextThemeData(
                    //       dateTimePickerTextStyle: TextStyle(
                    //         color: GlobalVariables.primaryColor,
                    //         fontSize: 18.0,
                    //         fontWeight: FontWeight.bold,
                    //       ),
                    //     ),
                    //   ),
                    //   child: Center(
                    //     child: Container(
                    //       height: 100,
                    //       width: 200,
                    //       decoration: BoxDecoration(
                    //         color: GlobalVariables.white,
                    //         borderRadius: BorderRadius.circular(20.0),
                    //         // boxShadow: [
                    //         //   BoxShadow(
                    //         //     color: Colors.grey.withOpacity(0.5),
                    //         //     spreadRadius: 2,
                    //         //     blurRadius: 8,
                    //         //     offset: Offset(4, 6),
                    //         //   ),
                    //         // ],
                    //       ),
                    //       child: Padding(
                    //         padding: const EdgeInsets.symmetric(
                    //             vertical: 20.0, horizontal: 20.0),
                    //         child: CupertinoDatePicker(
                    //           mode: CupertinoDatePickerMode.time,
                    //           minuteInterval: 30,
                    //           initialDateTime: _getAdjustedInitialTime(),
                    //           onDateTimeChanged: (DateTime value) {
                    //             setState(() {
                    //               selectedTime = TimeOfDay.fromDateTime(value);
                    //             });
                    //             print('Selected time: $selectedTime');
                    //           },
                    //           use24hFormat: false,
                    //         ),
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    SizedBox(height: titleSizedBoxHeight(screenHeight)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: Text(
                        'Duration',
                        style: GlobalVariables.facilityBookingStyle(context),
                      ),
                    ),
                    SizedBox(height: smallSizedBoxHeight(screenHeight)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed:
                              availableDurations.isNotEmpty && selectedIndex > 0
                                  ? () {
                                      setState(() {
                                        selectedIndex--;
                                      });
                                    }
                                  : null,
                          icon: Icon(
                            Icons.remove,
                            color: GlobalVariables.primaryColor,
                            size: GlobalVariables.responsiveIconSize(
                              context,
                              20,
                            ),
                          ),
                        ),
                        Container(
                          height: screenHeight * 0.06,
                          width: screenWidth * 0.35,
                          decoration: BoxDecoration(
                            color: GlobalVariables.primaryColor,
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          child: Center(
                            child: Text(
                              availableDurations.isNotEmpty
                                  ? _formatDuration(
                                      availableDurations[selectedIndex])
                                  : 'Select a slot',
                              style: TextStyle(
                                  color: GlobalVariables.white,
                                  fontSize: GlobalVariables.responsiveFontSize(
                                      context, 20),
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: availableDurations.isNotEmpty &&
                                  selectedIndex < availableDurations.length - 1
                              ? () {
                                  setState(() {
                                    selectedIndex++;
                                  });
                                  print(
                                      'Plus button pressed. New selectedIndex: $selectedIndex');
                                }
                              : null,
                          icon: Icon(
                            Icons.add,
                            color: GlobalVariables.primaryColor,
                            size: GlobalVariables.responsiveIconSize(
                              context,
                              20,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: buttonSizedBox(screenHeight)),
                    MyButton(
                      color: GlobalVariables.secondaryColor,
                      textColor: GlobalVariables.primaryColor,
                      text: 'Next',
                      onTap: () {
                        if (selectedDate != null && selectedSlot != null) {
                          showBottomSheetModal(
                            context,
                            'Booking Details',
                            'Location: $title\nDate: $formattedDate\nTime: $selectedSlot\nDuration: ${_formatDuration(durations[selectedIndex])}',
                            true,
                            buttonText: 'Book Now',
                            isBooking: true,
                            rooms: rooms,
                            onTap: () {
                              Popup(
                                  title: 'Booking Successful!',
                                  content: Icon(
                                    Icons.check_circle_rounded,
                                    size: GlobalVariables.responsiveIconSize(
                                        context, 50),
                                    color: Colors.green,
                                  ),
                                  buttons: [
                                    ButtonConfig(
                                        text: 'OK',
                                        onPressed: () {
                                          Navigator.pop(context);
                                        })
                                  ]).show(context);
                            },
                          );
                        } else {
                          Popup(
                              title: 'Incomplete Selection',
                              content:
                                  const Text('Please select a date or a time'),
                              buttons: [
                                ButtonConfig(
                                  text: 'OK',
                                  onPressed: () {
                                    Navigator.of(context).pop;
                                  },
                                ),
                              ]).show(context);
                        }
                      },
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  // DateTime _getAdjustedInitialTime() {
  //   DateTime now = DateTime.now();
  //   DateTime eightThirty = DateTime(now.year, now.month, now.day, 8, 30);

  //   if (now.isBefore(eightThirty)) {
  //     // If current time is before 8:30 AM, set to 8:30 AM
  //     return eightThirty;
  //   } else {
  //     // Round to the nearest 30-minute interval after 8:30 AM
  //     int roundedMinute = (now.minute < 30) ? 30 : 0;
  //     int adjustedHour = (roundedMinute == 0) ? now.hour + 1 : now.hour;

  //     return DateTime(
  //         now.year, now.month, now.day, adjustedHour, roundedMinute);
  //   }
  // }
}
