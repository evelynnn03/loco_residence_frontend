import 'package:flutter/material.dart';
import 'package:loco_frontend/src/widgets/announcement_list_view.dart';
import 'package:loco_frontend/src/widgets/home_tile.dart';
import 'package:provider/provider.dart';
import '../../src/provider/announcement_provider.dart';
import '../../src/widgets/pop_up_window.dart';
import '../../src/constants/global_variables.dart';
import '../widget/guard_arguments.dart';
import 'scan_qrcode_screen.dart';
import 'visitor_info.dart';

class GuardHomeScreen extends StatefulWidget {
  const GuardHomeScreen({super.key});
  static const String routeName = '/guard_home';

  @override
  State<GuardHomeScreen> createState() => _GuardHomeScreenState();
}

class _GuardHomeScreenState extends State<GuardHomeScreen> {
  late String guardId;
  late String guardName;
  int selectedIndex = -1;

  @override
  void initState() {
    super.initState();
    selectedIndex = -1;
    Provider.of<AnnouncementProvider>(context, listen: false)
        .fetchAnnouncements();
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
      'title': 'Visitor\nDetails',
      'icon': Icons.info_outline_rounded,
      'route': VisitorInfo.routeName,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final announcementProvider = Provider.of<AnnouncementProvider>(context);
    print(
        'Number of announcements: ${announcementProvider.announcements.length}');

    // Calculate the aspect ratio for grid containers
    double gridAspectRatio(double width) =>
        width < 380 ? 0.8 : (width < 450 ? 1.0 : 1.2);

    double smallSizedBoxHeight(height) => height < 600 ? 15 : 20;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
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
                        content: const Text("Are you sure you want to log out"),
                        buttons: [
                          ButtonConfig(
                            text: 'Cancel',
                            onPressed: () async {},
                          ),
                          ButtonConfig(
                            text: 'Log out',
                            onPressed: () async {
                              Navigator.pop(context);
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
              SizedBox(height: smallSizedBoxHeight(screenHeight)),
              Text(
                'Welcome, Doodell',
                style: GlobalVariables.appbarStyle(
                  context,
                  color: GlobalVariables.welcomeColor,
                ),
              ),
              SizedBox(height: smallSizedBoxHeight(screenHeight)),
              GridView.count(
                crossAxisCount: 2,
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
                          arguments: index == 1,
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
              SizedBox(height: smallSizedBoxHeight(screenHeight)),
              Text(
                'Announcements',
                style: GlobalVariables.bold20(
                  context,
                  GlobalVariables.welcomeColor,
                ),
              ),
              SizedBox(height: smallSizedBoxHeight(screenHeight)),
              buildAnnouncementListView(
                context: context,
                announcements: announcementProvider.announcements,
                backgroundColor: GlobalVariables.secondaryColor,
              )
            ],
          ),
        ),
      ),
    );
  }
}
