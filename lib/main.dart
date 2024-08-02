import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loco_frontend/src/screens/resident_home_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'guard/provider/visitor_parking_provider.dart';
import 'src/provider/resident_details_provider.dart';
import 'src/provider/resident_parking_provider.dart';
import 'core/walk_through/welcome_screen.dart';
import 'src/widgets/bottom_nav_bar.dart';
import 'config/themes/light_dark.dart';
import 'config/themes/theme_provider.dart';
import 'config/router.dart';
import 'package:connectivity_wrapper/connectivity_wrapper.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences preferences = await SharedPreferences.getInstance();
  var email = preferences.getString('email');
  var residentId = preferences.getString('residentId');
  var unitNo = preferences.getString('unitNo');
  var outstandingAmount = preferences.getInt('outstandingAmount');

  // print('Email from SharedPreferences: $email');
  // print('Resident ID from SharedPreferences: $residentId');
  // print('Unit Number from SharedPreferences: $unitNo');
  // print('Outstanding Amount from SharedPreferences: $outstandingAmount');

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then(
    (value) => runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => VisitorDetailsProvider(),
          ),
          ChangeNotifierProvider(
            create: (context) => ThemeProvider(),
          ),
          ChangeNotifierProvider(
            create: (context) => ResidentDetailsProvider(),
          ),
          ChangeNotifierProvider(
            create: (context) => ResidentParkingDetailsProvider(),
          ),
        ],
        child: MyApp(
          email: email,
          residentId: residentId,
          unitNo: unitNo,
          outstandingAmount: outstandingAmount,
        ),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  final String? email;
  final String? residentId;
  final String? unitNo;
  final int? outstandingAmount;

  const MyApp(
      {super.key,
      this.email,
      this.residentId,
      this.unitNo,
      this.outstandingAmount});

  @override
  Widget build(BuildContext context) {
    final mode = Provider.of<ThemeProvider>(context);

    return ConnectivityAppWrapper(
      app: MaterialApp(
        builder: (buildContext, widget) {
          return ConnectivityWidgetWrapper(
            disableInteraction: true,
            height: 80,
            child: widget!,
          );
        },
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: 'Proxima Nova',
        ).copyWith(
          colorScheme: mode.isDark
              ? LightDark.darkTheme.colorScheme
              : LightDark.lightTheme.colorScheme,
        ),
        themeMode: ThemeMode.system,
        onGenerateRoute: (settings) => generateRoute(settings),
        home: MyBottomNavBar(),
        // email == null ? const WelcomeScreen() : MyBottomNavBar()
      ),
    );
  }
}
