import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sef_ass/guard/provider/visitor_parking_provider.dart';
import 'package:sef_ass/resident/provider/resident_parking_provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import '../../constants/global_variables.dart';

class PanelWidget extends StatefulWidget {
  final ScrollController controller;
  final PanelController panelController; // for the drag handler
  final String userType;
  const PanelWidget(
      {super.key,
      required this.controller,
      required this.panelController,
      required this.userType})
      : assert(userType == 'Resident' || userType == 'Visitor');

  @override
  State<PanelWidget> createState() => _PanelWidgetState();
}

class _PanelWidgetState extends State<PanelWidget> {
  int remainingParkingLot = 0;
  void getParkedLots() {
    if (widget.userType == 'Resident') {
      remainingParkingLot = Provider.of<ResidentParkingDetailsProvider>(context)
          .returnRemainingParkingLot();
      print(Provider.of<ResidentParkingDetailsProvider>(context)
          .residentParkingDetailsList
          .length);
      print(remainingParkingLot);
    } else {
      remainingParkingLot = Provider.of<VisitorDetailsProvider>(context)
          .returnRemainingParkingLot();
      print(remainingParkingLot);
    }
  }

  @override
  Widget build(BuildContext context) {
    getParkedLots();
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Container(
            width: 50,
            height: 8,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 14),
                        child: Text(
                          'Level  ',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                      ),
                      Text(
                        '3A',
                        style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      )
                    ],
                  ),
                ),
                Column(
                  children: [
                    Row(
                      children: [
                        widget.userType == 'Visitor'
                            ? Text(
                                'Parked lot',
                                style: TextStyle(color: Colors.black),
                              )
                            : Text(
                                'Resident lot',
                                style: TextStyle(color: Colors.black),
                              ),
                        SizedBox(
                          width: 25,
                        ),
                        Container(
                          height: 10,
                          width: 10,
                          decoration: BoxDecoration(
                            color: GlobalVariables.primaryColor,
                            borderRadius: BorderRadius.circular(3),
                          ),
                        )
                      ],
                    ),
                    Row(
                      children: [
                        widget.userType == 'Visitor'
                            ? Text(
                                'Available lot',
                                style: TextStyle(color: Colors.black),
                              )
                            : Text(
                                'Available lot   ',
                                style: TextStyle(color: Colors.black),
                              ),
                        SizedBox(
                          width: 12,
                        ),
                        Container(
                          height: 10,
                          width: 10,
                          decoration: BoxDecoration(
                            color: Color(0xFFE2E2E2),
                            borderRadius: BorderRadius.circular(3),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 30,
                    )
                  ],
                )
              ],
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Remaining Parking lots: $remainingParkingLot',
                      style: TextStyle(color: Colors.black),
                    ),
                    Text(
                      'Total Parking lots: 20',
                      style: TextStyle(color: Colors.black),
                    ),
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
