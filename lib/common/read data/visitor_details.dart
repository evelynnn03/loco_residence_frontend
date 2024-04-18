import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sef_ass/constants/global_variables.dart';
import '../../common/purple_list_tile.dart';
import '../../models/visitor.dart';
import 'get_visitor_details.dart';

class VisitorDetails extends StatefulWidget {
  final int tab;
  const VisitorDetails({super.key, required this.tab});

  @override
  State<VisitorDetails> createState() => _VisitorDetailsState();
}

class GetData {
  static final CollectionReference data =
      FirebaseFirestore.instance.collection('Visitor');

  static Stream<QuerySnapshot> getData() {
    final dataStream =
        data.orderBy('Check-in Time', descending: true).snapshots();

    return dataStream;
  }
}

class _VisitorDetailsState extends State<VisitorDetails> {
  final visitor = FirebaseAuth.instance.currentUser;

  //documnet IDs
  Stream<List<String>>? visitorIDsStream;

  // get residentIDs
  @override
  void initState() {
    super.initState();
    visitorIDsStream =
        FirebaseFirestore.instance.collection('Visitor').snapshots().map(
              (snapshot) =>
                  snapshot.docs.map((document) => document.id).toList(),
            );
  }

  Future<Map<String, List<DateTime>>> fetchData(
      List<String> documentIds) async {
    Map<String, List<DateTime>> visitorDataMap = {};

    for (String docId in documentIds) {
      DocumentSnapshot docSnapshot = await FirebaseFirestore.instance
          .collection('Visitor')
          .doc(docId)
          .get();

      if (docSnapshot.exists) {
        Map<String, dynamic> data = docSnapshot.data() as Map<String, dynamic>;
        Visitor visitor = Visitor.fromMap(data);

        String checkInDate = visitor.checkInDate;
        String checkInTime = visitor.checkInTime;
        String checkOutDate = visitor.checkOutDate;
        String checkOutTime = visitor.checkOutTime;

        //Check if it is not null, then add
        if (checkInTime != '' && checkInDate != '') {
          String sCheckInTime = "$checkInDate $checkInTime";
          DateTime? checkInDateTime =
              DateFormat("dd/MM/yyyy HH:mm").parse(sCheckInTime);
          visitorDataMap.putIfAbsent(docId, () => []).add(checkInDateTime);
        }

        if (checkOutDate != '' && checkOutTime != '') {
          String sCheckOutTime = "$checkOutDate $checkOutTime";
          DateTime? checkOutDateTime =
              DateFormat("dd/MM/yyyy HH:mm").parse(sCheckOutTime);
          visitorDataMap.putIfAbsent(docId, () => []).add(checkOutDateTime);
        }
      }
    }

    return visitorDataMap;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: StreamBuilder<List<String>>(
              stream: visitorIDsStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.active) {
                  if (snapshot.hasData) {
                    if (widget.tab == 1) {
                      return ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          return PurpleListTile(
                            type: 'Visitor',
                            title: [
                              GetVisitorDetails(
                                documentId: snapshot.data![index],
                                tab: widget.tab,
                              )
                            ],
                            icon: Icons.logout_rounded,
                            hasSlidable: true,
                          );
                        },
                      );
                    } else {
                      return FutureBuilder<Map<String, List<DateTime>>>(
                        future: fetchData(snapshot.data!),
                        builder: (context, countSnapshot) {
                          if (countSnapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          } else if (countSnapshot.hasError) {
                            return Text(
                                'Error loading count: ${countSnapshot.error}');
                          } else {
                            Map<String, List<DateTime>> visitorData =
                                countSnapshot.data!;
                            Map<String, List<DateTime>> sortedVisitorDataMap =
                                {};

                            //Make the map in the form of <docID : DateTime>
                            visitorData.forEach(
                              (docId, timeList) {
                                timeList.forEach(
                                  (time) {
                                    sortedVisitorDataMap.putIfAbsent(
                                        '$docId: $time', () => []);
                                  },
                                );
                              },
                            );

                            //convert the map into the list
                            List<String> sortedVisitorData =
                                sortedVisitorDataMap.keys.toList();

                            //Sort the List of DateTime in descending order
                            sortedVisitorData.sort((a, b) => DateTime.parse(
                                    b.split(': ')[1])
                                .compareTo(DateTime.parse(a.split(': ')[
                                    1]))); // Change here for descending order

                            //Create two list that have docID and DateTime respectively
                            List<String> idList = sortedVisitorData
                                .map((entry) => entry.split(': ')[0])
                                .toList();

                            List<String> timeList = sortedVisitorData
                                .map((entry) => entry.split(': ')[1])
                                .toList();

                            int dataCount = sortedVisitorData.length;

                            //Print the List and dataCount for debuging purpose
                            sortedVisitorData.forEach((entry) {
                              print(entry);
                            });
                            print(dataCount);

                            return ListView.builder(
                              itemCount: dataCount,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 8.0, horizontal: 15),
                                  child: Container(
                                    height: 100,
                                    decoration: BoxDecoration(
                                      color: GlobalVariables.analyticsBarColor,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              GetVisitorDetails(
                                                documentId: idList[index],
                                                tab: widget.tab,
                                                list: timeList[index],
                                              ),
                                            ])
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          }
                        },
                      );
                    }
                  } else {
                    return Text('Error loading data');
                  }
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
