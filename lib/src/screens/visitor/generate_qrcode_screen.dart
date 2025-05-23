import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:loco_frontend/src/widgets/bottom_nav_bar.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:screenshot/screenshot.dart';
import '../../constants/global_variables.dart';
import '../../widgets/buttons.dart';

class QRCodeGenerator extends StatefulWidget {
  final String Function() generateNewQrData;
  final Map<String, String> visitorData; // Accept visitor data in constructor

  const QRCodeGenerator({
    super.key,
    required this.generateNewQrData,
    required this.visitorData, // Accept visitor data in constructor
  });

  @override
  State<QRCodeGenerator> createState() => _QRCodeGeneratorState();
}

class _QRCodeGeneratorState extends State<QRCodeGenerator> {
  final ScreenshotController screenshotController = ScreenshotController();
  double bigSizedBoxHeight(double height) => height < 600 ? 60 : 70;
  double smallSizedBoxHeight(double height) => height < 600 ? 40 : 50;

  @override
  Widget build(BuildContext context) {
    // Generate QR data using the visitor's info
    // Get the visitor id from provider
    String qrData = 'Visitor ID: ${widget.visitorData['id']}, '
        'Full Name: ${widget.visitorData['fullName']}, '
        'HP Number: ${widget.visitorData['hpNumber']}, '
        'Car Plate: ${widget.visitorData['carPlateNo']}, '
        'Check-In Date: ${widget.visitorData['checkInDate']}, '
        'Purpose: ${widget.visitorData['purpose']}';

    print('QR data: $qrData');

    final screenHeight = MediaQuery.of(context).size.height;

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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.1),
              Screenshot(
                controller: screenshotController,
                child: Column(
                  children: [
                    QrImageView(
                      data: qrData, // Pass the dynamically generated data
                      version: QrVersions.auto,
                      size: screenHeight * 0.25,
                      backgroundColor: GlobalVariables.secondaryColor,
                    ),
                  ],
                ),
              ),
              SizedBox(height: bigSizedBoxHeight(screenHeight)),
              Text(
                'Scan the QR code upon arrival',
                style: GlobalVariables.bold20(
                    context, GlobalVariables.primaryColor),
              ),
              SizedBox(height: smallSizedBoxHeight(screenHeight)),
              MyButton(
                onTap: () async {
                  await captureAndSaveQRCode();
                },
                text: 'Save QR Code',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> captureAndSaveQRCode() async {
    try {
      final Uint8List? uint8list =
          await screenshotController.capture(); // Capture QR Code as image
      if (uint8list != null) {
        final PermissionStatus status = await Permission.storage.request();
        if (status.isGranted) {
          final result = await ImageGallerySaver.saveImage(uint8list);
          if (result['isSuccess']) {
            print('QR saved successfully');
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('QR code saved to gallery'),
                backgroundColor: Colors.green,
                duration: Duration(seconds: 2),
              ),
            );
          } else {
            print('Error saving QR Code: ${result['error']}');
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Error saving QR Code, take a screenshot!'),
                backgroundColor: Colors.red,
                duration: Duration(seconds: 2),
              ),
            );
          }
        } else {
          print('Permission to access storage denied');
        }

        // Navigate to the next screen if needed
        Navigator.pushNamed(context, MyBottomNavBar.routeName);
      }
    } catch (e) {
      print('Error capturing or saving QR code: $e');
      Get.snackbar('Error', 'An error occurred. Please try again.');
    }
  }
}
