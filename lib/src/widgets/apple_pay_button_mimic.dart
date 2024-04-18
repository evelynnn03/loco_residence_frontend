import 'package:flutter/material.dart';

class ApplePayButtonMimic extends StatelessWidget {
  const ApplePayButtonMimic({super.key});

  void showErrorSnackbar(BuildContext context) {
    final snackBar = SnackBar(
      content: const Text(
        'Apple Pay currently not supported',
        style: TextStyle(color: Colors.white),
      ),
      action: SnackBarAction(
        label: 'OK',
        onPressed: () {
          // Do something when the user presses the action button
        },
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 0,
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(8.0),
      child: InkWell(
        onTap: () {
          showErrorSnackbar(context);
        },
        child: Container(
          height: 50,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0),
            color: Colors.black,
          ),
          child: Center(
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                      text: 'Pay with ',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 20,
                      )),
                  WidgetSpan(
                    child: Image.asset(
                      'image/apple_logo.png',
                      width: 22,
                    ),
                  ),
                  TextSpan(
                    text: ' Pay',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
