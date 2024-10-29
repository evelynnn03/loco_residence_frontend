import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'dart:io';
import '../../guard/screens/parking_map_tab.dart';
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
                fontSize: 16,
                color: GlobalVariables.primaryColor,
              ),
            ),
          ),
          Center(
            child: Text(
              ': ',
              style: TextStyle(
                fontSize: 16,
                color: GlobalVariables.primaryColor,
              ),
            ),
          ),
          Expanded(
            child: Text(
              displayValue,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 16,
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
    if (!isDialogShown) {
      isDialogShown = true;

      Popup(
        title: 'Visitor Details',
        content: SizedBox(
          height:
              240, // Increased height to accommodate additional field if needed
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
          // ... rest of the button configuration remains the same
        ],
      ).show(context);
    }
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() => this.controller = controller);

    controller.scannedDataStream.listen(
      (scanData) async {
        setState(() {
          result = scanData;
        });

        if (result != null && result!.code != null) {
          final visitorId = extractVisitorId(result!.code!);

          if (visitorId != null) {
            final visitorProvider =
                Provider.of<VisitorProvider>(context, listen: false);

            try {
              // Check in the visitor
              await visitorProvider.checkInVisitor(visitorId);

              // Get updated visitor details
              final visitor = visitorProvider.getVisitorById(visitorId);

              if (visitor != null) {
                _showVisitorDetailsDialog(context, visitor);
              } else {
                _showErrorDialog('Visitor not found');
              }
            } catch (e) {
              _showErrorDialog('Error processing visitor: $e');
            }
          } else {
            _showErrorDialog('Invalid QR code format');
          }
        }
      },
      onError: (error) => _showErrorDialog('Error scanning QR code: $error'),
    );
  }

  void _showErrorDialog(String message) {
    if (!isDialogShown) {
      isDialogShown = true;
      Popup(
        title: 'Error',
        content: Text(message),
        buttons: [
          ButtonConfig(
            text: 'OK',
            onPressed: () {
              isDialogShown = false;
              Navigator.pop(context);
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Scan a QR Code',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: GlobalVariables.primaryColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: GlobalVariables.white,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 5,
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
              overlay: QrScannerOverlayShape(
                borderColor: Theme.of(context).primaryColor,
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
