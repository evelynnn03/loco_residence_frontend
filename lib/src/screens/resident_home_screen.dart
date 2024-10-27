import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:loco_frontend/src/widgets/bottom_sheet.dart';
import 'package:loco_frontend/src/widgets/home_tile.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/auth/login_screen.dart';
import 'package:flutter/material.dart';
import '../widgets/pop_up_window.dart';
import '../constants/global_variables.dart';
import '../widgets/resident_argument.dart';
import '../../config/themes/theme_provider.dart';
import 'analytics_screen/analytics_screen.dart';
import 'facility/facility_info_screen.dart';
import 'facility/view_bookings_screen.dart';
import 'feedback_screen.dart';
import 'important_contact.dart';
import 'service_contacts.dart';

class ResidentHomeScreen extends StatefulWidget {
  const ResidentHomeScreen({super.key});
  static const String routeName = '/resident_home';

  @override
  State<ResidentHomeScreen> createState() => _ResidentHomeScreenState();
}

class _ResidentHomeScreenState extends State<ResidentHomeScreen> {
  late String residentId;
  late String unitNumber;
  bool isSelected = false;
  int selectedIndex = -1;

  final List<Map<String, dynamic>> tiles = [
    {
      'title': 'Book\nFacility',
      'icon': Icons.calendar_month_rounded,
      'route': FacilityInfoScreen.routeName,
    },
    {
      'title': 'Submit\nFeedback',
      'icon': Icons.feedback_outlined,
      'route': FeedbackScreen.routeName,
    },
    {
      'title': 'View Data\nCharts',
      'icon': Icons.analytics_outlined,
      'route': AnalyticsScreen.routeName,
    },
    {
      'title': 'View\nServices',
      'icon': Icons.phone_in_talk_outlined,
      'route': ServiceContactScreen.routeName,
    },
    {
      'title': 'Important\nContacts',
      'icon': Icons.sos_outlined,
      'route': ImportantContactScreen.routeName,
    },
    {
      'title': 'Notifications',
      'icon': Icons.notifications_outlined,
    },
    {
      'title': 'View\nBookings',
      'icon': Icons.event_available_rounded,
      'route': ViewBookingsScreen.routeName,
    },
  ];

  // Function to retrieve user details from SharedPreferences
  Future<void> _retrieveUserDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    residentId = prefs.getString('residentId') ?? '';
    unitNumber = prefs.getString('unitNo') ?? '';
  }

  @override
  void initState() {
    super.initState();
    _retrieveUserDetails();
    selectedIndex = -1;
  }

  CarouselSliderController carouselController = CarouselSliderController();
  int currentIndex = 0;
  void clearUserData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.remove('email');
    final mode = Provider.of<ThemeProvider>(context, listen: false);
    if (mode.isDark) {
      mode.changeTheme();
    }
    Navigator.pushNamed(context, LoginScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    ResidentArgument? args =
        ModalRoute.of(context)?.settings.arguments as ResidentArgument?;

    final screenWidth = MediaQuery.of(context).size.width;

    // Calculate the aspect ratio for grid containers
    double gridAspectRatio(double width) {
      if (width < 380) return 0.8; // Narrow screens
      if (width < 450) return 1.0; // Medium screens
      return 1.2; // Wide screens
    }

    // Calculate the aspect ratio for announcements
    double announcementAspectRatio(double width) {
      if (width < 380) return 1.9; // Narrow screens
      if (width < 450) return 1.7; // Medium screens
      return 1.5; // Wide screens
    }

    // Define dot sizes based on screen width
    double getDotSize(double width) {
      if (width < 380) return 4; // Narrow screens
      if (width < 450) return 6; // Medium screens
      return 8; // Wide screens
    }

    // Define dot sizes based on screen width
    double imageSize(double width) {
      if (width < 380) return 150; // Narrow screens
      if (width < 450) return 180; // Medium screens
      return 200; // Wide screens
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Hello, Resident!',
                          style: GlobalVariables.headingStyle(context),
                        ),
                        Text(
                          'Welcome to Loco Residence',
                          style: GlobalVariables.welcomeStyle(context),
                        ),
                      ],
                    ),
                    // const Spacer(),
                    // Align(
                    //   alignment: Alignment.topRight,
                    //   child: GestureDetector(
                    //     onTap: () {
                    //       _showBottomSheet('Notifications', 'content', false);
                    //       // Popup(
                    //       //   title: 'Notifications',
                    //       //   content: Text(
                    //       //     "Are you sure you want to log out",
                    //       //   ),
                    //       //   buttons: [
                    //       //     ButtonConfig(
                    //       //       text: 'Cancel',
                    //       //       onPressed: () async {},
                    //       //     ),
                    //       //     ButtonConfig(
                    //       //       text: 'Yes',
                    //       //       onPressed: () async {
                    //       //         clearUserData();
                    //       //         // Navigator.pop(context);
                    //       //       },
                    //       //     ),
                    //       //   ],
                    //       // ).show(context);
                    //     },
                    //     child: Icon(
                    //       Icons.notifications,
                    //       size: iconSize,
                    //       color: GlobalVariables.primaryColor,

                    //       //color: GlobalVariables.darkPurple
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
                const SizedBox(height: 30),
                // Padding(
                //   padding: const EdgeInsets.all(12.0),
                //   child: Align(
                //     alignment: Alignment.topRight,
                //     child: GestureDetector(
                //       onTap: () {
                //         Navigator.pushNamed(
                //             context, ImportantContactScreen.routeName);
                //       },
                //       child: Icon(
                //         Icons.sos_outlined,
                //         size: 50,
                //         color: Colors.red,
                //       ),
                //     ),
                //   ),
                // ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'Announcements',
                    style: GlobalVariables.bold20(
                        context, GlobalVariables.primaryColor),
                  ),
                ),
                // SizedBox(height: 10),
                // Text(
                //   'Tap for more details',
                //   style: TextStyle(
                //     color: Theme.of(context).textTheme.bodyMedium?.color ??
                //         GlobalVariables.darkPurple,
                //     fontSize: 13,
                //     fontWeight: FontWeight.bold,
                //   ),
                // ),
                const SizedBox(height: 10),
                StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('Announcement')
                      .orderBy('Timestamp', descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    // if (snapshot.connectionState == ConnectionState.waiting) {
                    //   return CircularProgressIndicator();
                    // }

                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    }

                    final announcements = snapshot.data?.docs ?? [];

                    return SingleChildScrollView(
                      child: Column(
                        children: [
                          CarouselSlider.builder(
                            carouselController: carouselController,
                            // itemCount: announcements.length,
                            itemCount: min(announcements.length, 3),
                            itemBuilder: (context, index, realIndex) {
                              final details = announcements[index]['Details'];
                              final imageUrl =
                                  announcements[index]['Image URL'];

                              Future<void> showDetails() async {
                                await Popup(
                                  title: 'Announcement Details',
                                  content: Text(details ?? ''),
                                  buttons: [
                                    ButtonConfig(
                                      text: 'OK',
                                      onPressed: () {},
                                    ),
                                  ],
                                ).show(context);
                              }

                              return GestureDetector(
                                onTap: showDetails,
                                child: Column(
                                  children: [
                                    if (imageUrl != null)
                                      ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        child: CachedNetworkImage(
                                          imageUrl: imageUrl,
                                          width: double.infinity,
                                          height: imageSize(screenWidth),
                                          fit: BoxFit.cover,
                                          errorWidget: (context, url, error) =>
                                              const Icon(Icons.error),
                                        ),
                                      ),
                                  ],
                                ),
                              );
                            },
                            options: CarouselOptions(
                              enableInfiniteScroll:
                                  false, // Disable the auto infinite scroll when theres ontly 1 image
                              viewportFraction: 1,
                              autoPlay: true,
                              autoPlayInterval: const Duration(seconds: 5),

                              onPageChanged: (index, reason) {
                                if (reason ==
                                    CarouselPageChangedReason.manual) {
                                  carouselController.stopAutoPlay();
                                }
                                setState(() {
                                  currentIndex = index;
                                });
                              },
                              pauseAutoPlayOnTouch: true,
                              aspectRatio: announcementAspectRatio(screenWidth),
                              enlargeCenterPage: false,
                              scrollPhysics: const BouncingScrollPhysics(),
                              pageViewKey: const PageStorageKey('carousel'),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              for (int i = 0;
                                  i < min(announcements.length, 3);
                                  i++)
                                Container(
                                  width: getDotSize(screenWidth),
                                  height: getDotSize(screenWidth),
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 4.0),
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: currentIndex == i
                                          ? GlobalVariables.welcomeColor
                                          : GlobalVariables.secondaryColor),
                                ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'Home',
                    style: GlobalVariables.bold20(
                        context, GlobalVariables.primaryColor),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 10),

                // 6 containers below 'Home'
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
                          if (index == 5) {
                            showBottomSheetModal(
                              context,
                              'Notification',
                              'This is the content of the notification.',
                              false,
                            ).then((_) {
                              setState(() {
                                selectedIndex = -1;
                              });
                            });
                          } else {
                            Navigator.pushNamed(
                              context,
                              tile['route'],
                              arguments: index == 5 ? args : null,
                            ).then((_) {
                              setState(() {
                                selectedIndex = -1;
                              });
                            });
                          }
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

Widget _homeTile(BuildContext context, int index, String tileName,
    IconData icon, bool isSelected) {
  final mode = Provider.of<ThemeProvider>(context);
  Color boxShadowColor = const Color.fromARGB(255, 42, 188, 69);

  return Container(
    width: double.infinity,
    padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 1),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(20),
      color: isSelected
          ? GlobalVariables.primaryColor
          : GlobalVariables.secondaryColor,
      boxShadow: mode.isDark
          ? [
              BoxShadow(
                color: boxShadowColor,
                offset: const Offset(
                  0.0,
                  0.0,
                ),
                blurRadius: 8.0,
                spreadRadius: 0.0,
              ), //BoxShadow
              //BoxShadow
            ]
          : null,
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(width: 10),
        Icon(
          icon,
          color: isSelected ? Colors.white : GlobalVariables.primaryColor,
          size: GlobalVariables.responsiveIconSize(context, 30.0),
        ),
        const SizedBox(width: 15),
        Text(tileName,
            style: GlobalVariables.bold20(
              context,
              isSelected ? Colors.white : GlobalVariables.primaryColor,
            )),
      ],
    ),
  );
}
