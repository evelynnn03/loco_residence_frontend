import 'package:flutter/material.dart';
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

  @override
  void initState() {
    super.initState();
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

  @override
  Widget build(BuildContext context) {
    guardArguments();
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
                      style: TextStyle(
                        color: GlobalVariables.darkPurple,
                        fontSize: 20,
                        fontFamily: 'Anton',
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
                      Icons.logout_rounded,
                      size: 25, color: Colors.black,

                      //color: GlobalVariables.darkPurple
                    ),
                  ),
                  ],
                ),
                SizedBox(height: 60),
                Text(
                  'HOLA,',
                  style: TextStyle(
                    color: GlobalVariables.primaryGrey,
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '$guardName',
                  style: TextStyle(
                    color: GlobalVariables.primaryGrey,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, QRScanner.routeName);
                  },
                  child: HomepageTitle(
                    tileName: 'Scan QR',
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, VisitorTimestamp.routeName);
                  },
                  child: HomepageTitle(
                    tileName: 'Visitor\nDetails',
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, ParkingMapTab.routeName);
                  },
                  child: HomepageTitle(
                    tileName: 'Parking',
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
