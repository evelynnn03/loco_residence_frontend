import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:sef_ass/constants/global_variables.dart';

class IntroPage3 extends StatefulWidget {
  @override
  State<IntroPage3> createState() => _IntroPage3State();
}

class _IntroPage3State extends State<IntroPage3>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  @override
  void initState() {
    super.initState();

    _controller =
        AnimationController(duration: const Duration(seconds: 2), vsync: this);
    final Animation<double> animation =
        CurvedAnimation(parent: _controller, curve: Curves.easeInOutQuint);
    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool isClicked = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.network(
                'https://lottie.host/7a5fa5b3-db75-45ae-b3ad-28a253d24aa3/8Yu5rVrOje.json',
                controller: _controller),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Gym analytics: ',
                    style: TextStyle(
                      color: GlobalVariables.primaryColor,
                      fontFamily: 'Anton',
                      fontSize: 25,
                    ),
                  ),
                  Text(
                    'plan your workout with real-time occupancy tracking',
                    style: TextStyle(
                      color: GlobalVariables.primaryColor,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      color: GlobalVariables.backgroundColor,
    );
  }
}
