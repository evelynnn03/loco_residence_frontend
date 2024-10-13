import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:loco_frontend/src/constants/global_variables.dart';
import 'package:loco_frontend/src/provider/booking_provider.dart';
import 'package:loco_frontend/src/widgets/bottom_sheet.dart';
import 'package:loco_frontend/src/widgets/buttons.dart';
import 'package:loco_frontend/src/widgets/calendar.dart';
import 'package:loco_frontend/src/widgets/pop_up_window.dart';
import 'package:provider/provider.dart';
import '../../models/time_slot.dart';

class BookingScreen extends StatefulWidget {
  const BookingScreen({super.key});
  static const String routeName = '/booking_screen';

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  DateTime selectedDate = DateTime.now();
  List<String> selectedSlot = []; // List of selected slots. eg 1,2,3
  String? selectedSection;
  int isSlotSelected = -1;
  String facilityId = '';
  String facilityName = '';
  String facilityDesc = '';

  List<int> availableDurations = []; //to show to available durations to book. eg: 9:00, 9:30
  List<String> slotsToBook = [];
  int selectedIndex = 0; // Index of the selected duration in the list

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

  @override
  void initState() {
    super.initState();
    // initialize required booking data
    WidgetsBinding.instance.addPostFrameCallback((_) => _initializeBookingData());
  }

  void _initializeBookingData() {
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    facilityId = args['facilityId']?.toString() ?? '';
    facilityName = args['facilityName']?.toString() ?? '';
    facilityDesc = args['facilityDescription']?.toString() ?? '';

    if (facilityId.isEmpty || facilityName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid facility information provided.')),
      );
      Navigator.pop(context);
    } else {
      _fetchAvailableTimeSlots(selectedDate).catchError((error) {
        print('Error fetching available slots or sections: $error');
      });
    }
  }
  

  String _formatDuration(int minutes) {
    final int hours = minutes ~/ 60;
    final int mins = minutes % 60;

    if (minutes == 30) return '30 minutes';
    if (mins == 0) return '$hours hour${hours > 1 ? 's' : ''}';
    return '$hours.${(mins / 60 * 10).round()} hours';
  }

  // Get the available hours
  List<int> _getAvailableDurations() {
    if (selectedSlot.isEmpty) return [];

    DateFormat format = DateFormat("HH:mm:ss");

    // Assuming you want to use the first slot from the list
    DateTime startTime = format.parse(selectedSlot.first);
    DateTime endTime = format.parse("22:00:00");

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
    List<TimeSlot> timeSlotList = Provider.of<BookingProvider>(context, listen: false).timeSlots;
    List<String> availableSlots = [];

    DateTime now = DateTime.now();
    DateTime selectedDateTime = selectedDate;

    bool isToday = DateFormat('dd/MM/yyyy').format(selectedDateTime) == DateFormat('dd/MM/yyyy').format(now);

    if (isToday) {
      DateFormat slotFormat = DateFormat('HH:mm:ss');
      DateTime currentTime = DateTime(now.year, now.month, now.day, now.hour, now.minute);

      for (TimeSlot slot in timeSlotList) {
        try {
          DateTime slotStartTime = DateFormat('yyyy-MM-dd')
              .parse(DateFormat('yyyy-MM-dd').format(selectedDateTime))
              .add(Duration(
                  hours: slotFormat.parse(slot.startTime).hour,
                  minutes: slotFormat.parse(slot.startTime).minute));

          if (slotStartTime.isAfter(currentTime)) {
            availableSlots.add(slot.startTime);
          }
        } catch (e) {
          print("Error parsing slot start time: $e");
        }
      }
      return availableSlots;
    } else {
      return timeSlotList.map((slot) => slot.startTime).toList();
    }
  }



  // Fetch available time slots based on selected date
  Future<void> _fetchAvailableTimeSlots(DateTime date) async {
    await Provider.of<BookingProvider>(context, listen: false)
        .fetchAvailableTimeSlots(
            facilityId, DateFormat('yyyy-MM-dd').format(date));
  }

// Fetch available sections based on available slots
// 1. Add print statements to track the flow of execution
  Future<void> _fetchAvailableSections(List<String> availableSlots) async {
    print("1. _fetchAvailableSections called with slots: $availableSlots");
    await Provider.of<BookingProvider>(context, listen: false)
        .fetchFacilitySections(
      facilityId,
      DateFormat('yyyy-MM-dd').format(selectedDate),
      availableSlots,
    );
  }

  // Method to generate time slots between startTime and the calculated end time
  List<String> generateTimeSlots(String startTime, int durationInMinutes) {
    final timeParts = startTime.split(':');
    final int startHours = int.parse(timeParts[0]);
    final int startMinutes = int.parse(timeParts[1]);

    final int totalStartMinutes = startHours * 60 + startMinutes;
    final int totalEndMinutes = totalStartMinutes + durationInMinutes;

    List<String> slots = [];
    for (int currentMinutes = totalStartMinutes;
        currentMinutes <= totalEndMinutes;
        currentMinutes += 30) {
      final int hours = (currentMinutes ~/ 60) % 24;
      final int minutes = currentMinutes % 60;
      final DateTime slotTime = DateTime(0, 1, 1, hours, minutes);
      // Format in 24-hour time
      slots.add(DateFormat('HH:mm:ss').format(slotTime)); // Use HH:mm:ss format
    }

    return slots;
  }

  // Book facility section
  void _onBookNowTap(
      List<String?> selectedSlots, int selectedDuration, String sectionId) {
    if (selectedSlots.isEmpty || selectedSlots.contains(null)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No time slots selected.')),
      );
      return;
    }

    final bookingProvider =
        Provider.of<BookingProvider>(context, listen: false);
  // Filter out any null slots
    final availableSlots =
        selectedSlots.where((slot) => slot != null).cast<String>().toList();

    if (availableSlots.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No valid time slot IDs found.')),
      );
      return;
    }

    String formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate);
    final startTime = availableSlots.first;

    // Calculate end time and intermediate slots
    final List<String> generatedSlots =
        generateTimeSlots(startTime, selectedDuration);

    // Get only intermediate slots (excluding the end time)
    final List<String> intermediateSlots =
        generatedSlots.sublist(1, generatedSlots.length - 1);

    // Create a list that includes the start time and the intermediate slots
    final List<String> slotsToBook = [startTime] + intermediateSlots;
    print(slotsToBook);

    // Call the booking method with the start time and intermediate time slots
    bookingProvider
        .bookFacilitySections(
            facilityId,
            formattedDate,
            slotsToBook, // Pass both the start time and intermediate time slots
            sectionId,
            context)
        .then((_) {
      _fetchAvailableSections(availableSlots);
      setState(() {
        _fetchAvailableTimeSlots(selectedDate);
      });

      Popup(
        title: 'Booking Successful!',
        content: Icon(
          Icons.check_circle_rounded,
          size: GlobalVariables.responsiveIconSize(context, 50),
          color: Colors.green,
        ),
        buttons: [
          ButtonConfig(text: 'OK', onPressed: () {}),
        ],
      ).show(context);
    }).catchError((error) {
      print('Error during booking: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to book facility: $error')),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final bookingProvider = Provider.of<BookingProvider>(context);
    final isLoading = bookingProvider.isLoading;
    String formattedDate = DateFormat('dd/MM/yyyy').format(selectedDate);

    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    // Update available durations when a slot is selected
    if (isSlotSelected != -1) {
      _updateAvailableDurations();
    }

    // List of Available Slots
    List<String> availableSlots = _getAvailableSlots();

    

    // Map to get the section names & section IDs
    // List<String> sectionNames = bookingProvider.facilitySections
    //     .map((section) => section.sectionName)
    //     .toList();
    // List<int> facilitySectionIds = bookingProvider.facilitySectionIds;

    DateTime minDate = DateTime.now();
    DateTime maxDate;

    // Check if today is the last day of the month
    if (minDate.day == DateTime(minDate.year, minDate.month + 1, 0).day) {
      // Today is the last day of the current month, so set maxDate to the last day of next month
      if (minDate.month == 12) {
        // If December, roll over to January of the next year
        maxDate = DateTime(minDate.year + 1, 1, 31);
      } else {
        // Set to the last day of the next month
        maxDate = DateTime(minDate.year, minDate.month + 2, 0);
      }
    } else {
      // If today is not the last day of the month, set maxDate to the last day of the next month
      maxDate = DateTime(minDate.year, minDate.month + 2, 0);
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
          facilityName,
          style: GlobalVariables.appbarStyle(context,
              color: GlobalVariables.secondaryColor),
        ),
        leading: GlobalVariables.backButton(context,
            color: GlobalVariables.secondaryColor),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 25.0),
            child: CalendarWidget(
              minDate: minDate,
              maxDate: maxDate,
              onDateSelected: (DateTime date) {
                setState(() {
                  selectedDate = date;
                  _fetchAvailableTimeSlots(selectedDate);
                });
              },
              showNavigationArrow: false,
              isDialog: false,
            ),
          ),
          Flexible(
            child: Container(
              width: double.infinity,
              height: double.infinity,
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
                child: SingleChildScrollView(
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
                      isLoading
                          ? const Center(
                              child: CircularProgressIndicator(
                                color: GlobalVariables.primaryColor,
                              ),
                            )
                          : availableSlots.isEmpty
                              ? Center(
                                  child: Text(
                                    'No available slots',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: GlobalVariables.primaryColor
                                          .withOpacity(0.3),
                                    ),
                                  ),
                                )
                              : Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      // Height to accommodate two rows
                                      height: screenHeight * 0.15,
                                      child: ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        // Use ceil() to handle odd-length arrays
                                        itemCount:
                                            (availableSlots.length / 2).ceil(),
                                        itemBuilder: (context, index) {
                                          // Ensure the index * 2 and (index * 2 + 1) don't go out of bounds
                                          String? slotTime1;
                                          String? slotTime2;

                                          // Check for slotTime1
                                          if (index * 2 <
                                              availableSlots.length) {
                                            slotTime1 = DateFormat('h:mm a')
                                                .format(DateFormat('HH:mm:ss')
                                                    .parse(availableSlots[
                                                        index * 2]));
                                          }

                                          // Check for slotTime2
                                          if (index * 2 + 1 <
                                              availableSlots.length) {
                                            slotTime2 = DateFormat('h:mm a')
                                                .format(DateFormat('HH:mm:ss')
                                                    .parse(availableSlots[
                                                        index * 2 + 1]));
                                          }

                                          return Column(
                                            children: [
                                              // Only display if slotTime1 exists
                                              if (slotTime1 != null)
                                                GestureDetector(
                                                  onTap: () {
                                                    setState(() {
                                                      selectedSlot = [
                                                        availableSlots[
                                                            index * 2]
                                                      ];
                                                      isSlotSelected =
                                                          index * 2;
                                                    });
                                                    print(
                                                        'Selected slot: $selectedSlot');
                                                  },
                                                  child: Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.22,
                                                    height: screenHeight * 0.05,
                                                    margin:
                                                        EdgeInsets.symmetric(
                                                      horizontal: marginSize(
                                                          screenWidth),
                                                      vertical: marginSize(
                                                          screenWidth),
                                                    ),
                                                    decoration: BoxDecoration(
                                                      color: isSlotSelected ==
                                                              index * 2
                                                          ? GlobalVariables
                                                              .primaryColor
                                                          : GlobalVariables
                                                              .secondaryColor,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                    ),
                                                    child: Center(
                                                      child: Text(
                                                        slotTime1,
                                                        style: GlobalVariables
                                                            .bookingTimeStyle(
                                                          context,
                                                          color: isSlotSelected ==
                                                                  index * 2
                                                              ? GlobalVariables
                                                                  .secondaryColor
                                                              : GlobalVariables
                                                                  .primaryColor,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),

                                              // Only display if slotTime2 exists
                                              if (slotTime2 != null)
                                                GestureDetector(
                                                  onTap: () {
                                                    setState(() {
                                                      selectedSlot = [
                                                        availableSlots[
                                                            index * 2 + 1]
                                                      ];
                                                      isSlotSelected =
                                                          index * 2 + 1;
                                                    });
                                                    print(
                                                        'selected slot: $selectedSlot');
                                                  },
                                                  child: Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.22,
                                                    height: screenHeight * 0.05,
                                                    margin:
                                                        EdgeInsets.symmetric(
                                                      horizontal: marginSize(
                                                          screenWidth),
                                                      vertical: marginSize(
                                                          screenWidth),
                                                    ),
                                                    decoration: BoxDecoration(
                                                      color: isSlotSelected ==
                                                              index * 2 + 1
                                                          ? GlobalVariables
                                                              .primaryColor
                                                          : GlobalVariables
                                                              .secondaryColor,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                    ),
                                                    child: Center(
                                                      child: Text(
                                                        slotTime2,
                                                        style: GlobalVariables
                                                            .bookingTimeStyle(
                                                          context,
                                                          color: isSlotSelected ==
                                                                  index * 2 + 1
                                                              ? GlobalVariables
                                                                  .secondaryColor
                                                              : GlobalVariables
                                                                  .primaryColor,
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
                                    SizedBox(
                                        height:
                                            titleSizedBoxHeight(screenHeight)),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 15.0),
                                      child: Text(
                                        'Duration',
                                        style: GlobalVariables
                                            .facilityBookingStyle(context),
                                      ),
                                    ),
                                    SizedBox(
                                        height:
                                            smallSizedBoxHeight(screenHeight)),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        IconButton(
                                          onPressed:
                                              availableDurations.isNotEmpty &&
                                                      selectedIndex > 0
                                                  ? () {
                                                      setState(() {
                                                        selectedIndex--;
                                                      });
                                                    }
                                                  : null,
                                          icon: Icon(
                                            Icons.remove,
                                            color: GlobalVariables.primaryColor,
                                            size: GlobalVariables
                                                .responsiveIconSize(
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
                                            borderRadius:
                                                BorderRadius.circular(15.0),
                                          ),
                                          child: Center(
                                            child: Text(
                                              availableDurations.isNotEmpty
                                                  ? _formatDuration(
                                                      availableDurations[
                                                          selectedIndex])
                                                  : 'Select a slot',
                                              style: TextStyle(
                                                  color: GlobalVariables.white,
                                                  fontSize: GlobalVariables
                                                      .responsiveFontSize(
                                                          context, 20),
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                        IconButton(
                                          onPressed:
                                              availableDurations.isNotEmpty &&
                                                      selectedIndex <
                                                          availableDurations
                                                                  .length -
                                                              1
                                                  ? () {
                                                      setState(() {
                                                        selectedIndex++;
                                                      });
                                                    }
                                                  : null,
                                          icon: Icon(
                                            Icons.add,
                                            color: GlobalVariables.primaryColor,
                                            size: GlobalVariables
                                                .responsiveIconSize(
                                              context,
                                              20,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                        height: buttonSizedBox(screenHeight)),

                                    // Next button to show bottom sheet modal
                                    MyButton(
                                      color: GlobalVariables.secondaryColor,
                                      textColor: GlobalVariables.primaryColor,
                                      text: 'Next',
                                      onTap: () async {
                                        print(selectedSlot);

                                        // Check if availableDurations is not empty and selectedIndex is valid
                                        if (availableDurations.isEmpty ||
                                            selectedIndex < 0 ||
                                            selectedIndex >=
                                                availableDurations.length) {
                                          Popup(
                                            title: 'Incomplete Selection',
                                            content: const Text(
                                                'Please select a time slot'),
                                            buttons: [
                                              ButtonConfig(
                                                text: 'OK',
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                            ],
                                          ).show(context);
                                          return; // Early return to prevent further execution
                                        }

                                        // Get the selected duration using selectedIndex (from availableDurations list)
                                        int selectedDuration =
                                            availableDurations[selectedIndex];

                                        // List of time slots including start and inter slots
                                        List<String> slotsToBook =
                                            generateTimeSlots(
                                                selectedSlot.first,
                                                selectedDuration - 1);
                                        print(slotsToBook);

                                        // Calculate end time based on selected slot and the selected duration
                                        List<String> generatedSlots =
                                            generateTimeSlots(
                                                selectedSlot.first,
                                                selectedDuration);

                                        final endTime = DateFormat('h:mm a')
                                            .format(DateFormat('HH:mm:ss')
                                                .parse(generatedSlots.last));

                                        // Convert selectedSlot to 12-hour format with AM/PM, handling null cases
                                        String formatSelectedSlot(
                                            String? selectedSlot) {
                                          // Return an empty string or any default value when selectedSlot is null
                                          if (selectedSlot == null ||
                                              selectedSlot.isEmpty) {
                                            return '';
                                          }

                                          // Assuming selectedSlot is in HH:mm:ss format
                                          DateTime selectedSlotTime =
                                              DateFormat('HH:mm:ss')
                                                  .parse(selectedSlot);

                                          // Convert to h:mm a format
                                          return DateFormat('h:mm a')
                                              .format(selectedSlotTime);
                                        }

                                        if (selectedSlot.isNotEmpty) {
                                          await _fetchAvailableSections(
                                              slotsToBook);

                                          final updatedFacilitySectionIds =
                                              Provider.of<BookingProvider>(
                                                      context,
                                                      listen: false)
                                                  .facilitySectionIds;
                                          final updatedSectionNames = Provider.of<BookingProvider>(
                                                      context,
                                                      listen: false)
                                                  .facilitySectionNames;

                                          print(updatedFacilitySectionIds);
                                          print(updatedSectionNames);
                                          if (updatedFacilitySectionIds
                                              .isNotEmpty) {
                                            showBottomSheetModal(
                                              context,
                                              'Booking Details',
                                              'Location: $facilityName\nDate: $formattedDate\nStart Time: ${formatSelectedSlot(selectedSlot.first)}\nEnd Time: $endTime\nDuration: ${_formatDuration(durations[selectedIndex])}',
                                              true,
                                              buttonText: 'Book Now',
                                              isBooking: true,
                                              desc: facilityDesc,
                                              facilitySectionId:
                                                  updatedFacilitySectionIds,
                                              facilitySection: updatedSectionNames,
                                              selectedDate: selectedDate,
                                              onSectionSelected:
                                                  (selectedSection) {
                                                // Handle the selected section here
                                                print(
                                                    'Selected Section: $selectedSection');
                                                _onBookNowTap(
                                                    selectedSlot,
                                                    durations[selectedIndex],
                                                    selectedSection!);
                                              },
                                            );
                                          } else {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                  content: Text(
                                                      'No more sections.')),
                                            );
                                          }
                                        }
                                      },
                                    ),
                                  ],
                                ),
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

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
