import 'package:flutter/material.dart';
import '../constants/global_variables.dart';
import '../widgets/service_items.dart';

class ServiceContactScreen extends StatelessWidget {
  const ServiceContactScreen({super.key});
  static const String routeName = '/service_contact';

  @override
  Widget build(BuildContext context) {
    // Color? iconColor = Theme.of(context).indicatorColor;

    return Scaffold(
      backgroundColor: GlobalVariables.secondaryColor,
      appBar: AppBar(
        backgroundColor: GlobalVariables.secondaryColor,
        title: Text(
          'Service Contacts',
          style: GlobalVariables.appbarStyle(context),
        ),
        leading: GlobalVariables.backButton(context),
      ),
      body: const SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              SizedBox(height: 20),
              ServiceItems(
                imageUrl:
                    'https://firebasestorage.googleapis.com/v0/b/sef-assignment-223b2.appspot.com/o/cleaning_service.jpg?alt=media&token=274458c9-f634-43d3-a0a1-903a8f2bdec3',
                title: 'Cleaning Service',
                phoneNum: '+03 278 5673',
              ),
              SizedBox(
                height: 20,
              ),
              ServiceItems(
                imageUrl:
                    'https://firebasestorage.googleapis.com/v0/b/sef-assignment-223b2.appspot.com/o/repair_service.jpeg?alt=media&token=84359c68-7bf2-4086-8050-a2830c89bc76',
                title: 'Repair Service',
                phoneNum: '+03 488 3791',
              ),
              SizedBox(height: 20),
              ServiceItems(
                imageUrl:
                    'https://firebasestorage.googleapis.com/v0/b/sef-assignment-223b2.appspot.com/o/pest_control.jpeg?alt=media&token=84359c68-7bf2-4086-8050-a2830c89bc76',
                title: 'Pest Control',
                phoneNum: '+03 521 8622',
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
