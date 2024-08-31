import 'package:flutter/material.dart';
import 'package:loco_frontend/src/screens/resident_home_screen.dart';
import '../constants/global_variables.dart';
import '../screens/payment/payment_screen.dart';
import '../screens/settings/settings_screen.dart';
import '../screens/visitor/visitor_screen.dart';

class MyBottomNavBar extends StatefulWidget {
  const MyBottomNavBar({Key? key}) : super(key: key);

  static const String routeName = '/bottom_nav_bar';

  @override
  State<MyBottomNavBar> createState() => _MyBottomNavBarState();
}

class _MyBottomNavBarState extends State<MyBottomNavBar> {
  int _selectedIndex = 1;

  final List<Widget> _pages = const [
    VisitorScreen(),
    ResidentHomeScreen(),
    PaymentScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    // final mode = Provider.of<ThemeProvider>(context);
    final iconSize = GlobalVariables.responsiveIconSize(context, 30.0);

    return Scaffold(
      body: _pages[_selectedIndex],
      extendBody: true,
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          type: BottomNavigationBarType.fixed,
          backgroundColor: GlobalVariables.primaryColor,
          selectedItemColor: GlobalVariables.bottomNavSelectedIcons,
          unselectedItemColor: GlobalVariables.bottomNavIcons,
          selectedLabelStyle: GlobalVariables.selectedBottomNavStyle(context),
          unselectedFontSize: GlobalVariables.unselectedBottomNavStyle(context),
          iconSize: iconSize,
          items: const [
            BottomNavigationBarItem(
              icon: Padding(
                padding: EdgeInsets.only(top: 10.0),
                child: Icon(Icons.people),
              ),
              label: 'Visitor',
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: EdgeInsets.only(top: 10.0),
                child: Icon(Icons.home_outlined),
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: EdgeInsets.only(top: 10.0),
                child: Icon(Icons.payments),
              ),
              label: 'Payment',
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: EdgeInsets.only(top: 10.0),
                child: Icon(Icons.settings),
              ),
              label: 'Settings',
            ),
          ],
        ),
      ),
    );
  }
}
