import 'package:loco_frontend/src/screens/payment/card_details.dart';
import 'package:loco_frontend/src/screens/payment/payment_details.dart';

import '../../../guard/screens/parking_map_tab.dart';
import '../../../guard/screens/visitor_map.dart';
import 'package:flutter/material.dart';
import '../../../guard/screens/scan_qrcode_screen.dart';
import '../src/screens/visitor/visitor_register_screen.dart';
import '../core/auth/login_screen.dart';
import '../guard/screens/guard_home_screen.dart';
import '../guard/screens/visitor_timestamp.dart';
import '../src/screens/analytics_screen/analytics_screen.dart';
import '../src/screens/facility_info_screen.dart';
import '../src/screens/feedback_screen/feedback_screen.dart';
import '../src/screens/important_contact.dart';
import '../src/screens/payment/payment_screen.dart';
import '../src/screens/settings/reset_password_screen.dart';
import '../src/screens/resident_home_screen.dart';
import '../src/screens/service_contacts.dart';
import '../src/widgets/bottom_nav_bar.dart';

Route<dynamic> generateRoute(RouteSettings routeSettings) {
  switch (routeSettings.name) {
    case VisitorScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const VisitorScreen(),
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

    case PaymentDetails.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => PaymentDetails(),
      );

    case CardDetails.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => CardDetails(),
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
