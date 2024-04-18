import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pay/pay.dart';
import 'package:sef_ass/resident/widgets/apple_pay_button_mimic.dart';
import 'package:sef_ass/resident/widgets/theme_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../payment_configuration.dart';
import '../../common/pop_up_window.dart';
import '../../constants/global_variables.dart';
import 'package:provider/provider.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});
  static const String routeName = '/payment_screen';

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  int outstandingAmount = 0;
  late String residentId = '';

  @override
  void initState() {
    super.initState();
    _retrieveUserDetails();
  }

  Stream<int> getOutstandingAmountStream(String? residentId) {
    if (residentId != null && residentId.isNotEmpty) {
      CollectionReference residents =
          FirebaseFirestore.instance.collection('Resident');

      return residents.doc(residentId).snapshots().map((snapshot) {
        if (snapshot.exists) {
          return snapshot['Outstanding Amount (RM)'] ?? 0;
        } else {
          // Document does not exist
          print('Resident with ID $residentId not found');
          return 0; // Or handle accordingly
        }
      });
    } else {
      // Handle the case where residentId is null or empty
      print('Loading data');
      return Stream<int>.empty();
    }
  }

  Future<void> _retrieveUserDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      residentId = prefs.getString('residentId') ?? '';
      outstandingAmount = prefs.getInt('outstandingAmount') ?? 0;
    });
  }

//once payment successful
  void onGooglePayResult(res) async {
    CollectionReference residents =
        FirebaseFirestore.instance.collection('Resident');
    try {
      //get the resident snapshot beased on id
      DocumentSnapshot residentSnapshot = await residents.doc(residentId).get();

      if (residentSnapshot.exists) {
        // Update the 'Outstanding Amount (RM)' field to 0
        residents.doc(residentId).update({
          'Outstanding Amount (RM)': 0,
        });

        // Set outstandingAmount to 0 locally
        outstandingAmount = 0;

        // Close the payment screen
        Navigator.pop(context);
      } else {
        // Document does not exist
        print(
            'Resident with ID $residentId not found'); // Or handle accordingly
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error : $e'),
        ),
      );
    }
    setState(() {});
  }

  void showPaymentDialog(BuildContext context) {
    //the item to pay
    final paymentItems = [
      PaymentItem(
        label: 'Total',
        amount: outstandingAmount.toString(),
        status: PaymentItemStatus.final_price,
      )
    ];
    Popup(
      title: 'Select Payment method',
      content: SizedBox(
        height: 150,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GooglePayButton(
                  onPressed: () {},
                  loadingIndicator: Center(
                    child: CircularProgressIndicator(),
                  ),
                  height: 50,
                  type: GooglePayButtonType.pay,
                  width: double.infinity,
                  paymentConfiguration:
                      PaymentConfiguration.fromJsonString(defaultGooglePay),
                  onPaymentResult: onGooglePayResult,
                  paymentItems: paymentItems),
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: ApplePayButtonMimic(),
            ),
          ],
        ),
      ),
      buttons: [
        ButtonConfig(
          text: 'Cancel',
          onPressed: () async {},
        ),
      ],
    ).show(context);
  }

  @override
  Widget build(BuildContext context) {
    final mode = Provider.of<ThemeProvider>(context);
    Color boxShadowColor = Color.fromRGBO(130, 101, 234, 0.769);
    Color cardColor = Theme.of(context).cardColor;
    // getOverdue();

    return StreamBuilder(
      stream: getOutstandingAmountStream(residentId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Handle loading state
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          // Handle error state
          return Text('Error: ${snapshot.error}');
        } else {
          int outstandingAmount = snapshot.data ?? 0;
          return Scaffold(
            appBar: AppBar(
              // foregroundColor: GlobalVariables.primaryColor,
              backgroundColor: Colors.transparent,
              elevation: 0,
              centerTitle: true,
              title: Text(
                'Payment',
                style: TextStyle(
                  color: Theme.of(context).textTheme.bodySmall?.color ??
                      GlobalVariables.primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            body: ListView(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.only(left: 15.0, right: 15, bottom: 15),
                  child: Container(
                    height: 80,
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: mode.isDark
                          ? [
                              BoxShadow(
                                color: boxShadowColor,
                                offset: const Offset(
                                  0.0,
                                  0.0,
                                ),
                                blurRadius: 8.0,
                                spreadRadius: 0.0,
                              ), //BoxShadow
                              //BoxShadow
                            ]
                          : null,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Outstanding amount ',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            'RM ${outstandingAmount.toDouble().toString()}',
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 15,
                    right: 15,
                  ),
                  child: Container(
                    height: 80,
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: mode.isDark
                          ? [
                              BoxShadow(
                                color: boxShadowColor,
                                offset: const Offset(
                                  0.0,
                                  0.0,
                                ),
                                blurRadius: 8.0,
                                spreadRadius: 0.0,
                              ), //BoxShadow
                              //BoxShadow
                            ]
                          : null,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Make Payment',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              if (outstandingAmount != 0) {
                                showPaymentDialog(context);
                              } else {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  content: Text('No outstanding payment'),
                                  duration: Duration(seconds: 3),
                                ));
                              }
                            },
                            child: const Icon(
                              Icons.arrow_circle_right_outlined,
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
