import 'package:sef_ass/admin/screens/admin_home_screen.dart';
import 'package:sef_ass/admin/screens/view_feedback_screen.dart';
import 'package:sef_ass/common/login_screen.dart';
import 'package:sef_ass/guard/screens/guard_home_screen.dart';
import 'package:sef_ass/resident/screens/facility_info_screen.dart';
import 'package:sef_ass/resident/screens/feedback_screen.dart';
import 'package:sef_ass/resident/screens/important_contact.dart';
import 'package:sef_ass/resident/screens/payment_screen.dart';
import 'package:sef_ass/resident/screens/reset_password_screen.dart';
import 'package:sef_ass/resident/screens/resident_home_screen.dart';
import 'package:sef_ass/resident/screens/service_contacts.dart';
import 'package:sef_ass/resident/widgets/bottom_nav_bar.dart';

import '../../guard/screens/parking_map_tab.dart';
import '../../guard/screens/visitor_map.dart';
import 'package:flutter/material.dart';
import '../../guard/screens/scan_qrcode_screen.dart';
import '../../resident/screens/visitor_register_screen.dart';
import 'admin/screens/guard_register_screen.dart';
import 'admin/screens/make_announcement_screen.dart';
import 'admin/screens/manage_acc_screen.dart';
import 'admin/screens/resident_register_screen.dart';
import 'guard/screens/visitor_timestamp.dart';
import 'resident/screens/analytics_screen.dart';

Route<dynamic> generateRoute(RouteSettings routeSettings) {
  switch (routeSettings.name) {
    case MakeAnnouncementScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => MakeAnnouncementScreen(),
      );
    case ManageAccountScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => ManageAccountScreen(),
      );

    case ResidentRegisterScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const ResidentRegisterScreen(),
      );

    case GuardRegisterScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const GuardRegisterScreen(),
      );

    case VisitorRegisterScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const VisitorRegisterScreen(),
      );

    case QRScanner.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const QRScanner(),
      );

    case VisitorTimestamp.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => VisitorTimestamp(),
      );

    case VisitorMap.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => VisitorMap(),
      );

    case ParkingMapTab.routeName:
      var arguments = routeSettings.arguments;

      // Check if arguments is a map
      if (arguments is Map<String, dynamic>) {
        var initialTabIndex = arguments['initialTabIndex'] as int?;
        var visitorId = arguments['visitorId'] as String?;

        return MaterialPageRoute(
          settings: routeSettings,
          builder: (_) => ParkingMapTab(
            initialTabIndex: initialTabIndex,
            visitorId: visitorId,
          ),
        );
      } else {
        return MaterialPageRoute(
          settings: routeSettings,
          builder: (_) => ParkingMapTab(
            initialTabIndex: null,
            visitorId: null,
          ),
        );
      }

    case ResetPassword.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => ResetPassword(),
      );
    case LoginScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => LoginScreen(),
      );

    case ResidentHomeScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => ResidentHomeScreen(),
      );

    case GuardHomeScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => GuardHomeScreen(),
      );

    case AdminHomeScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => AdminHomeScreen(),
      );

    case ServiceContactScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => ServiceContactScreen(),
      );

    case ImportantContactScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => ImportantContactScreen(),
      );

    case FeedbackScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => FeedbackScreen(),
      );

    case FacilityInfoScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => FacilityInfoScreen(),
      );

    case PaymentScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => PaymentScreen(),
      );

    case ViewFeedbackScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => ViewFeedbackScreen(),
      );

    case AnalyticsScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => AnalyticsScreen(),
      );
      
    case MyBottomNavBar.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => MyBottomNavBar(),
      );

    default:
      return MaterialPageRoute(
        builder: (_) => const Scaffold(
          body: Scaffold(
            body: Center(
              child: Text('Page Not Found'),
            ),
          ),
        ),
      );
  }
}

//if we needa pass arguments to the screen
    // case AddressScreen.routeName:
    //   var totalAmount = routeSettings.arguments as String;
    //   return MaterialPageRoute(
    //     settings: routeSettings,
    //     builder: (_) => AddressScreen(
    //       totalAmount: totalAmount,
    //     ),
    //   );
