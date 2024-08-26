import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../../src/constants/global_variables.dart';

class IntroPage1 extends StatefulWidget {
  @override
  State<IntroPage1> createState() => _IntroPage1State();
}

class _IntroPage1State extends State<IntroPage1>
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
    // TODO: implement dispose
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
              'https://lottie.host/e30d5b4a-1bc1-44ab-b41e-eddcd2f3b96e/gc71MCE0I7.json',
              controller: _controller,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Loco Residence:',
                    style: TextStyle(
                      color: GlobalVariables.primaryColor,
                      fontFamily: 'Anton',
                      fontSize: 25,
                    ),
                  ),
                  Text(
                    'Secure, guarded, and fully equipped for your comfort',
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
      color: GlobalVariables.white,
    );
  }
}
