import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:provider/provider.dart';
import 'package:sef_ass/resident/screens/payment_screen.dart';
import 'package:sef_ass/resident/screens/resident_home_screen.dart';
import 'package:sef_ass/resident/screens/visitor_register_screen.dart';
import 'package:sef_ass/resident/widgets/theme_provider.dart';
import '../../constants/global_variables.dart';
import '../screens/settings_screen.dart';

class MyBottomNavBar extends StatefulWidget {
  MyBottomNavBar({
    Key? key,
  }) : super(key: key);
  static const String routeName = '/bottom_nav_bar';

  @override
  State<MyBottomNavBar> createState() => _MyBottomNavBarState();
}

class _MyBottomNavBarState extends State<MyBottomNavBar> {
  int _selectedIndex = 1;

  List<Widget> pages = [
    const VisitorRegisterScreen(),
    const ResidentHomeScreen(),
    const PaymentScreen(),
    const SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    Color? backgroundColor =
        BottomNavigationBarTheme.of(context).backgroundColor;
    Color icon = Theme.of(context).canvasColor;
    Color tabColor = Theme.of(context).focusColor;
    final mode = Provider.of<ThemeProvider>(context);
    Color tabShadowColor = Color.fromRGBO(129, 101, 234, 1);
    return Scaffold(
      body: pages.elementAt(_selectedIndex),
      bottomNavigationBar: Container(
        color: backgroundColor,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          child: GNav(
            duration: mode.isDark
                ? Duration(milliseconds: 0)
                : Duration(milliseconds: 500),
            gap: 8,
            color: icon,
            activeColor: GlobalVariables.primaryColor,
            padding: EdgeInsets.all(16),
            tabBackgroundColor: tabColor,
            tabs: [
              GButton(
                shadow: _selectedIndex == 0 && mode.isDark
                    ? [
                        BoxShadow(
                          color: tabShadowColor,
                          offset: const Offset(
                            0.0,
                            0.0,
                          ),
                          blurRadius: 5.0,
                          spreadRadius: 1.0,
                        ), //BoxShadow
                        //BoxShadow
                      ]
                    : null,
                icon: Icons.people,
                iconActiveColor: Colors.white,
                text: 'Visitor',
                textColor: Colors.white,
              ),
              GButton(
                shadow: _selectedIndex == 1 && mode.isDark
                    ? [
                        BoxShadow(
                          color: tabShadowColor,
                          offset: const Offset(
                            0.0,
                            0.0,
                          ),
                          blurRadius: 5.0,
                          spreadRadius: 1.0,
                        ), //BoxShadow
                        //BoxShadow
                      ]
                    : null,
                icon: Icons.home_outlined,
                iconActiveColor: Colors.white,
                text: 'Home',
                textColor: Colors.white,
              ),
              GButton(
                shadow: _selectedIndex == 2 && mode.isDark
                    ? [
                        BoxShadow(
                          color: tabShadowColor,
                          offset: const Offset(
                            0.0,
                            0.0,
                          ),
                          blurRadius: 5.0,
                          spreadRadius: 1.0,
                        ), //BoxShadow
                        //BoxShadow
                      ]
                    : null,
                icon: Icons.payment_outlined,
                iconActiveColor: Colors.white,
                text: 'Payments',
                textColor: Colors.white,
              ),
              GButton(
                shadow: _selectedIndex == 3 && mode.isDark
                    ? [
                        BoxShadow(
                          color: tabShadowColor,
                          offset: const Offset(
                            0.0,
                            0.0,
                          ),
                          blurRadius: 5.0,
                          spreadRadius: 1.0,
                        ), //BoxShadow
                        //BoxShadow
                      ]
                    : null,
                icon: Icons.settings_outlined,
                iconActiveColor: Colors.white,
                text: 'Settings',
                textColor: Colors.white,
              ),
            ],
            selectedIndex: _selectedIndex,
            onTabChange: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
          ),
        ),
      ),
    );
  }
}
