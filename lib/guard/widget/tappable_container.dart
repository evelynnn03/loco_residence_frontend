// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import '../../guard/provider/visitor_parking_provider.dart';
import '../../guard/widget/pop_up_window.dart';
import '../../constants/global_variables.dart';
import '../../resident/provider/resident_parking_provider.dart';

class TappableContainer extends StatefulWidget {
  const TappableContainer({
    super.key,
    required this.parkingLotName,
    required this.colorMap,
    required this.userType,
    this.visitorId,
    this.onContainerTapped,
  }) : assert(userType == 'Resident' || userType == 'Visitor');
  //user type can only be Resident or Visitor

  final String parkingLotName;
  final String userType;
  final Map<String, Color> colorMap;
  final String? visitorId;
  final VoidCallback? onContainerTapped;

  @override
  State<TappableContainer> createState() => _TappableContainerState();
}

class _TappableContainerState extends State<TappableContainer> {
  Map<String, Object> visitorDetails = {};

  Future<bool> addParkingLot(String visitorId) async {
    try {
      //check for existing data
      final existingDocSnapshot = await FirebaseFirestore.instance
          .collection('Visitor')
          .doc(visitorId)
          .get();

      if (existingDocSnapshot.exists) {
        if (existingDocSnapshot.data()?["Parking Number"] != null) {
          throw Exception("Parking already assigned for this user!!");
        }
      }

      final parkingNoMap = {"Parking Number": widget.parkingLotName};
      await FirebaseFirestore.instance.collection('Visitor').doc(visitorId).set(
            parkingNoMap,
            // Use merge to update only specified fields
            SetOptions(merge: true),
          );

//add to the provider whenever new parking has assigned
//retrive again updated doc
      final docSnapshotWithParkingLot = await FirebaseFirestore.instance
          .collection('Visitor')
          .doc(visitorId)
          .get();
      Map<String, dynamic> data =
          docSnapshotWithParkingLot.data() as Map<String, dynamic>;
      print('data $data');
      visitorDetails = {
        'visitorId': visitorId,
        'Full Name': data['Full Name'] ?? '',
        'Car Plate': data['Car Plate'] ?? '',
        'Check-in Time': data['Check-in Time'] ?? '',
        'Check-in Date': data['Check-in Date'] ?? '',
        'Phone Number': data['Phone Number'] ?? '',
        "Unit No": data['Unit No'] ?? '',
        'Parking Number': data['Parking Number'] ?? '',
      };

      //everytime add a new visitor parking, save it into visitorProvider
      final visitorDetailsList =
          Provider.of<VisitorDetailsProvider>(context, listen: false);
      visitorDetailsList.addVisitorDetails(visitorDetails);
      setState(() {});
      return true; // Operation was successful
    } catch (e) {
      Navigator.pop(context);
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
      return false; // Operation failed
    }
  }

  bool confirmParking = false;
  @override
  Widget build(BuildContext context) {
    final visitorDetailFromProvider =
        Provider.of<VisitorDetailsProvider>(context, listen: false)
            .returnVisitorDetailsBasedOnParkingLot(widget.parkingLotName);
    final residentDetailFromProvider =
        Provider.of<ResidentParkingDetailsProvider>(context, listen: false)
            .returnResidentParkingDetailsBasedOnUnitNo(widget.parkingLotName);

    // print(widget.parkingLotName);
    // print(visitorDetailFromProvider);
    return GestureDetector(
      onTap: () {
        //if there is visitor id provided in the screen, let them guard assign parking lot
        if (widget.visitorId != null &&
            widget.colorMap[widget.parkingLotName] == const Color(0xFFF2F2F2)) {
          Popup(
            title: 'Confirmation',
            content:
                Text('Are you sure you want the select this parking slot??? '),
            buttons: [
              ButtonConfig(
                text: 'Confirm',
                onPressed: () async {
                  // Your logic when Confirm button is presssed
                  try {
                    //if successfully added the parking lot into database, then only update our tappableContainer color
                    bool addParkingSuccess =
                        await addParkingLot(widget.visitorId!);
                    if (addParkingSuccess) {
                      confirmParking = true;
                      Navigator.pop(context);
                      if (confirmParking == true) {
                        setState(
                          () {
                            widget.colorMap[widget.parkingLotName] =
                                GlobalVariables.primaryColor;
                            confirmParking = !confirmParking;
                          },
                        );
                      }
                    } else {
                      //TODO add something here
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
                },
              ),
              ButtonConfig(
                text: 'Cancel',
                onPressed: () {
                  // Your logic when Assign Parking button is pressed
                  Navigator.pop(context);
                },
              ),
            ],
          ).show(context);
        }
        //TODO resident Logic
        //visitor id not provided, is resident
        else if (widget.colorMap[widget.parkingLotName] == Color(0xFFF2F2F2) &&
            widget.visitorId == null &&
            widget.userType == 'Resident') {
          // Popup(
          //   title: 'Confirmation',
          //   content: Text('Are you sure you want the select this parking slot'),
          //   buttons: [
          //     ButtonConfig(
          //       text: 'Confirm',
          //       onPressed: () async {
          //         // Your logic when Confirm button is presssed
          //         confirmParking = true;
          //         // print(confirmParking);
          //         Navigator.pop(context);
          //         if (confirmParking == true) {
          //           setState(
          //             () {
          //               widget.colorMap[widget.parkingLotName] =
          //                   GlobalVariables.primaryColor;
          //               confirmParking = !confirmParking;
          //             },
          //           );
          //         }
          //       },
          //     ),
          //     ButtonConfig(
          //       text: 'Cancel',
          //       onPressed: () {
          //         // Your logic when Assign Parking button is pressed
          //         Navigator.pop(context);
          //       },
          //     ),
          //   ],
          // ).show(context);
          //if no there is visitor id and parking not yet assigned, do nothing
        } else if (widget.colorMap[widget.parkingLotName] ==
                Color(0xFFF2F2F2) &&
            widget.visitorId == null &&
            widget.userType == 'Visitor') {
          //do nothing
        } else {
          //the parking slot is chosen
          if (widget.userType == 'Resident') {
            Popup(
              title: 'Resident details',
              content: SizedBox(
                height: 180,
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
                              residentDetailFromProvider['Full Name'] as String,
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
                              'Car Plate No',
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
                              residentDetailFromProvider['Car Plate'] as String,
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
                              residentDetailFromProvider['Unit No'] as String,
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
                              residentDetailFromProvider['Phone Number']
                                  as String,
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
                  text: 'Cancel',
                  onPressed: () {
                    // Your logic when Confirm button is pressed
                    Navigator.pop(context);
                  },
                ),
              ],
            ).show(context);
          } else if (widget.userType == 'Visitor') {
            Popup(
              title: 'Visitor details',
              content: SizedBox(
                height: widget.userType == 'Resident' ? 180 : 280,
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
                              visitorDetailFromProvider['Full Name'] as String,
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
                              visitorDetailFromProvider['Car Plate'] as String,
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
                              'Unit No',
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
                              visitorDetailFromProvider['Unit No'] as String,
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
                              'Check in time',
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
                              visitorDetailFromProvider['Check-in Time']
                                  as String,
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
                              'Check in date',
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
                              visitorDetailFromProvider['Check-in Date']
                                  as String,
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
                              visitorDetailFromProvider['Phone Number']
                                  as String,
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
                  text: 'Cancel',
                  onPressed: () {
                    // Your logic when Confirm button is pressed
                    Navigator.pop(context);
                  },
                ),
              ],
            ).show(context);
          } else {
            print(widget.userType);
            print(visitorDetails['visitorId']);
            print(visitorDetails);
          }
        }
      },
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: widget.colorMap[widget.parkingLotName],
        ),
        child: Center(
          child: Text(
            widget.parkingLotName,
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: widget.colorMap[widget.parkingLotName] ==
                        GlobalVariables.primaryColor
                    ? Colors.white
                    : Colors.black),
          ),
        ),
      ),
    );
  }
}
