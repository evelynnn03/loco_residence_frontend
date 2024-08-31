import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../constants/global_variables.dart';
import '../../guard/provider/visitor_parking_provider.dart';
import '../utils/read data/get_guard_details.dart';
import '../utils/read data/get_resident_details.dart';
import '../utils/read data/get_visitor_details.dart';

class PurpleListTile extends StatefulWidget {
  const PurpleListTile({
    super.key,
    required this.type,
    required this.title,
    this.icon,
    required this.hasSlidable,
  });
  final String type;
  final List<Widget> title;
  final IconData? icon;
  final bool hasSlidable;

  @override
  State<PurpleListTile> createState() => _PurpleListTileState();
}

class _PurpleListTileState extends State<PurpleListTile> {
  // doc id
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    double containerHeight = screenHeight * 0.11;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 15),
      child: widget.hasSlidable == true
          ? Slidable(
              endActionPane: ActionPane(
                motion: const ScrollMotion(),
                children: [
                  SlidableAction(
                    icon: widget.icon,
                    foregroundColor: Colors.red,
                    onPressed: (context) {
                      GetGuardDetails? getGuardDetails;
                      GetResidentDetails? getResidentDetails;
                      GetVisitorDetails? getVisitorDetails;

                      // Find the first GetGuardDetails or GetResidentDetails widget in the list of Widget
                      for (final widget in widget.title) {
                        if (widget is GetGuardDetails) {
                          getGuardDetails = widget;
                          break;
                        } else if (widget is GetResidentDetails) {
                          getResidentDetails = widget;
                          break;
                        } else if (widget is GetVisitorDetails) {
                          getVisitorDetails = widget;
                          break;
                        }
                      }

                      // Delete guard
                      if (getGuardDetails != null) {
                        // Handle the delete operation for guards
                        final String documentID =
                            getGuardDetails.documentId; //assign the id
                        showDeleteDialog(context, widget.type, documentID);
                        //if there is remove user, call
                      }

                      // Delete resident
                      else if (getResidentDetails != null) {
                        // Handle the delete operation for residents
                        final String documentID = getResidentDetails.documentId;
                        showDeleteDialog(context, widget.type, documentID);
                      }

                      // Update check-out time & date
                      else if (getVisitorDetails != null) {
                        final String documentID = getVisitorDetails.documentId;

                        CollectionReference data =
                            FirebaseFirestore.instance.collection(widget.type);

                        data
                            .doc(documentID)
                            .get()
                            .then((DocumentSnapshot documentSnapshot) {
                          if (documentSnapshot.exists) {
                            bool checkedOut =
                                documentSnapshot['Check-out Date'] != null;
                            if (checkedOut) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content:
                                      Text('Visitor has already checked out.'),
                                ),
                              );
                            } else {
                              //remove visitor from provider

                              Provider.of<VisitorDetailsProvider>(context,
                                      listen: false)
                                  .removeVisitorDetails(documentID);
                              showCheckOutDialog(
                                  context, widget.type, documentID);
                            }
                          } else {
                            print('Document does not exist');
                          }
                        });
                        //showCheckOutDialog(context, widget.type, documentID);
                      } else {
                        // Handle the case where neither GetGuardDetails nor GetResidentDetails is found in the list
                        print(
                            'The required details widget not found in the list');
                      }
                    },
                  )
                ],
              ),
              child: Container(
                height: containerHeight,
                decoration: BoxDecoration(
                  color: GlobalVariables.primaryColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(width: 20),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: widget.title,
                    )
                  ],
                ),
              ),
            )
          : Container(
              height: containerHeight,
              decoration: BoxDecoration(
                color: GlobalVariables.primaryColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(width: 20),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: widget.title,
                  )
                ],
              ),
            ),
    );
  }

  void showCheckOutDialog(
      BuildContext context, String type, String documentID) {
    // Show a confirmation dialog before checkout
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Check out $type'),
        content: Text('Are you sure you want to check out?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close the dialog
            },
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Update updateInstance =
                  Update(collection: type, documentID: documentID);
              updateInstance.update().then(
                (_) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('$type Checked Out.'),
                    ),
                  );
                },
              ).catchError(
                (error) {
                  print('Error Checking Out $type: $error');
                },
              );
              Navigator.pop(context); // Close the dialog
            },
            child: Text('Check-Out'),
          ),
        ],
      ),
    );
  }

  void showDeleteDialog(BuildContext context, String type, String documentID) {
    // Show a confirmation dialog before deleting
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete $type'),
        content: Text('Are you sure you want to delete this $type?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close the dialog
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Delete deleteInstance =
                  Delete(collection: type, documentID: documentID);
              deleteInstance.delete().then(
                (_) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('$type deleted'),
                    ),
                  );
                  //call this if not null
                },
              ).catchError(
                (error) {
                  print('Error deleting $type: $error');
                },
              );
              Navigator.pop(context); // Close the dialog
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

class Delete {
  final String collection; // guard or resident
  final String documentID; // what ID
  final CollectionReference
      data; // Represents the reference to the Firestore collection

  Delete({required this.collection, required this.documentID})
      : data = FirebaseFirestore.instance.collection(collection);

  Future<void> delete() {
    return data.doc(documentID).delete();
  }
}

class Update {
  final String collection;
  final String documentID;
  final CollectionReference data;

  Update({required this.collection, required this.documentID})
      : data = FirebaseFirestore.instance.collection(collection);

  Future<void> update() {
    //Convert the DateTime format into 'dd/MM/yyyy' for date and 'HH:mm' for time which is matched to our DB format
    DateTime tempDateTime = DateTime.now();
    String date = DateFormat('dd/MM/yyyy').format(tempDateTime);
    String time = DateFormat('HH:mm').format(tempDateTime);

    return data.doc(documentID).update({
      'Check-out Date': date,
      'Check-out Time': time,
    });
  }
}
