import 'package:flutter/material.dart';
import 'package:loco_frontend/src/widgets/home_tile.dart';
import '../../src/widgets/bottom_sheet.dart';
import '../../src/widgets/pop_up_window.dart';
import '../../src/constants/global_variables.dart';
import '../widget/guard_arguments.dart';
import 'parking_map_tab.dart';
import 'scan_qrcode_screen.dart';
import 'visitor_timestamp.dart';

class GuardHomeScreen extends StatefulWidget {
  const GuardHomeScreen({super.key});
  static const String routeName = '/guard_home';

  @override
  State<GuardHomeScreen> createState() => _GuardHomeScreenState();
}

class HomepageTitle extends StatelessWidget {
  final String tileName;

  HomepageTitle({
    super.key,
    required this.tileName,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15),
        child: Container(
          height: 200,
          width: 400,
          padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 22),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: GlobalVariables.primaryColor),
          child: Flex(
            direction: Axis.horizontal,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (tileName == 'Scan QR')
                Icon(
                  Icons.qr_code_scanner_rounded,
                  color: Colors.white,
                  size: 95,
                ),
              if (tileName == 'Visitor\nDetails')
                Icon(
                  Icons.recent_actors_rounded,
                  color: Colors.white,
                  size: 95,
                ),
              if (tileName == 'Parking')
                Icon(
                  Icons.minor_crash_rounded,
                  color: Colors.white,
                  size: 95,
                ),
              const Spacer(),
              Text(
                tileName,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 35,
                ),
              ),
              const Spacer(),
              Icon(
                Icons.arrow_circle_right_outlined,
                color: Colors.white,
                size: 55,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GuardHomeScreenState extends State<GuardHomeScreen> {
  late String guardId;
  late String guardName;
  int selectedIndex = -1;

  @override
  void initState() {
    super.initState();
    selectedIndex = -1;
  }

  void guardArguments() {
    final args = ModalRoute.of(context)?.settings.arguments as GuardArguments?;
    if (args != null) {
      guardId = args.guardId;
      guardName = args.guardName;
      print('Guard ID: $guardId');
      print('Guard Name: $guardName');
    }
  }

  final List<Map<String, dynamic>> tiles = [
    {
      'title': 'Scan QR',
      'icon': Icons.qr_code_scanner_rounded,
      'route': QRScanner.routeName,
    },
    {
      'title': 'Visitor Details',
      'icon': Icons.info_outline_rounded,
      'route': VisitorTimestamp.routeName,
    },
    {
      'title': 'Assign Parking',
      'icon': Icons.directions_car_filled_outlined,
      'route': ParkingMapTab.routeName,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    // Calculate the aspect ratio for grid containers
    double gridAspectRatio(double width) {
      if (width < 380) return 2.0; // Narrow screens
      if (width < 450) return 2.5; // Medium screens
      return 3.0; // Wide screens
    }

    // guardArguments();
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Loco Residence',
                      style: GlobalVariables.logInTitleStyle(
                        context,
                        color: GlobalVariables.primaryColor,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Popup(
                          title: 'Warning',
                          content: Text("Are you sure you want to log out"),
                          buttons: [
                            ButtonConfig(
                              text: 'Cancel',
                              onPressed: () async {},
                            ),
                            ButtonConfig(
                              text: 'Yes',
                              onPressed: () async {
                                Navigator.pop(
                                  context,
                                );
                              },
                            ),
                          ],
                        ).show(context);
                      },
                      child: Icon(
                        Icons.logout,
                        size: GlobalVariables.responsiveIconSize(context, 30),
                        color: GlobalVariables.primaryColor,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 60),
                Row(
                  children: [
                    Text('HOLA,', style: GlobalVariables.headingStyle(context)),
                    SizedBox(width: 15),
                    Text(
                      'guardName',
                      style: GlobalVariables.bold20(
                        context,
                        GlobalVariables.primaryGrey,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                GridView.count(
                  crossAxisCount: 1,
                  mainAxisSpacing: 15,
                  crossAxisSpacing: 15,
                  childAspectRatio: gridAspectRatio(screenWidth),
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: List.generate(
                    tiles.length,
                    (index) {
                      final tile = tiles[index];
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedIndex = index;
                          });

                          Navigator.pushNamed(
                            context,
                            tile['route'],
                            arguments: index == 2,
                          ).then((_) {
                            setState(() {
                              selectedIndex = -1;
                            });
                          });
                        },
                        child: homeTile(
                          context,
                          index,
                          tile['title'],
                          tile['icon'],
                          index == selectedIndex,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
