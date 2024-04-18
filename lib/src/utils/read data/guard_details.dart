import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../widgets/purple_list_tile.dart';
import 'get_guard_details.dart';


class GuardDetails extends StatefulWidget {
  final bool showImage;
  final bool hasSlidable;
  const GuardDetails(
      {super.key, required this.showImage, required this.hasSlidable});

  @override
  State<GuardDetails> createState() => _GuardDetailsState();
}

class _GuardDetailsState extends State<GuardDetails> {
  final guard = FirebaseAuth.instance.currentUser;

  //documnet IDs
  Stream<List<String>>? guardIDsStream;

  @override
  //use StreamBuilder to update UI whatever there are changes in firebase
  void initState() {
    super.initState();
    guardIDsStream =
        FirebaseFirestore.instance.collection('Guard').snapshots().map(
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
              stream: guardIDsStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.active) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        return PurpleListTile(
                          type: 'Guard',
                          title: [
                            GetGuardDetails(
                              documentId: snapshot.data![index],
                              showImage: widget.showImage,
                            )
                          ],
                          icon: Icons.delete,
                          hasSlidable: widget.hasSlidable,
                        );
                      },
                    );
                  } else {
                    return const Text('Error loading data');
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
