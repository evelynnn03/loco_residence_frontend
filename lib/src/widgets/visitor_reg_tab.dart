import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:loco_frontend/src/provider/visitor_provider.dart';
import 'package:loco_frontend/src/utils/resident_utils.dart';
import 'package:loco_frontend/src/widgets/calendar.dart';
import 'package:loco_frontend/src/widgets/option_button.dart';
import 'package:provider/provider.dart';
import '../screens/visitor/generate_qrcode_screen.dart';
import '../widgets/buttons.dart';
import '../widgets/text_field.dart';
import '../constants/global_variables.dart';

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

  int isSelectedIndex = -1;
  String purpose = '';
  DateTime? _selectedDate;

  @override
  void dispose() {
    fullNameTextController.dispose();
    phoneNoTextController.dispose();
    carPlateTextController.dispose();
    dateTextController.dispose();
    super.dispose();
  }

  void registerVisitor(BuildContext context) {
    if (purpose.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a purpose of visit.'),
        ),
      );

      return;
    }
    // Parse the date from the text controller
    final date = DateTime.parse(dateTextController.text);
    // Create a new DateTime with only the date component
    final dateOnly = DateTime(date.year, date.month, date.day);

    final visitorProvider =
        Provider.of<VisitorProvider>(context, listen: false);

    // Then use parsedDate in your registerVisitor call
    visitorProvider
        .registerVisitor(
      fullNameTextController.text,
      phoneNoTextController.text,
      carPlateTextController.text,
      dateOnly, // Use the parsed date
      purpose,
      temporaryResidentId,
      context,
    )
        .then((_) {
      final visitorId = visitorProvider.visitors.isNotEmpty
          ? visitorProvider.visitors.last.id
          : null;

      if (visitorId != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Visior registered successfully.'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => QRCodeGenerator(
              generateNewQrData: () => 'custom qr data',
              visitorData: {
                "id": visitorId.toString(),
                "fullName": fullNameTextController.text,
                "hpNumber": phoneNoTextController.text,
                "carPlateNo": carPlateTextController.text,
                "checkInDate": dateTextController.text,
                "purpose": purpose,
              }, // Pass the visitor details
            ),
          ),
        );
      }
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error registering visitor.'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
    });
  }

  // Date format when display on the check-in date text field
  void _formatDate(DateTime date) {
    // only takes year, month, and day, not time
    _selectedDate = DateTime(date.year, date.month, date.day);

    setState(() {
      // set the check-in date text controller to this format
      dateTextController.text = DateFormat('yyyy-MM-dd').format(_selectedDate!);
    });
  }

  @override
  Widget build(BuildContext context) {
    Color buttonColor1 = GlobalVariables.lightGrey;
    Color buttonColor2 = GlobalVariables.primaryColor;
    final visitorProvider =
        Provider.of<VisitorProvider>(context, listen: false);

    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    double extraLargeSizedBoxHeight(height) => height < 600 ? 40 : 50;
    double largeSizedBoxHeight(height) => height < 600 ? 30 : 40;
    double smallSizedBoxHeight(height) => height < 600 ? 20 : 30;
    double sizedBoxWidth(width) => width < 380 ? 6 : (width < 450 ? 8 : 10);

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
                  SizedBox(height: extraLargeSizedBoxHeight(screenHeight)),
                  Text(
                    "Register Visitor\nDetails",
                    style: GlobalVariables.headingStyle(context),
                  ),

                  SizedBox(height: largeSizedBoxHeight(screenHeight)),
                  MyTextField(
                      controller: fullNameTextController,
                      labelText: 'Full Name',
                      keyboardType: TextInputType.text,
                      onChanged: (text) {
                        fullNameTextController.text = text.capitalize!;
                      }
                      // prefixIcon: Icons.person,
                      ),

                  SizedBox(height: smallSizedBoxHeight(screenHeight)),
                  MyTextField(
                    controller: dateTextController,
                    labelText: 'Check-in date',
                    obscureText: false,
                    keyboardType: TextInputType.none,

                    // SHOW THE CALENDER
                    onTap: () async {
                      DateTime? pickedDate = await showCalendar(
                        context,
                        minDate: DateTime.now(),
                        maxDate: DateTime.now().add(const Duration(days: 7)),
                      );

                      if (pickedDate != null) {
                        // Format the date if necessary and set it to the controller
                        _formatDate(pickedDate);
                      }
                    },

                    prefixIcon: Icons.date_range,
                  ),

                  SizedBox(height: smallSizedBoxHeight(screenHeight)),
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

                  SizedBox(height: smallSizedBoxHeight(screenHeight)),
                  MyTextField(
                    controller: phoneNoTextController,
                    labelText: 'Phone no.',
                    keyboardType: TextInputType.phone,
                    inputFormatters: [PhoneInputFormatter()],
                    // prefixIcon: Icons.phone,
                  ),

                  SizedBox(height: smallSizedBoxHeight(screenHeight)),
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
                      SizedBox(width: sizedBoxWidth(screenWidth)),
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
                      SizedBox(width: sizedBoxWidth(screenWidth)),
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
                  SizedBox(height: largeSizedBoxHeight(screenHeight)),
                  MyButton(
                    onTap: () {
                      if (formKey.currentState!.validate()) {
                        // Form is valid, perform the registration
                        registerVisitor(context);
                      }
                    },
                    text: 'Generate QR Code',
                  ),

                  SizedBox(height: largeSizedBoxHeight(40)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
