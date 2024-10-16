import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:loco_frontend/src/constants/global_variables.dart';
import 'package:loco_frontend/src/widgets/buttons.dart';
import 'package:loco_frontend/src/widgets/text_field.dart';
import 'package:provider/provider.dart';

import '../../provider/finance_provider.dart';

class CardDetails extends StatefulWidget {
  const CardDetails({super.key});
  static const String routeName = '/card_details';

  @override
  State<CardDetails> createState() => _CardDetailsState();
}

class _CardDetailsState extends State<CardDetails> {
  final fullNameTextController = TextEditingController();
  final cardNumberTextController = TextEditingController();
  final expDateTextController = TextEditingController();
  final cvvTextController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  bool _isEditing = false;

  String formatDate(String dateString) {
    try {
      DateTime dateTime = DateTime.parse(dateString);
      return DateFormat('MM/yy').format(dateTime);
    } catch (e) {
      return '';
    }
  }

  // Function to convert expiry date from MM/yy to yyyy-MM-25 format
  String convertExpiryDate(String expiryDate) {
    try {
      // Parse the expiry date
      DateTime now = DateTime.now();
      List<String> parts = expiryDate.split('/');
      if (parts.length == 2) {
        String month = parts[0];
        String year = parts[1];
        // Use the current year for the conversion
        String formattedDate =
            '20$year-${month.padLeft(2, '0')}-25'; // Format to yyyy-MM-25
        return formattedDate;
      }
    } catch (e) {
      print('Error converting expiry date: $e');
    }
    return ''; // Return an empty string in case of an error
  }

  @override
  void initState() {
    super.initState();
    // Load existing card details if available
    final cardDetails =
        Provider.of<FinanceProvider>(context, listen: false).cardDetails;

    // Initialize controllers with card details when not editing
    fullNameTextController.text = cardDetails['cardName'] ?? '';
    cardNumberTextController.text = cardDetails['cardNo'] ?? '';
    expDateTextController.text = formatDate(cardDetails['cardExpiry'] ?? '');
    cvvTextController.text = cardDetails['cardCvv'] ?? '';
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    double sizedBoxHeight20(double height) => height < 600 ? 15 : 20;
    double sizedBoxHeight30(double height) => height < 600 ? 25 : 30;

    return Scaffold(
      backgroundColor: GlobalVariables.secondaryColor,
      appBar: AppBar(
        backgroundColor: GlobalVariables.secondaryColor,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: GlobalVariables.primaryColor,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Card Details',
                  style: TextStyle(
                    fontSize: 30,
                    color: GlobalVariables.primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: sizedBoxHeight20(screenHeight)),
                const Text(
                  'Fill in your card details\n(Visa / Mastercard)',
                  style: TextStyle(
                    fontSize: 20,
                    color: GlobalVariables.primaryColor,
                  ),
                ),
                SizedBox(height: sizedBoxHeight20(screenHeight)),
                MyTextField(
                    controller: fullNameTextController,
                    labelText: 'Full Name',
                    keyboardType: TextInputType.text,
                    enabled: _isEditing,
                    onChanged: (text) {
                      fullNameTextController.text = text.capitalize!;
                    }),
                SizedBox(height: sizedBoxHeight30(screenHeight)),
                MyTextField(
                  controller: cardNumberTextController,
                  labelText: 'Card No.',
                  keyboardType: TextInputType.number,
                  enabled: _isEditing,
                  inputFormatters: [CardNumberFormatter()],
                  maxLength: 19,
                ),
                SizedBox(height: sizedBoxHeight30(screenHeight)),
                MyTextField(
                  controller: expDateTextController,
                  labelText: 'Expiry Date',
                  keyboardType: TextInputType.number,
                  enabled: _isEditing,
                  inputFormatters: [CreditCardExpirationDateFormatter()],
                ),
                SizedBox(height: sizedBoxHeight30(screenHeight)),
                MyTextField(
                  controller: cvvTextController,
                  labelText: 'CVV / CVC',
                  keyboardType: TextInputType.number,
                  enabled: _isEditing,
                  inputFormatters: [CreditCardCvcInputFormatter()],
                ),
                SizedBox(height: screenHeight < 600 ? 90 : 100),
                MyButton(
                  onTap: () async {
                    if (_isEditing) {
                      if (formKey.currentState!.validate()) {
                        final updatedDetails = {
                          'resident': '1',
                          'card_no': cardNumberTextController.text,
                          'card_type':
                              'visa', // Replace with your logic to determine card type
                          'card_expiry': convertExpiryDate(expDateTextController
                              .text), // Convert expiry date
                          'card_cvv': cvvTextController.text,
                          'card_name': fullNameTextController.text,
                          'card_status': 'active',
                        };

                        final financeProvider = Provider.of<FinanceProvider>(
                            context,
                            listen: false);

                        // Pass the resident ID along with other details
                        await financeProvider.updateCardDetails(
                            1, 1, updatedDetails);

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Save successful'),
                            duration: Duration(seconds: 2),
                          ),
                        );

                        setState(() {
                          _isEditing =
                              false; // Switch to view mode after saving
                        });
                      }
                    } else {
                      setState(() {
                        _isEditing = true; // Switch to edit mode
                      });
                    }
                  },
                  text: _isEditing ? 'Save' : 'Modify',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// format for card number to be 1234 1234 1234 1234
class CardNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String newText = newValue.text.replaceAll(RegExp(r'\D'), '');
    String formattedText = '';
    for (int i = 0; i < newText.length; i++) {
      if (i > 0 && i % 4 == 0) {
        formattedText += ' ';
      }
      formattedText += newText[i];
    }
    return newValue.copyWith(
      text: formattedText,
      selection: TextSelection.collapsed(offset: formattedText.length),
    );
  }
}
