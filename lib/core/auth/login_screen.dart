import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:shared_preferences/shared_preferences.dart';
import '../../src/constants/global_variables.dart';
import '../../guard/screens/guard_home_screen.dart';
import '../../guard/widget/guard_arguments.dart';
import '../../src/provider/resident_details_provider.dart';
import '../../src/screens/reset_password_screen.dart';
import '../../src/widgets/bottom_nav_bar.dart';
import '../../src/widgets/resident_argument.dart';
import '../../config/themes/theme_provider.dart';
import '../../src/widgets/buttons.dart';
import '../../src/widgets/pop_up_window.dart';
import '../../src/widgets/text_field.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName = '/login-screen';
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailTextController = TextEditingController();
  final passwordTextController = TextEditingController();
  bool obscurePassword = true;
  bool checkBox = false;
  String guardName = '';

  void saveEmail(String email, String? residentId, String unitNo,
      int outstandingAmount) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString('email', email);
    preferences.setString('residentId', residentId ?? '');
    preferences.setString('unitNo', unitNo);
    preferences.setInt('outstandingAmount', outstandingAmount);

    print('EMAILLLLLLLLLLLLLLLL: $email');
    print('IDDDDDDDDDDDDDDDDDDD: $residentId');
    print('UNIT NOOOOOOOOOOOOOO: $unitNo');
    print('OUSTANDING AMOUNTTTT: $outstandingAmount');
  }

  void homeScreenDisplayed() async {
    final email = emailTextController.text.trim();
    final password = passwordTextController.text.trim();
    //print('Email: $email, Password: $password');

    if (email.isEmpty || password.isEmpty) {
      Popup(
          title: 'Enter your credentials',
          content: Text("Please enter an email or password."),
          buttons: [ButtonConfig(text: 'OK', onPressed: () {})]).show(context);
    } else if (!checkBox) {
      Popup(
        title: 'Terms and Condition',
        content:
            Text("Please accept the terms and condition before logging in."),
        buttons: [
          ButtonConfig(
            text: 'OK',
            onPressed: () {},
          ),
        ],
      ).show(context);
    }

    try {
      // Query the Resident collection
      QuerySnapshot residentQuery = await FirebaseFirestore.instance
          .collection('Resident')
          .where('Resident Email', isEqualTo: email)
          .where('Resident Password', isEqualTo: password)
          .limit(
              1) // if multiple of the same data encountered, only get the first one
          .get();

      // Query the Guard collection
      QuerySnapshot guardQuery = await FirebaseFirestore.instance
          .collection('Guard')
          .where('Guard Email', isEqualTo: email)
          .where('Guard Password', isEqualTo: password)
          .limit(1)
          .get();

      // Query the Admin collection
      QuerySnapshot adminQuery = await FirebaseFirestore.instance
          .collection('Admin')
          .where('Admin Email', isEqualTo: email)
          .where('Admin Password', isEqualTo: password)
          .limit(1)
          .get();

      if (checkBox) {
        if (residentQuery.docs.isNotEmpty) {
          String residentId = residentQuery.docs.first.id;
          String residentUnitNo = residentQuery.docs.first['Unit No'];
          int outstandingAmount =
              residentQuery.docs.first['Outstanding Amount (RM)'];
          Map<String, Object> details = {
            'residentId': residentId,
            'Unit No': residentUnitNo,
          };
          saveEmail(email, residentId, residentUnitNo, outstandingAmount);
          Provider.of<ResidentDetailsProvider>(context, listen: false)
              .setResidentDetails(details);

          Navigator.pushNamed(context, MyBottomNavBar.routeName,
              arguments: ResidentArgument(
                  residentId: residentId, residentUnitNo: residentUnitNo));
        } else if (guardQuery.docs.isNotEmpty) {
          String guardId = guardQuery.docs.first.id;
          String guardName = guardQuery.docs.first['Guard Name'];

          Navigator.pushNamed(
            context,
            GuardHomeScreen.routeName,
            arguments: GuardArguments(guardId: guardId, guardName: guardName),
          );
        } else if (adminQuery.docs.isNotEmpty) {
          // String adminId = adminQuery.docs.first.id;
          // String adminName = adminQuery.docs.first['Admin Name'];

          // Navigator.pushNamed(
          //   context,
          //   AdminHomeScreen.routeName,
          //   arguments: AdminArguments(adminId: adminId, adminName: adminName),
          // );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Invalid User'),
              duration: Duration(seconds: 2),
            ),
          );
        }
      }
      emailTextController.clear();
      passwordTextController.clear();
    } catch (e) {
      print('Login error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final mode = Provider.of<ThemeProvider>(context).isDark;
    print(mode);
    return Scaffold(
      backgroundColor: GlobalVariables.primaryColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Column(
              //mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 100),
                const Text(
                  "Welcome to",
                  style: TextStyle(
                      color: GlobalVariables.darkPurple,
                      fontSize: 32,
                      fontFamily: 'Anton'),
                ),
                const Text(
                  "Loco Residence",
                  style: TextStyle(
                      color: GlobalVariables.backgroundColor,
                      fontSize: 32,
                      fontFamily: 'Anton'),
                ),
                const SizedBox(height: 1),
                const Text(
                  "Login your account",
                  style: TextStyle(color: Colors.white24, fontSize: 16),
                ),
                const SizedBox(height: 40),
                MyTextField(
                  controller: emailTextController,
                  hintText: 'Email',
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: Icons.email,
                ),
                const SizedBox(height: 20),
                MyTextField(
                  controller: passwordTextController,
                  hintText: 'Password',
                  obscureText: obscurePassword,
                  keyboardType: TextInputType.visiblePassword,
                  prefixIcon: Icons.lock,
                  suffixIcon: Icons.visibility,
                  onTap: () {
                    setState(() {
                      obscurePassword = !obscurePassword;
                    });
                  },
                  maxLines: obscurePassword ? 1 : null,
                ),
                const SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pushNamed(
                            context, ResetPassword.routeName),
                        child: const Text(
                          "Forgot password?",
                          style: TextStyle(
                            color: GlobalVariables.backgroundColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                MyButton(onTap: homeScreenDisplayed, text: 'Log In'),
                const SizedBox(height: 230),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Checkbox(
                        value: checkBox,
                        onChanged: (bool? value) {
                          setState(() {
                            checkBox = !checkBox;
                          });
                        },
                      ),
                      const Text(
                        "I have read and accepted the terms and conditions",
                        style: TextStyle(
                          color: GlobalVariables.backgroundColor,
                          fontSize: 10,
                        ),
                      ),
                    ],
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
