// import 'package:assignment/common/purple_list_tile.dart';
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';

// import '../../common/read data/get_visitor_details.dart';

// class Timestamp extends StatefulWidget {
//   const Timestamp({super.key});

//   @override
//   State<StatefulWidget> createState() => _TimestampState();
// }

// class _TimestampState extends State<Timestamp> {
//   final visitor = FirebaseAuth.instance.currentUser;
//   Stream<List<String>>? visitorIDsStream;
  
//   @override
//   void initState() {
//     super.initState();
//     visitorIDsStream =
//         FirebaseFirestore.instance.collection('Visitor').snapshots().map(
//               (snapshot) =>
//                   snapshot.docs.map((document) => document.id).toList(),
//             );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.start,
//         children: [
//           Expanded(
//             child: StreamBuilder<List<String>>(
//               stream: visitorIDsStream,
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.active) {
//                   if (snapshot.hasData) {
//                     return ListView.builder(
//                       itemCount: snapshot.data!.length,
//                       itemBuilder: (context, index) {
//                         return PurpleListTile(
//                           type: 'Visitor',
//                           title: [
//                             GetVisitorDetails(
//                               documentId: snapshot.data![index],
//                               tab: 1,
//                             )
//                           ],
//                         );
//                       },
//                     );
//                   } else {
//                     return Text('Error loading data');
//                   }
//                 } else {
//                   return const Center(
//                     child: CircularProgressIndicator(),
//                   );
//                 }
//               },
//             ),
//           ),
//         ],
//       ),
//     );
    
    
//     // TODO: implement build
//     throw UnimplementedError();
//   }
// }