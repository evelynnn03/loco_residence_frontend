// ignore_for_file: use_build_context_synchronously

import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import '../provider/visitor_parking_provider.dart';
import '../../src/constants/global_variables.dart';
import '../../src/widgets/pop_up_window.dart';
import '../widget/panel_widget.dart';
import '../widget/tappable_container.dart';

class VisitorMap extends StatefulWidget {
  static const String routeName = '/visitormap';
  String? vistorId;
  VisitorMap({super.key, this.vistorId});

  @override
  State<VisitorMap> createState() => _VisitorMapState();
}

class _VisitorMapState extends State<VisitorMap> {
  //list of string of parked lots
  List<String>? parkedLots;
  //key ParkingNO : value {all the visitor detials in a Map object}

  final panelController =
      PanelController(); //initialise panel Controller to have the drag handler

  @override
  void initState() {
    super.initState();
    initializeData();
  }

  Future<void> initializeData() async {
    // Fetch data asynchronously
    parkedLots = await fetchData();

    // Process the data
    for (String parkingNo in parkedLots!) {
      if (containerColors.containsKey(parkingNo)) {
        containerColors[parkingNo] = GlobalVariables.primaryColor;
      }
    }
    // Trigger a rebuild after data is loaded
    if (mounted) {
      setState(() {});
    }
  }

  Future<List<String>> fetchData() async {
    List<String> parkingNumbers = [];
    // Fetch all documents from the 'Visitor' collection
    QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await FirebaseFirestore.instance.collection('Visitor').get();
    try {
      //search through all the firestore data, if there is parking number and no check out time, add all the collections to the visitorDetailsProvider (if there is no duplicated id)
      for (QueryDocumentSnapshot<Map<String, dynamic>> document
          in querySnapshot.docs) {
        if (document.data().containsKey('Parking Number') &&
            document.data().containsKey('Check-out Time')) {
          dynamic parkingNumber = document.data()['Parking Number'];
          String? checkOutTime = document.data()['Check-out Time'];

          if (parkingNumber != null && checkOutTime == null) {
            final visitorDetailsList =
                Provider.of<VisitorDetailsProvider>(context, listen: false);
            String visitorId = document.id;
            String parkingNumberString = parkingNumber;

            //add the map into the provider
            if (!visitorDetailsList.containsVisitor(visitorId)) {
              Map<String, String> visitorDetails = {
                'visitorId': visitorId,
                'Full Name': document.data()['Full Name'] ?? '',
                'Car Plate': document.data()['Car Plate'] ?? '',
                'Check-in Time': document.data()['Check-in Time'] ?? '',
                'Check-in Date': document.data()['Check-in Date'] ?? '',
                'Phone Number': document.data()['Phone Number'] ?? '',
                'Unit No': document.data()['Unit No'] ?? '',
                'Parking Number': document.data()['Parking Number'] ?? '',
              };
              visitorDetailsList.addVisitorDetails(visitorDetails);
            }

            // Now you can use parkingNumberString as a String
            parkingNumbers.add(parkingNumberString);
          }
        }
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
    return parkingNumbers;
  }

  var containerColor = Color(0xFFF2F2F2);
  Map<String, Color> containerColors = {
    'P01': Color(0xFFF2F2F2),
    'P02': Color(0xFFF2F2F2),
    'P03': Color(0xFFF2F2F2),
    'P04': Color(0xFFF2F2F2),
    'P05': Color(0xFFF2F2F2),
    'P06': Color(0xFFF2F2F2),
    'P07': Color(0xFFF2F2F2),
    'P08': Color(0xFFF2F2F2),
    'P09': Color(0xFFF2F2F2),
    'P10': Color(0xFFF2F2F2),
    'P11': Color(0xFFF2F2F2),
    'P12': Color(0xFFF2F2F2),
    'P13': Color(0xFFF2F2F2),
    'P14': Color(0xFFF2F2F2),
    'P15': Color(0xFFF2F2F2),
    'P16': Color(0xFFF2F2F2),
    'P17': Color(0xFFF2F2F2),
    'P18': Color(0xFFF2F2F2),
    'P19': Color(0xFFF2F2F2),
    'P20': Color(0xFFF2F2F2),
  };
  @override
  Widget build(BuildContext context) {
    final visitorDetailsList =
        Provider.of<VisitorDetailsProvider>(context, listen: false)
            .printVisitorDetailsList();
    //take the height of screen * 0.3
    final double panelHeightClosed = MediaQuery.of(context).size.height * 0.13;
    final double panelHeightOpened = MediaQuery.of(context).size.height * 0.22;
    return Scaffold(
      body: SlidingUpPanel(
        minHeight: panelHeightClosed,
        maxHeight: panelHeightOpened,
        panelBuilder: (controller) => PanelWidget(
          controller: controller,
          panelController: panelController,
          userType: 'Visitor',
        ),
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(18),
        ),
        parallaxEnabled: true,
        parallaxOffset: .2,
        body: Padding(
          padding: const EdgeInsets.only(top: 40, left: 25, right: 25),
          child: GridView.count(
            mainAxisSpacing: 25,
            crossAxisSpacing: 20,
            crossAxisCount: 4,
            children: [
              TappableContainer(
                parkingLotName: 'P01',
                colorMap: containerColors,
                userType: 'Visitor',
                visitorId: widget.vistorId,
                onContainerTapped: () {
                  widget.vistorId = null;
                },
              ),

              // Context Row (subsequent rows)
              TappableContainer(
                parkingLotName: 'P02',
                colorMap: containerColors,
                userType: 'Visitor',
                visitorId: widget.vistorId,
                onContainerTapped: () {
                  widget.vistorId = null;
                },
              ),
              TappableContainer(
                parkingLotName: 'P03',
                colorMap: containerColors,
                userType: 'Visitor',
                visitorId: widget.vistorId,
                onContainerTapped: () {
                  widget.vistorId = null;
                },
              ),
              TappableContainer(
                parkingLotName: 'P04',
                colorMap: containerColors,
                userType: 'Visitor',
                visitorId: widget.vistorId,
                onContainerTapped: () {
                  widget.vistorId = null;
                },
              ),
              TappableContainer(
                parkingLotName: 'P05',
                colorMap: containerColors,
                userType: 'Visitor',
                visitorId: widget.vistorId,
                onContainerTapped: () {
                  widget.vistorId = null;
                },
              ),
              TappableContainer(
                parkingLotName: 'P06',
                colorMap: containerColors,
                userType: 'Visitor',
                visitorId: widget.vistorId,
                onContainerTapped: () {
                  widget.vistorId = null;
                },
              ),
              TappableContainer(
                parkingLotName: 'P07',
                colorMap: containerColors,
                userType: 'Visitor',
                visitorId: widget.vistorId,
                onContainerTapped: () {
                  widget.vistorId = null;
                },
              ),
              TappableContainer(
                parkingLotName: 'P08',
                colorMap: containerColors,
                userType: 'Visitor',
                visitorId: widget.vistorId,
                onContainerTapped: () {
                  widget.vistorId = null;
                },
              ),
              TappableContainer(
                parkingLotName: 'P09',
                colorMap: containerColors,
                userType: 'Visitor',
                visitorId: widget.vistorId,
                onContainerTapped: () {
                  widget.vistorId = null;
                },
              ),
              TappableContainer(
                parkingLotName: 'P10',
                colorMap: containerColors,
                userType: 'Visitor',
                visitorId: widget.vistorId,
                onContainerTapped: () {
                  widget.vistorId = null;
                },
              ),
              TappableContainer(
                parkingLotName: 'P11',
                colorMap: containerColors,
                userType: 'Visitor',
                visitorId: widget.vistorId,
                onContainerTapped: () {
                  widget.vistorId = null;
                },
              ),
              TappableContainer(
                parkingLotName: 'P12',
                colorMap: containerColors,
                userType: 'Visitor',
                visitorId: widget.vistorId,
                onContainerTapped: () {
                  widget.vistorId = null;
                },
              ),
              TappableContainer(
                parkingLotName: 'P13',
                colorMap: containerColors,
                userType: 'Visitor',
                visitorId: widget.vistorId,
                onContainerTapped: () {
                  widget.vistorId = null;
                },
              ),
              TappableContainer(
                parkingLotName: 'P14',
                colorMap: containerColors,
                userType: 'Visitor',
                visitorId: widget.vistorId,
                onContainerTapped: () {
                  widget.vistorId = null;
                },
              ),
              TappableContainer(
                parkingLotName: 'P15',
                colorMap: containerColors,
                userType: 'Visitor',
                visitorId: widget.vistorId,
                onContainerTapped: () {
                  widget.vistorId = null;
                },
              ),
              TappableContainer(
                parkingLotName: 'P16',
                colorMap: containerColors,
                userType: 'Visitor',
                visitorId: widget.vistorId,
                onContainerTapped: () {
                  widget.vistorId = null;
                },
              ),
              TappableContainer(
                parkingLotName: 'P17',
                colorMap: containerColors,
                userType: 'Visitor',
                visitorId: widget.vistorId,
                onContainerTapped: () {
                  widget.vistorId = null;
                },
              ),
              TappableContainer(
                parkingLotName: 'P18',
                colorMap: containerColors,
                userType: 'Visitor',
                visitorId: widget.vistorId,
                onContainerTapped: () {
                  widget.vistorId = null;
                },
              ),
              TappableContainer(
                parkingLotName: 'P19',
                colorMap: containerColors,
                userType: 'Visitor',
                visitorId: widget.vistorId,
                onContainerTapped: () {
                  widget.vistorId = null;
                },
              ),
              TappableContainer(
                parkingLotName: 'P20',
                colorMap: containerColors,
                userType: 'Visitor',
                visitorId: widget.vistorId,
                onContainerTapped: () {
                  widget.vistorId = null;
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
