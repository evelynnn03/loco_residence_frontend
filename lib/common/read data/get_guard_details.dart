// ignore_for_file: must_be_immutable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../models/guard.dart';

class GetGuardDetails extends StatelessWidget {
  final String documentId;
  final bool showImage;

  GetGuardDetails({required this.documentId, this.showImage = true});

  bool _dataFetched = false;

  @override
  Widget build(BuildContext context) {
    // get the collection
    if (!_dataFetched) {
      CollectionReference guards =
          FirebaseFirestore.instance.collection('Guard');

      return FutureBuilder<DocumentSnapshot>(
          future: guards.doc(documentId).get(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData && snapshot.data!.exists) {
                // Check if the snapshot has data and the document exists
                Map<String, dynamic>? data =
                    snapshot.data!.data() as Map<String, dynamic>?;

                if (data != null) {
                  Guard guard = Guard.fromMap(data);
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                        Row(
                          children: [
                            if (showImage && guard.imageUrl.isNotEmpty)
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10.0),
                                child: CircleAvatar(
                                  radius: 30,
                                  backgroundImage: NetworkImage(guard.imageUrl, ),
                                  
                                ),
                              ),
                            SizedBox(height: 8),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    guard.guardName,
                                    style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                  Text(
                                    'H/P No.: ${guard.guardHP}',
                                    style: TextStyle(
                                        fontSize: 11, color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
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
