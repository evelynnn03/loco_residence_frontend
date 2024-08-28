// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:loco_frontend/src/widgets/calendar.dart';
import 'package:loco_frontend/src/widgets/option_button.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../screens/visitor/generate_qrcode_screen.dart';
import '../widgets/buttons.dart';
import '../widgets/text_field.dart';
import '../constants/global_variables.dart';
import '../../guard/provider/visitor_parking_provider.dart';

class VisitorRegTab extends StatefulWidget {
  const VisitorRegTab({Key? key}) : super(key: key);
  static const String routeName = '/visitor-register';

  @override
  State<VisitorRegTab> createState() => _VisitorRegisterScreenState();
}

class _VisitorRegisterScreenState extends State<VisitorRegTab> {
  final fullNameTextController = TextEditingController();
  final phoneNoTextController = TextEditingController();
  final carPlateTextController = TextEditingController();
  final dateTextController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  int qrCounter = 0;
  late String residentId;
  String unitNo = '';
  int occupiedParking = 0;
  int remaining = 0;
  int isSelectedIndex = 0;
  String purpose = '';
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _retrieveUserDetails();
  }

  Future<void> _retrieveUserDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      residentId = prefs.getString('residentId') ?? '';
      unitNo = prefs.getString('unitNo') ?? '';
    });
  }

  bool hasCarparkSpace() {
    int remainingParkingLots =
        Provider.of<VisitorDetailsProvider>(context, listen: false)
            .returnRemainingParkingLot();
    // int remainingParkingLots = 0;
    if (remainingParkingLots == 0) {
      return false;
    }
    return true;
  }

  Future registerVisitor(BuildContext context) async {
    try {
      //if carplate is empty AND (has carplate no AND carpark has place)
      if (carPlateTextController.text.trim() == "" ||
          (carPlateTextController.text.trim() != "" && hasCarparkSpace())) {
        DocumentReference docRef =
            await FirebaseFirestore.instance.collection('Visitor').add({
          "Full Name": fullNameTextController.text.trim(),
          "Check-in Date": dateTextController.text.trim(),
          "Car Plate": carPlateTextController.text.trim(),
          "Phone Number": phoneNoTextController.text.trim(),
          "Unit No": unitNo,
        });

        setState(() {
          qrCounter++; // Update with your new data
        });

        // Create a string representing visitor data
        //_doc is the generated visitor id, that will be used later in guard screens
        String visitorData = "_doc        : ${docRef.id}\n"
            "Name            : ${fullNameTextController.text.trim()}\n"
            "Car Plate No.   : ${carPlateTextController.text.trim()}\n"
            "Unit No.        : $unitNo\n"
            "Checked In Date : ${dateTextController.text.trim()}\n"
            "H/P No.         : ${phoneNoTextController.text.trim()}";

        print(visitorData);
        // Navigate to QRCodeGenerator page
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return QRCodeGenerator(
                generateNewQrData: () => visitorData,
              );
            },
          ),
        );

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Registration successful'),
            duration: Duration(seconds: 2),
          ),
        );

        fullNameTextController.clear();
        carPlateTextController.clear();
        dateTextController.clear();
        phoneNoTextController.clear();
      } else if (!hasCarparkSpace() &&
          carPlateTextController.text.trim() != "") {
        //no carpark space and has carplate input
        throw Exception('Peak hour: No more visitor car park for now');
      } else {
        print('hasCarpark : ${hasCarparkSpace()}');
        throw Exception('An unknown error occured for fetching parking data');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.toString()),
        duration: Duration(seconds: 3),
      ));
    }
  }

  // Date format when display on the check-in date text field
  void _formatDate(DateTime date) {
    // only takes year, month, and day, not time
    _selectedDate = DateTime(date.year, date.month, date.day);

    setState(() {
      // set the check-in date text controller to this format
      dateTextController.text = DateFormat('dd/MM/yyyy').format(_selectedDate!);
    });
  }

  @override
  Widget build(BuildContext context) {
    Color buttonColor1 = GlobalVariables.lightGrey;
    Color buttonColor2 = GlobalVariables.primaryColor;

    // Color backgroundColor = Theme.of(context).primaryColor;
    // int remainingParkingLots =
    //     Provider.of<VisitorDetailsProvider>(context, listen: false)
    //         .returnRemainingParkingLot();

    return Scaffold(
      backgroundColor: GlobalVariables.secondaryColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 50),
                  Text(
                    "Register Visitor\nDetails",
                    style: GlobalVariables.headingStyle(context),
                  ),

                  const SizedBox(height: 40),
                  MyTextField(
                      controller: fullNameTextController,
                      labelText: 'Full Name',
                      keyboardType: TextInputType.text,
                      onChanged: (text) {
                        fullNameTextController.text = text.capitalize!;
                      }
                      // prefixIcon: Icons.person,
                      ),

                  const SizedBox(height: 30),
                  MyTextField(
                    controller: dateTextController,
                    labelText: 'Check-in date',
                    obscureText: false,
                    keyboardType: TextInputType.none,

                    // SHOW THE CALENDER
                    onTap: () async {
                      DateTime? pickedDate = await showCalendar(context,
                          minDate: DateTime.now(),
                          maxDate: DateTime.now().add(const Duration(days: 7)));

                      if (pickedDate != null) {
                        // Format the date if necessary and set it to the controller
                        _formatDate(pickedDate);
                      }
                    },

                    prefixIcon: Icons.date_range,
                  ),

                  const SizedBox(height: 30),
                  MyTextField(
                      controller: carPlateTextController,
                      labelText: 'Car Plate',
                      keyboardType: TextInputType.text,
                      onChanged: (text) {
                        // Automatically converts text to uppercase
                        carPlateTextController.text = text.toUpperCase();
                      }
                      // prefixIcon: Icons.car_rental,
                      ),

                  const SizedBox(height: 30),
                  MyTextField(
                    controller: phoneNoTextController,
                    labelText: 'Phone no.',
                    keyboardType: TextInputType.phone,
                    inputFormatters: [PhoneInputFormatter()],
                    // prefixIcon: Icons.phone,
                  ),

                  const SizedBox(height: 30),
                  Row(
                    children: [
                      Expanded(
                        child: OptionButton(
                          text: 'Visitor',
                          color: isSelectedIndex == 0
                              ? buttonColor2
                              : buttonColor1,
                          isChosen: isSelectedIndex == 0,
                          onSelected: (boolSelect) {
                            setState(() {
                              purpose = 'Visitor';
                              isSelectedIndex = boolSelect ? 0 : -1;
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: OptionButton(
                          text: 'Delivery',
                          color: isSelectedIndex == 1
                              ? buttonColor2
                              : buttonColor1,
                          isChosen: isSelectedIndex == 1,
                          onSelected: (boolSelect) {
                            setState(() {
                              purpose = 'Delivery';
                              isSelectedIndex = boolSelect ? 1 : -1;
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: OptionButton(
                          text: 'Constructor',
                          color: isSelectedIndex == 2
                              ? buttonColor2
                              : buttonColor1,
                          isChosen: isSelectedIndex == 2,
                          onSelected: (boolSelect) {
                            setState(() {
                              purpose = 'Constructor';
                              isSelectedIndex = boolSelect ? 2 : -1;
                            });
                          },
                        ),
                      ),
                    ],
                  ),

                  //generate qr code button
                  const SizedBox(height: 40),
                  MyButton(
                      onTap: () {
                        if (formKey.currentState!.validate()) {
                          // Form is valid, perform the registration
                          registerVisitor(context);
                        }
                      },
                      text: 'Generate QR Code'),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Future<void> showCalendar(BuildContext context) async {
  //   DateTime currentDate = DateTime.now();

  //   DateTime? selectedDate = await showDatePicker(
  //     context: context,
  //     initialDate: currentDate,
  //     firstDate: currentDate, // Restrict to dates from today onwards
  //     lastDate: DateTime(2024, 12, 31), // Adjust the last date as needed
  //   );

  //   if (selectedDate != null && selectedDate != currentDate) {
  //     // Handle the selected date
  //     String formattedDate = DateFormat('dd/MM/yyyy').format(selectedDate);
  //     print('$formattedDate');

  //     dateTextController.text = formattedDate;
  //     // Do something with the selected date
  //   } else if (selectedDate == null) {
  //     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
  //       content: Text('Please select a date.'),
  //       duration: Duration(seconds: 3),
  //     ));
  //   }
  // }
}
