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
                imageUrl: 'assets/images/cleaning_service.jpg',
                title: 'Cleaning Service',
                phoneNum: '+03 278 5673',
              ),
              SizedBox(
                height: 20,
              ),
              ServiceItems(
                imageUrl:
                    'assets/images/repair_service.jpeg',
                title: 'Repair Service',
                phoneNum: '+03 488 3791',
              ),
              SizedBox(height: 20),
              ServiceItems(
                imageUrl:
                    'assets/images/pest_control.jpg',
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
