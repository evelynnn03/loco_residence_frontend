import 'package:flutter/material.dart';
import 'package:loco_frontend/src/constants/global_variables.dart';

class FacilityInfoScreen extends StatefulWidget {
  const FacilityInfoScreen({super.key});
  static const String routeName = '/facility_screen';

  @override
  State<FacilityInfoScreen> createState() => _FacilityInfoScreenState();
}

class _FacilityInfoScreenState extends State<FacilityInfoScreen> {
  final List<String> facility = [
    'Loco Pickle Ball Court',
    'Loco Gym',
    'Loco Meeting Room',
    'Loco Event Hall'
  ];

  final List<String> image = [
    'assets/images/pickleballcourt.jpg',
    'assets/images/gym.jpeg',
    'assets/images/meetingroom.jpg',
    'assets/images/eventhall.jpg',
  ];

  final String hours = '8 AM - 10 PM';

  @override
  Widget build(BuildContext context) {
    // String facility = 'Loco Pickle Ball Court';
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    double containerHeight = screenHeight * 0.15;

    double buttonHeight(double height) {
      if (containerHeight < 100) {
        return 25;
      } else if (containerHeight < 200) {
        return 30;
      }
      return 35;
    }

    double buttonWidth(double width) {
      if (screenWidth < 380) {
        return 85;
      } else if (screenWidth < 450) {
        return 90;
      }
      return 95;
    }

    double sizedBoxWidth(double screenWidth) {
      if (screenWidth < 380) {
        return 10;
      } else if (screenWidth < 450) {
        return 15;
      }
      return 20;
    }

    return Scaffold(
      backgroundColor: GlobalVariables.secondaryColor,
      appBar: AppBar(
        backgroundColor: GlobalVariables.secondaryColor,
        title: Text(
          'Facility Information',
          style: GlobalVariables.appbarStyle(context),
        ),
        leading: GlobalVariables.backButton(context),
      ),
      body: ListView.builder(
        itemCount: facility.length,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 25.0, vertical: 8.0),
            child: Container(
              width: double.infinity,
              height: containerHeight,
              decoration: BoxDecoration(
                color: Colors.white70,
                borderRadius: BorderRadius.circular(25.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 8,
                    offset: Offset(4, 6),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 15.0, vertical: 12.0),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(15.0),
                      child: Image.asset(
                        image[index],
                        width: 115,
                        height: containerHeight * 0.8,
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(width: sizedBoxWidth(screenWidth)),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          facility[index],
                          style: TextStyle(
                              fontSize: GlobalVariables.responsiveFontSize(
                                  context, 15.0),
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '8 AM - 10 PM',
                          style: TextStyle(
                            fontSize: GlobalVariables.responsiveFontSize(
                                context, 15.0),
                          ),
                        ),
                        SizedBox(height: containerHeight * 0.1),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, '/booking_screen',
                                arguments: facility[index]);
                          },
                          child: Container(
                            height: buttonHeight(containerHeight),
                            width: buttonWidth(screenWidth),
                            decoration: BoxDecoration(
                              color: GlobalVariables.primaryColor,
                              borderRadius: BorderRadius.circular(25.0),
                            ),
                            child: Center(
                              child: Text(
                                'Book Now',
                                style: TextStyle(
                                    fontSize:
                                        GlobalVariables.responsiveFontSize(
                                            context, 15.0),
                                    color: GlobalVariables.white),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
