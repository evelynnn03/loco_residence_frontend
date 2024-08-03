import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:get/get.dart';
import 'package:loco_frontend/src/constants/global_variables.dart';
import 'package:loco_frontend/src/widgets/buttons.dart';
import 'package:loco_frontend/src/widgets/text_field.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GlobalVariables.secondaryColor,
      appBar: AppBar(
        backgroundColor: GlobalVariables.secondaryColor,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: GlobalVariables.primaryColor,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Card Details',
                style: TextStyle(
                  fontSize: 30,
                  color: GlobalVariables.primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Fill in your card details\n(Visa / Mastercard)',
                style: TextStyle(
                  fontSize: 20,
                  color: GlobalVariables.primaryColor,
                ),
              ),
              const SizedBox(height: 20),
              MyTextField(
                  controller: fullNameTextController,
                  labelText: 'Full Name',
                  keyboardType: TextInputType.text,
                  enabled: _isEditing,
                  onChanged: (text) {
                    fullNameTextController.text = text.capitalize!;
                  }),
              const SizedBox(height: 30),
              MyTextField(
                controller: cardNumberTextController,
                labelText: 'Card No.',
                keyboardType: TextInputType.number,
                enabled: _isEditing,
                inputFormatters: [CardNumberFormatter()],
                maxLength: 19,
              ),
              const SizedBox(height: 30),
              MyTextField(
                controller: expDateTextController,
                labelText: 'Expiry Date',
                keyboardType: TextInputType.number,
                enabled: _isEditing,
                inputFormatters: [CreditCardExpirationDateFormatter()],
              ),
              const SizedBox(height: 30),
              MyTextField(
                controller: cvvTextController,
                labelText: 'CVV / CVC',
                keyboardType: TextInputType.number,
                enabled: _isEditing,
                inputFormatters: [CreditCardCvcInputFormatter()],
              ),
              const SizedBox(height: 100),
              MyButton(
                onTap: () {
                  if (_isEditing) {
                    if (formKey.currentState!.validate()) {
                      // Save data logic
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Save successful'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                      setState(() {
                        _isEditing = false; // Switch to view mode after saving
                      });
                    }
                  } else {
                    setState(() {
                      _isEditing = true; // Switch to edit mode
                    });
                  }
                },
                text: _isEditing
                    ? 'Save'
                    : 'Modify', // Change button text based on mode
              ),
            ],
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
