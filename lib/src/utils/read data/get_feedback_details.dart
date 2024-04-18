import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../../models/feedback.dart' as myfeedback;

class GetFeedbackDetails extends StatelessWidget {
  final String documentId;
  final Function(String, String) onPressed;
  GetFeedbackDetails({
    super.key,
    required this.documentId,
    required this.onPressed,
  });

  bool _dataFetched = false;

  @override
  Widget build(BuildContext context) {
    if (!_dataFetched) {
      CollectionReference feedback =
          FirebaseFirestore.instance.collection('Feedback');

      return FutureBuilder(
          future: feedback.doc(documentId).get(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData && snapshot.data!.exists) {
                Map<String, dynamic>? data =
                    snapshot.data!.data() as Map<String, dynamic>?;

                if (data != null) {
                  myfeedback.Feedback feedback =
                      myfeedback.Feedback.fromMap(data);

                  return GestureDetector(
                    onTap: () {
                      onPressed(feedback.unitNo, feedback.feedbackDetails);
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    feedback.feedbackCategory,
                                    style: const TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),

                                  //TODO rating based on feedback rating int
                                  RatingBar.builder(
                                    itemSize: 20,
                                    initialRating:
                                        feedback.feedbackRating.toDouble(),
                                    ignoreGestures: true,
                                    direction: Axis.horizontal,
                                    allowHalfRating: false,
                                    itemCount: 5,
                                    itemBuilder: (context, _) => Icon(
                                      Icons.star,
                                      color: Colors.amber,
                                    ),
                                    onRatingUpdate: (double value) {},
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                } else {
                  return Text('data is null');
                }
              } else {
                return Text('Document does not exist');
              }
            }

            return Text(
              'loading...',
              style: TextStyle(color: Colors.white),
            );
          });
    } else {
      return const CircularProgressIndicator();
    }
  }
}
