// ignore_for_file: must_be_immutable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../models/resident.dart';

class GetResidentDetails extends StatelessWidget {
  final String documentId;
  GetResidentDetails({required this.documentId});

  bool _dataFetched = false;

  @override
  Widget build(BuildContext context) {
    // get the collection
    if (!_dataFetched) {
      CollectionReference residents =
          FirebaseFirestore.instance.collection('Resident');

      return FutureBuilder<DocumentSnapshot>(
          future: residents.doc(documentId).get(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData && snapshot.data!.exists) {
                // Check if the snapshot has data and the document exists
                Map<String, dynamic>? data =
                    snapshot.data!.data() as Map<String, dynamic>?;

                if (data != null) {
                  Resident resident = Resident.fromMap(data);
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        resident.residentName,
                        style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      Text('Unit No.: ${resident.unitNo}',
                          style: TextStyle(fontSize: 11, color: Colors.white)),
                      Text('H/P No.: ${resident.residentHP}',
                          style: TextStyle(fontSize: 11, color: Colors.white))
                    ],
                  );
                } else {
                  return Text('Data is null.');
                }
              } else {
                return Text('Document does not exist.');
              }
            }
            return Text(
              'loading...',
              style: TextStyle(color: Colors.white),
            );
          });
    } else {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
  }
}
