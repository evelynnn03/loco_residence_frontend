import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../auth/login_screen.dart';
import '../../src/constants/global_variables.dart';
import 'intro_page1.dart';
import 'intro_page2.dart';
import 'intro_page3.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final _controller = PageController();
  bool onLastPage = false;
  int pageIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            //Called whenever the page in the center of the viewport changes.
            onPageChanged: (index) {
              //only when index 2 (third page), the bool will be true
              setState(() {
                onLastPage = (index == 2);
                pageIndex = index;
              });
            },
            controller: _controller,
            children: [
              IntroPage1(),
              IntroPage2(),
              IntroPage3(),
            ],
          ),
          Container(
            alignment: Alignment(0, 0.75),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                //skip
                GestureDetector(
                  onTap: () {
                    _controller.jumpToPage(2); //index 2 (third page)
                  },
                  child: const Text(
                    'skip',
                    style: TextStyle(
                        color: GlobalVariables.primaryColor,
                        fontWeight: FontWeight.w500),
                  ),
                ),

                //dot indicator
                SmoothPageIndicator(controller: _controller, count: 3),

                //next,
                onLastPage
                    ? GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, LoginScreen.routeName);
                        },
                        child: Text(
                          'done',
                          style: TextStyle(
                              color: GlobalVariables.primaryColor,
                              fontWeight: FontWeight.w500),
                        ),
                      )
                    : GestureDetector(
                        onTap: () {
                          _controller.nextPage(
                              duration: Duration(milliseconds: 250),
                              curve: Curves.easeIn);
                        },
                        child: Text(
                          'next',
                          style: TextStyle(
                              color: GlobalVariables.primaryColor,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
