import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/visitor.dart';


class GetVisitorDetails extends StatefulWidget {
  final String documentId;
  final int tab;
  final String? list;
  const GetVisitorDetails({
    super.key,
    required this.documentId,
    required this.tab,
    this.list,
  });

  @override
  State<GetVisitorDetails> createState() => _GetVisitorDetailsState();
}

class _GetVisitorDetailsState extends State<GetVisitorDetails> {
  final bool _dataFetched = false;

  @override
  Widget build(BuildContext context) {
    // get the collection
    if (!_dataFetched) {
      CollectionReference visitors =
          FirebaseFirestore.instance.collection('Visitor');

      return FutureBuilder<DocumentSnapshot>(
          future: visitors.doc(widget.documentId).get(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData && snapshot.data!.exists) {
                // Check if the snapshot has data and the document exists
                Map<String, dynamic>? data =
                    snapshot.data!.data() as Map<String, dynamic>?;

                if (data != null) {
                  Visitor visitor = Visitor.fromMap(data);

                  if (widget.tab == 1) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          visitor.fullName,
                          style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                        Text(
                            'Check In: ${visitor.checkInDate}  ${visitor.checkInTime}',
                            style: const TextStyle(
                                fontSize: 11, color: Colors.white)),
                        Text(
                            'Check Out: ${visitor.checkOutDate}  ${visitor.checkOutTime}',
                            style: const TextStyle(
                                fontSize: 11, color: Colors.white))
                      ],
                    );
                  } else if (widget.tab == 2) {
                    //Declaration
                    bool isCheckIn = true;
                    String checkInDate = visitor.checkInDate;
                    String checkInTime = visitor.checkInTime;
                    String checkOutDate = visitor.checkOutDate;
                    String checkOutTime = visitor.checkOutTime;
                    String finalCheckIn = "";
                    String finalCheckOut = "";

                    //Check if it is not null, then only convert the format
                    //Convert the format of 'dd/MM/yyyy HH:mm' into 'yyyy-MM-dd HH:mm:ss.SSS'
                    if (checkInDate != '' && checkInTime != '') {
                      String tempCheckIn = '$checkInDate $checkInTime';
                      DateTime? checkInDT =
                          DateFormat("dd/MM/yyyy HH:mm").parse(tempCheckIn);
                      finalCheckIn = DateFormat("yyyy-MM-dd HH:mm:ss.SSS")
                          .format(checkInDT);
                    }

                    if (checkOutDate != '' && checkOutTime != '') {
                      String tempCheckOut = "$checkOutDate $checkOutTime";
                      DateTime checkOutDT =
                          DateFormat("dd/MM/yyyy HH:mm").parse(tempCheckOut);
                      finalCheckOut = DateFormat("yyyy-MM-dd HH:mm:ss.SSS")
                          .format(checkOutDT);
                    }
                    if (finalCheckIn == widget.list) {
                      print("Checked In");
                      isCheckIn = true;
                    } else if (finalCheckOut == widget.list) {
                      print("Checked Out");
                      isCheckIn = false;
                    }

                    if (isCheckIn == true) {
                      isCheckIn = false;
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.8,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  visitor.fullName,
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                  overflow: TextOverflow
                                      .ellipsis, // This line ensures that the text is truncated with an ellipsis if it overflows.
                                  maxLines: 1, // Restricting to a single line
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.8,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Car Plate: ${visitor.carPlate}',
                                  style: const TextStyle(
                                    fontSize: 15,
                                    color: Colors.grey,
                                  ),
                                ),
                                const Text(
                                  'Checked In',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    color: Colors.green,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.8,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.8,
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '${visitor.checkInDate}   ${visitor.checkInTime}',
                                        style: const TextStyle(
                                          fontSize: 15,
                                          color: Colors.grey,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    } else if (isCheckIn == false) {
                      isCheckIn = true;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.8,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  visitor.fullName,
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  maxLines: 1,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.8,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Car Plate: ${visitor.carPlate}',
                                  style: TextStyle(
                                      fontSize: 15, color: Colors.grey),
                                ),
                                Text(
                                  'Checked Out',
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.8,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '${visitor.checkOutDate}   ${visitor.checkOutTime}',
                                  style: TextStyle(
                                      fontSize: 15, color: Colors.grey),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    } else {
                      return const Text('Data is null.');
                    }
                  }
                } else {
                  return const Text('Data is null.');
                }
              } else {
                return const Text('Document does not exist.');
              }
            }
            return const Text(
              'loading...',
              style: TextStyle(color: Colors.white),
            );
          });
    } else {
      return const Center(child: CircularProgressIndicator());
    }
  }
}
