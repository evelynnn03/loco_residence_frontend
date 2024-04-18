import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../../src/constants/global_variables.dart';

class IntroPage2 extends StatefulWidget {
  @override
  State<IntroPage2> createState() => _IntroPage2State();
}

class _IntroPage2State extends State<IntroPage2>
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
                'https://lottie.host/8190a86c-9335-4b8c-8534-67dfc52602f7/pLkoovjAy6.json',
                controller: _controller),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 100,
                  ),
                  Text(
                    'Parking peace of mind: ',
                    style: TextStyle(
                      color: GlobalVariables.primaryColor,
                      fontFamily: 'Anton',
                      fontSize: 25,
                    ),
                  ),
                  Text(
                    'hassle-free, secure, and ready for you',
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
