import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import '../../guard/screens/parking_map_tab.dart';
import '../../src/constants/global_variables.dart';
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
  bool buildWidgets = false;
  Map<String, String> dataMap = {};
  String visitorId = ""; //visitor id brought from visitor_registor_screen

  //extract Data from the data string
  Map<String, String> extractData(String dataString) {
    //get every new lines
    List<String> lines = dataString.split('\n');
    Map<String, String> dataMap = {};

    for (String line in lines) {
      List<String> parts = line.split(':');

      if (parts.length == 2) {
        String key = parts[0].trim(); //take the value before the ':'
        String value = parts[1].trim(); //take the value after the ':'
        //put into the Map
        dataMap[key] = value;
      } else {
        print('Invalid line format: $line');
      }
    }
    visitorId =
        dataMap['_doc']!; //return the visitorId to visitor ID global variables
    // print('visitor id is: $visitorId');

    return dataMap;
  }

  // bool checkRegisteredDate(Map<String, String> dataMap) {
  //   String checkInDate = dataMap['Checked In Date'] ?? '';
  //   String currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
  //   print('CHECK IN DATEEEEEEEEEEEEEEEEEEE: ${checkInDate}');
  //   return checkInDate == currentDate;
  // }

  // POP UP WINDOW OF VISITOR'S DETAILS
  void _showDialog(String data) async {
    dataMap = extractData(data);
    try {
      if (!isDialogShown) {
        isDialogShown = true;

        Popup(
          title: 'Visitor Details',
          content: SizedBox(
            height: 200,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: 40,
                  child: Row(
                    children: [
                      SizedBox(
                        width: 125,
                        child: Text(
                          'Name',
                          style: TextStyle(
                              fontSize: 16,
                              color: GlobalVariables.primaryColor),
                        ),
                      ),
                      Center(
                        child: Text(
                          ': ',
                          style: TextStyle(
                              fontSize: 16,
                              color: GlobalVariables.primaryColor),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          dataMap['Name']!,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 16,
                              color: GlobalVariables.primaryColor),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 40,
                  child: Row(
                    children: [
                      SizedBox(
                        width: 125,
                        child: Text(
                          'Car Plate no',
                          style: TextStyle(
                              fontSize: 16,
                              color: GlobalVariables.primaryColor),
                        ),
                      ),
                      Center(
                        child: Text(
                          ': ',
                          style: TextStyle(
                              fontSize: 16,
                              color: GlobalVariables.primaryColor),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          dataMap['Car Plate No.']!,
                          style: TextStyle(
                              fontSize: 16,
                              color: GlobalVariables.primaryColor),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 40,
                  child: Row(
                    children: [
                      SizedBox(
                        width: 125,
                        child: Text(
                          'Check in Date',
                          style: TextStyle(
                              fontSize: 16,
                              color: GlobalVariables.primaryColor),
                        ),
                      ),
                      Center(
                        child: Text(
                          ': ',
                          style: TextStyle(
                              fontSize: 16,
                              color: GlobalVariables.primaryColor),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          dataMap['Checked In Date']!,
                          style: TextStyle(
                              fontSize: 16,
                              color: GlobalVariables.primaryColor),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 40,
                  child: Row(
                    children: [
                      SizedBox(
                        width: 125,
                        child: Text(
                          'H/P no',
                          style: TextStyle(
                              fontSize: 16,
                              color: GlobalVariables.primaryColor),
                        ),
                      ),
                      Center(
                        child: Text(
                          ': ',
                          style: TextStyle(
                              fontSize: 16,
                              color: GlobalVariables.primaryColor),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          dataMap['H/P No.']!,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 16,
                              color: GlobalVariables.primaryColor),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 40,
                  child: Row(
                    children: [
                      SizedBox(
                        width: 125,
                        child: Text(
                          'Unit no',
                          style: TextStyle(
                              fontSize: 16,
                              color: GlobalVariables.primaryColor),
                        ),
                      ),
                      Center(
                        child: Text(
                          ': ',
                          style: TextStyle(
                              fontSize: 16,
                              color: GlobalVariables.primaryColor),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          dataMap['Unit No.']!,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 16,
                              color: GlobalVariables.primaryColor),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          buttons: [
            ButtonConfig(
              text: 'Confirm',
              onPressed: () {
                isDialogShown = false;
                Navigator.pop(context);
              },
            ),
            ButtonConfig(
              text: 'Assign Parking',
              onPressed: () {
                isDialogShown = false;
                setState(() {
                  result = null;
                });

                // Check if the car plate number is empty before assigning parking
                if (dataMap['Car Plate No.'] != "") {
                  Navigator.popAndPushNamed(
                    context,
                    ParkingMapTab.routeName,
                    arguments: {
                      'initialTabIndex': 1,
                      'visitorId': visitorId,
                    },
                  );
                } else {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Center(
                          child: Text(
                            'Error',
                            style: TextStyle(
                                color: GlobalVariables.darkPurple,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        content: Text(
                          'Cannot assign parking.\nCar plate number is missing.',
                          style: TextStyle(color: GlobalVariables.primaryColor),
                        ),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                }
              },
            ),
          ],
        ).show(context);
      }
    } catch (e) {
      Popup(
        title: 'Error occured',
        content: Text("Error adding parking lot: $e"),
        buttons: [
          ButtonConfig(
            text: 'Confirm',
            onPressed: () async {
              Navigator.pop(context);
            },
          ),
        ],
      ).show(context);
    }
  }

  // LISTENER FOR SCANNED QR CODES, UPDATE THE STATE WITH SCANNED DATA AND SHOWS THE DIALOG
  void _onQRViewCreated(QRViewController controller) async {
    setState(() => this.controller = controller);
    try {
      controller.scannedDataStream.listen(
        (scanData) async {
          setState(() {
            result = scanData;
          });

          // Show the pop-up dialog when a scan occurs
          if (result != null) {
            String visitorDetails = result!.code ?? "No data found";

            dataMap = extractData(visitorDetails);
            String checkInDate = dataMap['Checked In Date'] ?? '';
            String currentDate =
                DateFormat('dd/MM/yyyy').format(DateTime.now());

            if (checkInDate == currentDate) {
              _showDialog(visitorDetails);

              //get the current time in 24format
              String currentTime = DateFormat('HH:mm').format(DateTime.now());
              final checkInCheckOut = <String, dynamic>{
                "Check-in Time": currentTime,
                "Check-out Time": null,
                "Check-out Date": null,
                "Parking Number": null,
              };

              await FirebaseFirestore.instance
                  .collection('Visitor')
                  .doc(visitorId)
                  .set(
                    checkInCheckOut,
                    //use merge to update only specified fields
                    SetOptions(merge: true),
                  );

              print('CHECK IN DATEEEEEEEEEEEEEEEEEEE: ${checkInDate}');
              print('CURRENT DATEEEEEEEEEEEEEEEEEEEE: ${currentDate}');
            } else {
              if (!isDialogShown) {
                isDialogShown = true;
                Popup(
                  title: 'Warning',
                  content: Text('The registered date is not today.'),
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
              print('CHECK IN DATEEEEEEEEEEEEEEEEEEE: ${checkInDate}');
              print('CURRENT DATEEEEEEEEEEEEEEEEEEEE: ${currentDate}');
            }
          }
        },
        onError: (error) {
          Popup(
            title: 'Error occured',
            content: Text("Error adding parking lot: $error"),
            buttons: [
              ButtonConfig(
                text: 'Confirm',
                onPressed: () async {
                  Navigator.pop(context);
                },
              ),
            ],
          ).show(context);
        },
      );
    } catch (e) {
      Popup(
        title: 'Error occured',
        content: Text("Error adding parking lot: $e"),
        buttons: [
          ButtonConfig(
            text: 'Confirm',
            onPressed: () async {
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
    } else if (Platform.isIOS) {
      controller!.resumeCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Scan a QR Code',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: GlobalVariables.primaryColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: GlobalVariables.backgroundColor,
          ),
          onPressed: () {
            Navigator.pop(context); // Navigate back when back button is pressed
          },
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
