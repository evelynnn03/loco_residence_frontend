import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:sef_ass/common/pop_up_window.dart';
import 'package:sef_ass/resident/screens/facility_info_screen.dart';
import 'package:sef_ass/resident/screens/feedback_screen.dart';
import 'package:sef_ass/resident/screens/important_contact.dart';
import 'package:sef_ass/resident/screens/service_contacts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../common/login_screen.dart';
import 'package:flutter/material.dart';
import '../../constants/global_variables.dart';
import '../widgets/resident_argument.dart';
import '../widgets/theme_provider.dart';
import 'analytics_screen.dart';

class ResidentHomeScreen extends StatefulWidget {
  const ResidentHomeScreen({super.key});
  static const String routeName = '/resident_home';

  @override
  State<ResidentHomeScreen> createState() => _ResidentHomeScreenState();
}

class HomepageTitle extends StatelessWidget {
  final String tileName;

  HomepageTitle({
    super.key,
    required this.tileName,
  });

  @override
  Widget build(BuildContext context) {
    final mode = Provider.of<ThemeProvider>(context);
    Color boxShadowColor = Color.fromRGBO(130, 101, 234, 0.769);
    Color cardColor = Theme.of(context).cardColor;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: Container(
        height: 200,
        width: 400,
        padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 22),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: cardColor,
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
        child: Flex(
          direction: Axis.horizontal,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (tileName == 'Analytics')
              Row(
                children: [
                  Icon(
                    Icons.poll_outlined,
                    color: Colors.white,
                    size: 95,
                  ),
                  SizedBox(width: 10),
                  Text(
                    tileName,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 35,
                    ),
                  ),
                ],
              ),

            if (tileName == 'Facility\nInformation')
              Row(
                children: [
                  Icon(
                    Icons.run_circle_outlined,
                    color: Colors.white,
                    size: 95,
                  ),
                  SizedBox(width: 10),
                  Text(
                    tileName,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 35,
                    ),
                  ),
                ],
              ),

            //
            if (tileName == 'Service\nContact')
              Row(
                children: [
                  SizedBox(width: 10),
                  Icon(
                    Icons.contact_phone_outlined,
                    color: Colors.white,
                    size: 80,
                  ),
                  SizedBox(width: 20),
                  Text(
                    tileName,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 35,
                    ),
                  ),
                ],
              ),

            if (tileName == 'Submit\nFeedback')
              Row(
                children: [
                  SizedBox(width: 10),
                  Icon(
                    Icons.textsms_outlined,
                    color: Colors.white,
                    size: 90,
                  ),
                  SizedBox(width: 15),
                  Text(
                    tileName,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 35,
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

class _ResidentHomeScreenState extends State<ResidentHomeScreen> {
  late String residentId;
  late String unitNumber;

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
  }

  CarouselController carouselController = CarouselController();
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
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Loco Residence',
                        style: TextStyle(
                          color:
                              Theme.of(context).textTheme.bodyMedium?.color ??
                                  GlobalVariables.darkPurple,
                          fontSize: 20,
                          fontFamily: 'Anton',
                        ),
                      ),
                    ),
                    Spacer(),
                    Align(
                      alignment: Alignment.topRight,
                      child: GestureDetector(
                        onTap: () {
                          Popup(
                            title: 'Warning',
                            content: Text(
                              "Are you sure you want to log out",
                            ),
                            buttons: [
                              ButtonConfig(
                                text: 'Cancel',
                                onPressed: () async {},
                              ),
                              ButtonConfig(
                                text: 'Yes',
                                onPressed: () async {
                                  clearUserData();
                                  // Navigator.pop(context);
                                },
                              ),
                            ],
                          ).show(context);
                        },
                        child: Icon(
                          Icons.logout_rounded,
                          size: 25,
                          color:
                              Theme.of(context).textTheme.bodyMedium?.color ??
                                  GlobalVariables.darkPurple,

                          //color: GlobalVariables.darkPurple
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Align(
                    alignment: Alignment.topRight,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(
                            context, ImportantContactScreen.routeName);
                      },
                      child: Icon(
                        Icons.sos_outlined,
                        size: 50,
                        color: Colors.red,
                      ),
                    ),
                  ),
                ),
                Text(
                  'Announcements',
                  style: TextStyle(
                    color: Theme.of(context).textTheme.bodySmall?.color ??
                        GlobalVariables.primaryColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10),
                Text(
                  'Tap for more details',
                  style: TextStyle(
                    color: Theme.of(context).textTheme.bodyMedium?.color ??
                        GlobalVariables.darkPurple,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
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
                                          height: 150,
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
                                        ? GlobalVariables.secondaryColor
                                        : Theme.of(context).brightness ==
                                                Brightness.dark
                                            ? GlobalVariables.darkPurple
                                            : GlobalVariables.analyticsBarColor,
                                  ),
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
                Text(
                  'Home',
                  style: TextStyle(
                    color: Theme.of(context).textTheme.bodySmall?.color ??
                        GlobalVariables.primaryColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, AnalyticsScreen.routeName);
                    },
                    child: HomepageTitle(tileName: 'Analytics')),
                GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(
                          context, FacilityInfoScreen.routeName);
                    },
                    child: HomepageTitle(tileName: 'Facility\nInformation')),
                GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(
                          context, ServiceContactScreen.routeName);
                    },
                    child: HomepageTitle(tileName: 'Service\nContact')),
                GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        FeedbackScreen.routeName,
                        arguments: args,
                      );
                    },
                    child: HomepageTitle(tileName: 'Submit\nFeedback'))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
