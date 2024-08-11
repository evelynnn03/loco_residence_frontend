import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:loco_frontend/src/widgets/buttons.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/auth/login_screen.dart';
import 'package:flutter/material.dart';
import '../widgets/pop_up_window.dart';
import '../constants/global_variables.dart';
import '../widgets/resident_argument.dart';
import '../../config/themes/theme_provider.dart';
import 'analytics_screen/analytics_screen.dart';
import 'facility_info_screen.dart';
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
  ];

  // Show a bottom sheet for specification or description
  void _showBottomSheet(String title, String content, bool button) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.5,
          minChildSize: 0.3,
          maxChildSize: 0.8,
          builder: (BuildContext context, ScrollController scrollController) {
            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(20.0),
                ),
              ),
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    height: 5,
                    width: 40,
                    decoration: BoxDecoration(
                      color: GlobalVariables.secondaryColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      title,
                      style: TextStyle(
                        color: GlobalVariables.primaryColor,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      controller: scrollController,
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        content,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                  ),
                  button
                      ? Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: MyButton(
                            text: 'Submit a Rating',
                            onTap: () => Navigator.pop(context),
                          ),
                        )
                      : Container(),
                ],
              ),
            );
          },
        );
      },
    );
  }

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

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Hello, Resident!',
                          style: TextStyle(
                            color: GlobalVariables.primaryColor,
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Proxima Nova',
                          ),
                        ),
                        Text(
                          'Welcome to Loco Residence',
                          style: TextStyle(
                            color: GlobalVariables.welcomeColor,
                            fontSize: 15,
                            fontFamily: 'Proxima Nova',
                          ),
                        ),
                      ],
                    ),
                    Spacer(),
                    Align(
                      alignment: Alignment.topRight,
                      child: GestureDetector(
                        onTap: () {
                          _showBottomSheet('Notifications', 'content', false);
                          // Popup(
                          //   title: 'Notifications',
                          //   content: Text(
                          //     "Are you sure you want to log out",
                          //   ),
                          //   buttons: [
                          //     ButtonConfig(
                          //       text: 'Cancel',
                          //       onPressed: () async {},
                          //     ),
                          //     ButtonConfig(
                          //       text: 'Yes',
                          //       onPressed: () async {
                          //         clearUserData();
                          //         // Navigator.pop(context);
                          //       },
                          //     ),
                          //   ],
                          // ).show(context);
                        },
                        child: Icon(
                          Icons.notifications,
                          size: 30,
                          color: GlobalVariables.primaryColor,

                          //color: GlobalVariables.darkPurple
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 30,
                ),
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
                    style: TextStyle(
                      color: GlobalVariables.primaryColor,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
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
                SizedBox(height: 10),
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
                                          height: 180,
                                          fit: BoxFit.cover,
                                          errorWidget: (context, url, error) =>
                                              Icon(Icons.error),
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
                              autoPlayInterval: Duration(seconds: 5),

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
                              aspectRatio: 2.0,
                              enlargeCenterPage: false,
                              scrollPhysics: BouncingScrollPhysics(),
                              pageViewKey: PageStorageKey('carousel'),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              for (int i = 0;
                                  i < min(announcements.length, 3);
                                  i++)
                                Container(
                                  width: 6,
                                  height: 6,
                                  margin: EdgeInsets.symmetric(horizontal: 4.0),
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
                SizedBox(
                  height: 10,
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'Home',
                    style: TextStyle(
                      color: GlobalVariables.primaryColor,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 10),

                GridView.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 15,
                  crossAxisSpacing: 15,
                  childAspectRatio: 190 / 210,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
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
                            arguments: index == 3 ? args : null,
                          ).then((_) {
                            setState(() {
                              selectedIndex = -1;
                            });
                          });
                        },
                        child: _homeTile(
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
                SizedBox(height: 20),
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
  Color boxShadowColor = Color.fromARGB(255, 42, 188, 69);
  return Container(
    height: 210,
    width: 190,
    padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 15),
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
        SizedBox(width: 10),
        Icon(
          icon,
          color: isSelected ? Colors.white : GlobalVariables.primaryColor,
          size: 30,
        ),
        SizedBox(width: 15),
        Text(
          tileName,
          style: TextStyle(
            color: isSelected ? Colors.white : GlobalVariables.primaryColor,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ],
    ),
  );
}
