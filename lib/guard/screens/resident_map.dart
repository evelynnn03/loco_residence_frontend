import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sef_ass/resident/provider/resident_parking_provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import '../../common/pop_up_window.dart';
import '../../constants/global_variables.dart';
import '../widget/panel_widget.dart';
import '../widget/tappable_container.dart';

class ResidentMap extends StatefulWidget {
  const ResidentMap({super.key});

  @override
  State<ResidentMap> createState() => _ResidentMapState();
}

class _ResidentMapState extends State<ResidentMap> {
  List<String>? parkedLots;
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
    List<String> unitNoParkingList = [];
    // Fetch all documents from the 'Resident' collection
    QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await FirebaseFirestore.instance.collection('Resident').get();
    try {
      //search through all the firestore data
      for (QueryDocumentSnapshot<Map<String, dynamic>> document
          in querySnapshot.docs) {
        if (document.data().containsKey('Unit No')) {
          String unitNo = document.data()['Unit No'];

          final residentDetailsList =
              Provider.of<ResidentParkingDetailsProvider>(context,
                  listen: false);
          String residentId = document.id;
          String residentParkingLots = unitNo;
          print('residentId: $residentId');
          //add the maps into the provider
          if (!residentDetailsList.containsResident(residentId)) {
            Map<String, String> residentDetails = {
              'residentId': residentId,
              'Full Name': document.data()['Resident Name'] ?? '',
              'Car Plate': document.data()['Car Plate'] ?? '',
              'Phone Number': document.data()['Resident HP'] ?? '',
              'Unit No': document.data()['Unit No'] ?? '',
            };
            residentDetailsList.addResidentDetails(residentDetails);
          } else {
            print(residentDetailsList);
          }

          // Now you can use parkingNumberString as a String
          unitNoParkingList.add(residentParkingLots);
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
    return unitNoParkingList;
  }

  var containerColor = Color(0xFFF2F2F2);
  Map<String, Color> containerColors = {
    'A1': Color(0xFFF2F2F2),
    'A2': Color(0xFFF2F2F2),
    'A3': Color(0xFFF2F2F2),
    'A4': Color(0xFFF2F2F2),
    'B1': Color(0xFFF2F2F2),
    'B2': Color(0xFFF2F2F2),
    'B3': Color(0xFFF2F2F2),
    'B4': Color(0xFFF2F2F2),
    'C1': Color(0xFFF2F2F2),
    'C2': Color(0xFFF2F2F2),
    'C3': Color(0xFFF2F2F2),
    'C4': Color(0xFFF2F2F2),
    'D1': Color(0xFFF2F2F2),
    'D2': Color(0xFFF2F2F2),
    'D3': Color(0xFFF2F2F2),
    'D4': Color(0xFFF2F2F2),
    'E1': Color(0xFFF2F2F2),
    'E2': Color(0xFFF2F2F2),
    'E3': Color(0xFFF2F2F2),
    'E4': Color(0xFFF2F2F2),
  };

  @override
  Widget build(BuildContext context) {
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
          userType: 'Resident',
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
                parkingLotName: 'A1',
                colorMap: containerColors,
                userType: 'Resident',
              ),

              // Context Row (subsequent rows)
              TappableContainer(
                  parkingLotName: 'A2',
                  colorMap: containerColors,
                  userType: 'Resident'),
              TappableContainer(
                  parkingLotName: 'A3',
                  colorMap: containerColors,
                  userType: 'Resident'),
              TappableContainer(
                  parkingLotName: 'A4',
                  colorMap: containerColors,
                  userType: 'Resident'),
              TappableContainer(
                  parkingLotName: 'B1',
                  colorMap: containerColors,
                  userType: 'Resident'),
              TappableContainer(
                  parkingLotName: 'B2',
                  colorMap: containerColors,
                  userType: 'Resident'),
              TappableContainer(
                  parkingLotName: 'B3',
                  colorMap: containerColors,
                  userType: 'Resident'),
              TappableContainer(
                  parkingLotName: 'B4',
                  colorMap: containerColors,
                  userType: 'Resident'),
              TappableContainer(
                  parkingLotName: 'C1',
                  colorMap: containerColors,
                  userType: 'Resident'),
              TappableContainer(
                  parkingLotName: 'C2',
                  colorMap: containerColors,
                  userType: 'Resident'),
              TappableContainer(
                  parkingLotName: 'C3',
                  colorMap: containerColors,
                  userType: 'Resident'),
              TappableContainer(
                  parkingLotName: 'C4',
                  colorMap: containerColors,
                  userType: 'Resident'),
              TappableContainer(
                  parkingLotName: 'D1',
                  colorMap: containerColors,
                  userType: 'Resident'),
              TappableContainer(
                  parkingLotName: 'D2',
                  colorMap: containerColors,
                  userType: 'Resident'),
              TappableContainer(
                  parkingLotName: 'D3',
                  colorMap: containerColors,
                  userType: 'Resident'),
              TappableContainer(
                  parkingLotName: 'D4',
                  colorMap: containerColors,
                  userType: 'Resident'),
              TappableContainer(
                  parkingLotName: 'E1',
                  colorMap: containerColors,
                  userType: 'Resident'),
              TappableContainer(
                  parkingLotName: 'E2',
                  colorMap: containerColors,
                  userType: 'Resident'),
              TappableContainer(
                  parkingLotName: 'E3',
                  colorMap: containerColors,
                  userType: 'Resident'),
              TappableContainer(
                  parkingLotName: 'E4',
                  colorMap: containerColors,
                  userType: 'Resident'),
            ],
          ),
        ),
      ),
    );
  }
}
