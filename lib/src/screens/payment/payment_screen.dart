import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loco_frontend/src/widgets/card.dart';
import 'package:loco_frontend/src/widgets/horizontal_tiles.dart';
import 'package:pay/pay.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../utils/payment_configuration.dart';
import '../../widgets/pop_up_window.dart';
import '../../constants/global_variables.dart';
import 'package:provider/provider.dart';
import '../../widgets/apple_pay_button_mimic.dart';
import '../../../config/themes/theme_provider.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});
  static const String routeName = '/payment_screen';

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  int outstandingAmount = 0;
  late String residentId = '';

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _retrieveUserDetails();
  }

  Future<void> _retrieveUserDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      residentId = prefs.getString('residentId') ?? '';
      outstandingAmount = prefs.getInt('outstandingAmount') ?? 0;
    });
  }

  // Ensure that `residentId` is not null or empty before using it
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

  // Detect whether it's a Visa or Mastercard
  // void _detectCardType(String input) {
  //   if (input.startsWith('4')) {
  //     setState(() {
  //       cardType = 'visa';
  //     });
  //   } else if (input.startsWith('5')) {
  //     setState(() {
  //       cardType = 'mastercard';
  //     });
  //   } else {
  //     setState(() {
  //       cardType = 'error';
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final mode = Provider.of<ThemeProvider>(context);
    Color boxShadowColor = Color.fromRGBO(130, 101, 234, 0.769);

    return StreamBuilder(
      stream: getOutstandingAmountStream(residentId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          int outstandingAmount = snapshot.data ?? 0;
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              centerTitle: true,
              title: const Text(
                'Payment',
                style: TextStyle(
                  color: GlobalVariables.primaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                ),
              ),
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  CardContainer(),
                  // CreditCardWidget(
                  //   cardNumber: cardNumber,
                  //   expiryDate: expiryDate,
                  //   cardHolderName: cardHolderName,
                  //   cvvCode: cvvCode,
                  //   showBackView: true,
                  //   onCreditCardWidgetChange: (CreditCardBrand cardBrand) {},
                  //   cardBgColor: GlobalVariables.primaryColor,
                  //   obscureCardCvv: true,
                  //   cardType: _buildCardLogo(),
                  // ),
                  Padding(
                    padding: EdgeInsets.only(top: 25.0),
                    child: Column(
                      children: [
                        // TextFormField(
                        //   decoration: InputDecoration(
                        //     labelText: 'Card Number',
                        //   ),
                        //   keyboardType: TextInputType.number,
                        //   onChanged: (value) {
                        //     setState(() {
                        //       cardNumber = value;
                        //     });
                        //     // _detectCardType(value);
                        //   },
                        // ),
                        HorizontalTiles(
                          title: 'Payment Details',
                          icon: Icons.arrow_circle_right_outlined,
                          routeName: '/payment_details',
                        ),
                        const SizedBox(height: 25),
                        HorizontalTiles(
                          title: 'Card Settings',
                          icon: Icons.expand_more_rounded,
                          isDropdown: true,
                          dropdownHeight: 400,
                          children: [
                            SizedBox(height: 25),
                            HorizontalTiles(
                              title: 'Remove Card',
                              icon: Icons.expand_more_rounded,
                              tileColor: GlobalVariables.lightGrey,
                              textColor: GlobalVariables.backgroundColor,
                              isDropdown: true,
                              children: [],
                            ),
                            SizedBox(height: 25),
                            HorizontalTiles(
                              title: 'Card Details',
                              icon: Icons.credit_card,
                              routeName: '/card_details',
                              tileColor: GlobalVariables.lightGrey,
                              textColor: GlobalVariables.backgroundColor,
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}

// if (outstandingAmount != 0) {
//                                 showPaymentDialog(context);
//                               } else {
//                                 ScaffoldMessenger.of(context)
//                                     .showSnackBar(SnackBar(
//                                   content: Text('No outstanding payment'),
//                                   duration: Duration(seconds: 3),
//                                 ));
//                               }

// Text(
//   'RM ${outstandingAmount.toDouble().toString()}',
//   style: const TextStyle(
//     fontSize: 20,
//     color: GlobalVariables.primaryColor,
//     fontWeight: FontWeight.w500,
//   ),
// ),
