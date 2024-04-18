import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sef_ass/common/pop_up_window.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/feedback_button.dart';
import 'package:flutter/material.dart';
import 'package:sef_ass/common/buttons.dart';
import '../../common/text_field.dart';
import '../../constants/global_variables.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../../models/feedback.dart' as myfeedback;

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
    try {
      if (unitNo.isEmpty || residentId.isEmpty) {
        // print('Unit number is empty');
        // print('Resident Id is also empty');
        return;
      }
      final feedbackDetails = desController.text.trim();
      if (feedbackDetails == '') {
        Popup(
                title: 'Warning',
                content: SizedBox(
                    height: 60,
                    child: Center(child: Text("Please enter your feedback"))),
                buttons: [ButtonConfig(text: 'OK', onPressed: () {})])
            .show(context);
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
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error fetching unit number: $e'),
        ),
      );
    }
  }

  final formKey = GlobalKey<FormState>();
  final desController = TextEditingController();

  int isSelectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    Color backgroundColor = Theme.of(context).primaryColor;
    Color buttonColor1 = Theme.of(context).buttonTheme.colorScheme?.primary ??
        GlobalVariables.secondaryColor;
    Color buttonColor2 = Theme.of(context).buttonTheme.colorScheme?.secondary ??
        GlobalVariables.feedbackSelected;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        foregroundColor: backgroundColor,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: GlobalVariables.backgroundColor,
          ),
          onPressed: () {
            Navigator.pop(context); // Navigate back when back button is pressed
          },
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 25),
                  const Text(
                    "  Feedback",
                    style: TextStyle(
                      color: GlobalVariables.backgroundColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 28,
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 230,
                    child: Column(
                      children: [
                        MyTextField(
                          isDescriptionBox: true,
                          maxLines: 8,
                          controller: desController,
                          hintText: 'Write your feedback here...',
                          keyboardType: TextInputType.text,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5.0),
                    child: Row(
                      children: [
                        Expanded(
                          //isSelectedIndex 0
                          child: FeedBackButton(
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
                        SizedBox(
                          width: 15,
                        ),
                        //isSelectedIndex 1
                        Expanded(
                          child: FeedBackButton(
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
                    padding: EdgeInsets.symmetric(horizontal: 5.0),
                    child: Row(
                      children: [
                        //isSelectedIndex 2
                        Expanded(
                          child: FeedBackButton(
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
                        SizedBox(
                          width: 15,
                        ),
                        //isSelectedIndex 3
                        Expanded(
                          child: FeedBackButton(
                            text: 'Suggestion',
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
                  SizedBox(
                    height: 50,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8.0,
                      vertical: 15,
                    ),
                    child: Container(
                      height: 50,
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
                          itemPadding: EdgeInsets.symmetric(
                            horizontal: 7.0,
                          ),
                          itemBuilder: (context, _) => Icon(
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
                  SizedBox(
                    height: 5,
                  ),
                  GestureDetector(
                    onTap: submitFeedback,
                    child: MyButton(text: 'Send Feedback'),
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
