import 'dart:typed_data';
import 'package:get/get.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:screenshot/screenshot.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../widgets/buttons.dart';
import '../../constants/global_variables.dart';
import '../../widgets/bottom_nav_bar.dart';

class QRCodeGenerator extends StatefulWidget {
  final String Function() generateNewQrData;
  const QRCodeGenerator({super.key, required this.generateNewQrData});

  @override
  State<QRCodeGenerator> createState() => _QRCodeGeneratorState();
}

class _QRCodeGeneratorState extends State<QRCodeGenerator> {
  final ScreenshotController screenshotController = ScreenshotController();

  @override
  Widget build(BuildContext context) {
    // Color backgroundColor = Theme.of(context).primaryColor;

    return Scaffold(
      backgroundColor: GlobalVariables.secondaryColor,
      appBar: AppBar(
        foregroundColor: GlobalVariables.primaryColor,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: GlobalVariables.primaryColor,
          ),
          onPressed: () {
            Navigator.pop(context); // Navigate back when back button is pressed
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.1),
            Screenshot(
              controller: screenshotController,
              child: Column(
                children: [
                  QrImageView(
                    data: widget.generateNewQrData(),
                    version: QrVersions.auto,
                    size: 200.0,
                    backgroundColor: Colors.transparent,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 70),
            Text(
              'Scan the QR code upon arrrival',
              style:
                  GlobalVariables.bold20(context, GlobalVariables.primaryColor),
            ),
            const SizedBox(height: 50),
            MyButton(
                onTap: () async {
                  await captureAndSaveQRCode();
                },
                text: 'Save QR Code'),
          ],
        ),
      ),
    );
  }

  Future<void> captureAndSaveQRCode() async {
    try {
      final Uint8List? uint8list = await screenshotController.capture();
      if (uint8list != null) {
        final PermissionStatus status = await Permission.storage.request();
        print('Permission status: $status');
        if (status.isGranted) {
          final result = await ImageGallerySaver.saveImage(uint8list);
          if (result['isSuccess']) {
            Get.snackbar('Success', 'Image saved to gallery');
            // Pop until you reach the home page (for now it is register page because havent do resident home page)
            Navigator.pushNamed(context, MyBottomNavBar.routeName);
          } else {
            Get.snackbar('Failed', 'Image failed to save ${result['error']}');
          }
        } else if (status.isDenied) {
          Get.snackbar('Permission Denied',
              'Please grant storage permission to save the image.');
        } else {
          // Handle other permission statuses if needed
          Get.snackbar('Permission Error',
              'An error occurred while requesting permission.');
        }
      }
    } catch (e) {
      print('Error capturing or saving QR code: $e');
      Get.snackbar('Error', 'An error occurred. Please try again.');
    }
  }
}
