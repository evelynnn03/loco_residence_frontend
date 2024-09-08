import 'package:flutter/material.dart';
import 'package:loco_frontend/src/constants/global_variables.dart';

class FacilityTiles extends StatelessWidget {
  const FacilityTiles({super.key});

  @override
  Widget build(BuildContext context) {
    String facility = 'Loco Pickle Ball Court';
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

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 8.0),
      child: Container(
        width: double.infinity,
        height: containerHeight,
        decoration: BoxDecoration(
          color: Colors.grey[300],
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
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 12.0),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(15.0),
                child: Image.asset(
                  'assets/images/gym.jpeg',
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
                    facility,
                    style: TextStyle(
                        fontSize:
                            GlobalVariables.responsiveFontSize(context, 15.0),
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '8 AM - 10 PM',
                    style: TextStyle(
                      fontSize:
                          GlobalVariables.responsiveFontSize(context, 15.0),
                    ),
                  ),
                  SizedBox(height: containerHeight * 0.25),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/booking_screen',
                          arguments: facility);
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
                              fontSize: GlobalVariables.responsiveFontSize(
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
  }
}
