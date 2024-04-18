import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../common/purple_list_tile.dart';
import 'get_resident_details.dart';

class ResidentDetails extends StatefulWidget {
  const ResidentDetails({super.key});

  @override
  State<ResidentDetails> createState() => _ResidentDetailsState();
}

class _ResidentDetailsState extends State<ResidentDetails> {
  final resident = FirebaseAuth.instance.currentUser;

  //documnet IDs
  Stream<List<String>>? residentIDsStream;

  // get residentIDs
  @override
  void initState() {
    super.initState();
    residentIDsStream =
        FirebaseFirestore.instance.collection('Resident').snapshots().map(
              (snapshot) =>
                  snapshot.docs.map((document) => document.id).toList(),
            );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: StreamBuilder<List<String>>(
              stream: residentIDsStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.active) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        return PurpleListTile(
                          type: 'Resident',
                          title: [
                            GetResidentDetails(
                                documentId: snapshot.data![index])
                          ],
                          icon: Icons.delete,
                          hasSlidable: true,
                        );
                      },
                    );
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
