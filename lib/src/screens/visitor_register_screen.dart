// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/buttons.dart';
import '../widgets/text_field.dart';
import '../constants/global_variables.dart';
import '../../guard/provider/visitor_parking_provider.dart';
import 'generate_qrcode_screen.dart';

class VisitorRegisterScreen extends StatefulWidget {
  const VisitorRegisterScreen({Key? key}) : super(key: key);
  static const String routeName = '/visitor-register';

  @override
  State<VisitorRegisterScreen> createState() => _VisitorRegisterScreenState();
}

class _VisitorRegisterScreenState extends State<VisitorRegisterScreen> {
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

  @override
  Widget build(BuildContext context) {
    Color backgroundColor = Theme.of(context).primaryColor;
    // int remainingParkingLots =
    //     Provider.of<VisitorDetailsProvider>(context, listen: false)
    //         .returnRemainingParkingLot();

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 100),
                  const Text(
                    "Register a visitor",
                    style: TextStyle(
                      color: GlobalVariables.backgroundColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 28,
                    ),
                  ),
                  const Text(
                    "Key in visitor details",
                    style: TextStyle(
                      color: GlobalVariables.backgroundColor,
                      fontSize: 16,
                    ),
                  ),

                  const SizedBox(height: 20),
                  MyTextField(
                    controller: fullNameTextController,
                    hintText: 'Full Name',
                    keyboardType: TextInputType.text,
                    prefixIcon: Icons.person,
                  ),

                  const SizedBox(height: 13),
                  Container(
                    child: Column(
                      children: [
                        MyTextField(
                          controller: dateTextController,
                          hintText: 'Check-in date',
                          obscureText: false,
                          keyboardType: TextInputType.none,

                          // SHOW THE CALENDER
                          onTap: () async {
                            // Show the date picker when the text field is tapped
                            await showCalendar(context);
                          },

                          prefixIcon: Icons.date_range,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 13),
                  MyTextField(
                    controller: carPlateTextController,
                    hintText: 'Car Plate',
                    keyboardType: TextInputType.text,
                    validator: (value) {
                      return null; // No validation error
                    },
                    prefixIcon: Icons.car_rental,
                  ),

                  const SizedBox(height: 13),
                  MyTextField(
                    controller: phoneNoTextController,
                    hintText: 'Phone no.',
                    keyboardType: TextInputType.phone,
                    prefixIcon: Icons.phone,
                  ),

                  //signin button
                  const SizedBox(height: 25),
                  MyButton(
                      onTap: () {
                        if (formKey.currentState!.validate()) {
                          // Form is valid, perform the registration
                          registerVisitor(context);
                        }
                      },
                      text: 'Generate QR Code'),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> showCalendar(BuildContext context) async {
    DateTime currentDate = DateTime.now();

    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: currentDate,
      firstDate: currentDate, // Restrict to dates from today onwards
      lastDate: DateTime(2024, 12, 31), // Adjust the last date as needed
    );

    if (selectedDate != null && selectedDate != currentDate) {
      // Handle the selected date
      String formattedDate = DateFormat('dd/MM/yyyy').format(selectedDate);
      print('$formattedDate');

      dateTextController.text = formattedDate;
      // Do something with the selected date
    } else if (selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Please select a date.'),
        duration: Duration(seconds: 3),
      ));
    }
  }
}
