import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'dart:io';
import '../../src/constants/global_variables.dart';
import '../../src/models/visitor.dart';
import '../../src/provider/visitor_provider.dart';
import '../widget/pop_up_window.dart';

class QRScanner extends StatefulWidget {
  static const String routeName = '/qr-scanner';
  const QRScanner({super.key});

  @override
  State<QRScanner> createState() => _QRScannerState();
}

class _QRScannerState extends State<QRScanner> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;
  bool isDialogShown = false;
  Set<int> scannedIds = {};

  // Function to extract visitor ID from QR code data
  int? extractVisitorId(String qrData) {
    try {
      // Split the QR data by newlines or commas
      final parts = qrData.split(RegExp(r'[,\n]'));

      // Find the part containing "Visitor ID:"
      final idPart = parts.firstWhere(
        (part) => part.trim().startsWith('Visitor ID:'),
        orElse: () => '',
      );

      if (idPart.isNotEmpty) {
        // Extract the numeric ID
        final idString = idPart.split(':')[1].trim();
        return int.parse(idString);
      }
      return null;
    } catch (e) {
      print('Error extracting visitor ID: $e');
      return null;
    }
  }

  // Show visitor details dialog
  Widget _buildDetailRow(String label, String value) {
    // Format the time if this is a date/time field
    String displayValue = value;
    if (label.toLowerCase().contains('time') ||
        label.toLowerCase().contains('date')) {
      try {
        final DateTime dateTime = DateTime.parse(value);
        if (label.toLowerCase().contains('time')) {
          // Format time as HH:mm:ss
          displayValue = DateFormat('HH:mm:ss').format(dateTime);
        } else {
          // Keep existing date format
          displayValue = value.split(' ')[0];
        }
      } catch (e) {
        // If parsing fails, use the original value
        print('Error formatting date/time: $e');
      }
    }

    return SizedBox(
      height: 40,
      child: Row(
        children: [
          SizedBox(
            width: 125,
            child: Text(
              label,
              style: TextStyle(
                fontSize: GlobalVariables.responsiveFontSize(context, 16),
                color: GlobalVariables.primaryColor,
              ),
            ),
          ),
          Center(
            child: Text(
              ': ',
              style: TextStyle(
                fontSize: GlobalVariables.responsiveFontSize(context, 16),
                color: GlobalVariables.primaryColor,
              ),
            ),
          ),
          Expanded(
            child: Text(
              displayValue,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: GlobalVariables.responsiveFontSize(context, 16),
                color: GlobalVariables.primaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Update the _showVisitorDetailsDialog to include check-in time if needed
  void _showVisitorDetailsDialog(BuildContext context, Visitor visitor) {
    final screenHeight = MediaQuery.of(context).size.height;

    if (!isDialogShown) {
      isDialogShown = true;

      final today = DateTime.now();
      final isToday = visitor.checkInDate.year == today.year &&
          visitor.checkInDate.month == today.month &&
          visitor.checkInDate.day == today.day;

      Popup(
        title: 'Visitor Details',
        content: SizedBox(
          height: screenHeight * 0.3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _buildDetailRow('Name', visitor.fullName),
              _buildDetailRow('Car Plate No', visitor.carPlateNo),
              _buildDetailRow('Check in Date',
                  visitor.checkInDate.toString().split(' ')[0]),
              if (visitor.checkInTime != null)
                _buildDetailRow(
                    'Check in Time', visitor.checkInTime.toString()),
              _buildDetailRow('H/P No', visitor.hpNumber),
              _buildDetailRow('Purpose', visitor.purpose),
            ],
          ),
        ),
        buttons: [
          if (isToday && visitor.checkInTime == null)
            ButtonConfig(
              text: 'Check-in visitor',
              onPressed: () async {
                try {
                  final visitorProvider =
                      Provider.of<VisitorProvider>(context, listen: false);

                  // Perform the check-in here
                  await visitorProvider.checkInVisitor(visitor.id);
                  scannedIds.add(visitor.id);

                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Visitor checked in successfully'),
                      backgroundColor: Colors.green,
                    ),
                  );
                } catch (e) {
                  _showErrorDialog('Error during check-in: $e');
                } finally {
                  isDialogShown = false;
                  controller?.resumeCamera();
                }
              },
            )
          else if (visitor.checkInTime != null)
            ButtonConfig(
              text: 'Already Checked In',
              onPressed: () {
                Navigator.pop(context);
                controller?.resumeCamera();
              },
            )
          else
            ButtonConfig(
              text: 'Unavailable',
              onPressed: () {
                Navigator.pop(context);
              },
            ),
        ],
      ).show(context);
    }
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() => this.controller = controller);

    controller.scannedDataStream.listen(
      (scanData) async {
        if (!isDialogShown && result?.code != scanData.code) {
          // Only process if not showing dialog and new QR code
          setState(() {
            result = scanData;
            print('Result: $result');
          });
          if (result != null && result!.code != null) {
            final visitorId = extractVisitorId(result!.code!);

            if (visitorId != null) {
              if (scannedIds.contains(visitorId)) {
                // QR code has already been used
                _showErrorDialog(
                    'This QR code has already been used for check-in');
                await Future.delayed(Duration(seconds: 2));
                controller.resumeCamera(); // Resume camera after error
                return;
              }

              final visitorProvider =
                  Provider.of<VisitorProvider>(context, listen: false);

              try {
                // Get visitor details but do not check them in yet
                final visitor = visitorProvider.getVisitorById(visitorId);

                if (visitor != null) {
                  if (visitor.checkInTime != null) {
                    // Visitor already checked in
                    _showErrorDialog('Visitor has already checked in');
                  } else {
                    _showVisitorDetailsDialog(context, visitor);
                  }
                } else {
                  _showErrorDialog('Visitor not found');
                  print('Visitor details: $visitor');
                }
              } catch (e) {
                _showErrorDialog('Error processing visitor: $e');
              }
            } else {
              _showErrorDialog('Invalid QR code format');
            }
          }
        }
      },
      onError: (error) async {
        _showErrorDialog('Error scanning QR code: $error');
        await Future.delayed(Duration(seconds: 2));
        controller.resumeCamera();
      },
    );
  }

  void _showErrorDialog(String message) {
    if (!isDialogShown) {
      isDialogShown = true;
      Popup(
        title: 'Error',
        content: Text(
          message,
          textAlign: TextAlign.center,
        ),
        buttons: [
          ButtonConfig(
            text: 'OK',
            onPressed: () {
              isDialogShown = false;
              Navigator.pop(context);
              controller?.resumeCamera();
            },
          ),
        ],
      ).show(context);
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  void reassemble() async {
    super.reassemble();
    if (Platform.isAndroid) {
      await controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  @override
  void initState() {
    super.initState();
    // Load visitors when screen initializes
    Provider.of<VisitorProvider>(context, listen: false)
        .fetchAllVisitors(userType: 'guard');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: GlobalVariables.primaryColor,
        title: Text(
          'Scan QR Code',
          style: GlobalVariables.appbarStyle(context,
              color: GlobalVariables.secondaryColor),
        ),
        leading: GlobalVariables.backButton(context,
            color: GlobalVariables.secondaryColor),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 5,
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
              overlay: QrScannerOverlayShape(
                borderColor: GlobalVariables.secondaryColor,
                borderRadius: 10,
                borderLength: 20,
                borderWidth: 10,
                cutOutSize: MediaQuery.of(context).size.width * 0.7,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
