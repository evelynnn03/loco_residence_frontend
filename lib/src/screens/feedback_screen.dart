import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/buttons.dart';
import '../widgets/pop_up_window.dart';
import '../widgets/option_button.dart';
import 'package:flutter/material.dart';
import '../widgets/text_field.dart';
import '../constants/global_variables.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../models/feedback.dart' as myfeedback;

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});
  static const String routeName = '/feedback';

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final int initialRating = 1;
  int userRating = 0;
  String unitNo = '';
  String feedbackCategory = '';
  int feedbackRating = 0;
  late String residentId;

  @override
  void initState() {
    super.initState();
    _retrieveUserDetails();
  }

  Future<void> _retrieveUserDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      residentId = prefs.getString('residentId') ?? '';
      unitNo = prefs.getString('unitNo') ?? '';
    });
  }

  // Function to submit feedback
  void submitFeedback() async {
    // try {
    //   if (unitNo.isEmpty || residentId.isEmpty) {
    //     // print('Unit number is empty');
    //     // print('Resident Id is also empty');
    //     return;
    //   }
    final feedbackDetails = desController.text.trim();
    if (feedbackDetails == '') {
      Popup(
          title: 'Warning',
          content: SizedBox(
              height: 60,
              child: Center(child: Text("Please enter your feedback"))),
          buttons: [ButtonConfig(text: 'OK', onPressed: () {})]).show(context);
    } else {
      myfeedback.Feedback feedback = myfeedback.Feedback(
        unitNo: unitNo,
        feedbackDetails: feedbackDetails,
        feedbackCategory: feedbackCategory,
        feedbackRating: userRating,
      );

      FirebaseFirestore.instance.collection('Feedback').add(
            feedback.toMap(),
          );

      desController.clear();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Feedback submitted successfully!'),
        ),
      );
    }

    // setState(() {
    //   feedbackDetails = desController.text;
    // });

    // print('Unit Number: $unitNo');
    // } catch (e) {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(
    //       content: Text('Error fetching unit number: $e'),
    //     ),
    //   );
    // }
  }

  final formKey = GlobalKey<FormState>();
  final desController = TextEditingController();

  int isSelectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    // Color backgroundColor = Theme.of(context).primaryColor;
    Color buttonColor1 = GlobalVariables.lightGrey;
    Color buttonColor2 = GlobalVariables.primaryColor;

    return Scaffold(
      backgroundColor: GlobalVariables.secondaryColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 25),
                  const Padding(
                    padding: EdgeInsets.only(left: 15.0),
                    child: Text(
                      "Feedback",
                      style: TextStyle(
                        color: GlobalVariables.primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 250,
                    child: MyTextField(
                      isDescriptionBox: true,
                      maxLines: 8,
                      controller: desController,
                      hintText: 'Write your feedback here...',
                      keyboardType: TextInputType.text,
                      validate: false,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8.0,
                      vertical: 15,
                    ),
                    child: Container(
                      height: 55,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(40),
                      ),
                      child: Center(
                        child: RatingBar.builder(
                          initialRating: initialRating.toDouble(),
                          minRating: 1,
                          direction: Axis.horizontal,
                          allowHalfRating: false,
                          itemCount: 5,
                          itemPadding: const EdgeInsets.symmetric(
                            horizontal: 7.0,
                          ),
                          itemBuilder: (context, _) => const Icon(
                            Icons.star,
                            size: 7,
                            color: Colors.amber,
                          ),
                          onRatingUpdate: (rating) {
                            userRating = rating.toInt();
                          },
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 25),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    child: Row(
                      children: [
                        Expanded(
                          //isSelectedIndex 0
                          child: OptionButton(
                            text: 'Facility',
                            color: isSelectedIndex == 0
                                ? buttonColor2
                                : buttonColor1,
                            // ? GlobalVariables.feedbackSelected
                            // : GlobalVariables.secondaryColor,
                            isChosen: isSelectedIndex == 0,
                            onSelected: (boolSelect) {
                              setState(() {
                                feedbackCategory = 'Facility';
                                isSelectedIndex = boolSelect ? 0 : -1;
                              });
                            },
                          ),
                        ),
                        const SizedBox(width: 15),
                        //isSelectedIndex 1
                        Expanded(
                          child: OptionButton(
                            text: 'Maintenance',
                            color: isSelectedIndex == 1
                                ? buttonColor2
                                : buttonColor1,
                            isChosen: isSelectedIndex == 1,
                            onSelected: (boolSelect) {
                              setState(() {
                                feedbackCategory = 'Maintenance';
                                isSelectedIndex = boolSelect ? 1 : -1;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    child: Row(
                      children: [
                        //isSelectedIndex 2
                        Expanded(
                          child: OptionButton(
                            text: 'Security',
                            color: isSelectedIndex == 2
                                ? buttonColor2
                                : buttonColor1,
                            onSelected: (boolSelect) {
                              setState(() {
                                feedbackCategory = 'Security';
                                isSelectedIndex = boolSelect ? 2 : -1;
                              });
                            },
                            isChosen: isSelectedIndex == 2,
                          ),
                        ),
                        const SizedBox(width: 15),
                        //isSelectedIndex 3
                        Expanded(
                          child: OptionButton(
                            text: 'Other',
                            color: isSelectedIndex == 3
                                ? buttonColor2
                                : buttonColor1,
                            isChosen: isSelectedIndex == 3,
                            onSelected: (boolSelect) {
                              setState(() {
                                feedbackCategory = 'Suggestion';
                                isSelectedIndex = boolSelect ? 3 : -1;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 50),
                  GestureDetector(
                    onTap: submitFeedback,
                    child: MyButton(
                        onTap: () {
                          if (formKey.currentState!.validate()) {
                            // Form is valid, perform the submission
                            submitFeedback();
                          }
                        },
                        text: 'Send'),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
