import 'package:flutter/material.dart';
import 'package:loco_frontend/src/constants/global_variables.dart';
import 'package:loco_frontend/src/provider/facility_provider.dart';
import 'package:provider/provider.dart';

class FacilityInfoScreen extends StatefulWidget {
  const FacilityInfoScreen({super.key});
  static const String routeName = '/facility_screen';

  @override
  State<FacilityInfoScreen> createState() => _FacilityInfoScreenState();
}

class _FacilityInfoScreenState extends State<FacilityInfoScreen> {
  // List of facilities and whether they require booking
  final List<Map<String, dynamic>> facility = [
    {'name': 'Loco Pickle Ball Court', 'requiresBooking': true},
    {'name': 'Loco Gym', 'requiresBooking': false},
    {'name': 'Loco Meeting Room', 'requiresBooking': true},
    {'name': 'Loco Event Hall', 'requiresBooking': true},
  ];

  // List of facilities' images
  final List<String> image = [
    'assets/images/pickleballcourt.jpg',
    'assets/images/gym.jpeg',
    'assets/images/meetingroom.jpg',
    'assets/images/eventhall.jpg',
  ];

  // Operating hours of the facility
  final String hours = '8 AM - 10 PM';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<FacilityProvider>(context, listen: false).fetchFacilities();
    });
  }

  @override
  Widget build(BuildContext context) {
    final facilityList =
        Provider.of<FacilityProvider>(context, listen: false).facilities;
    final isLoading = Provider.of<FacilityProvider>(context).isLoading;
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
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: GlobalVariables.primaryColor,
              ),
            )
          : ListView.builder(
              itemCount: facilityList.length,
              itemBuilder: (BuildContext context, int index) {
                bool isBookingRequired = facilityList[index].bookingRequired;
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 25.0, vertical: 8.0),
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
                          offset: const Offset(4, 6),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 12.0),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(15.0),
                            child: Image.asset(
                              'assets/images/pickleballcourt.jpg',
                              width: 115,
                              height: containerHeight * 0.8,
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(width: sizedBoxWidth(screenWidth)),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: isBookingRequired
                                ? MainAxisAlignment.start
                                : MainAxisAlignment.center,
                            children: [
                              Text(
                                facilityList[index].name,
                                style: TextStyle(
                                  fontSize: GlobalVariables.responsiveFontSize(
                                      context, 15.0),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                facilityList[index].description,
                                style: TextStyle(
                                  fontSize: GlobalVariables.responsiveFontSize(
                                      context, 15.0),
                                ),
                              ),
                              SizedBox(height: containerHeight * 0.1),
                              GestureDetector(
                                onTap: () {
                                  if (isBookingRequired) {
                                    Navigator.pushNamed(
                                      context,
                                      '/booking_screen',
                                      arguments: {
                                        'facilityId': facilityList[index].id,
                                        'facilityName':
                                            facilityList[index].name,
                                        'facilityDescription':
                                            facilityList[index].description,
                                      },
                                    );
                                  }
                                },
                                child: Visibility(
                                  visible: isBookingRequired,
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
                                            fontSize: GlobalVariables
                                                .responsiveFontSize(
                                                    context, 15.0),
                                            color: GlobalVariables.white),
                                      ),
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
