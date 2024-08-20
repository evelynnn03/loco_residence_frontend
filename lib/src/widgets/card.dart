import 'package:flutter/material.dart';
import 'package:loco_frontend/src/constants/global_variables.dart';
import 'package:provider/provider.dart';

import '../provider/finance_provider.dart';

class CardContainer extends StatefulWidget {
  const CardContainer({super.key});

  @override
  State<CardContainer> createState() => _CardContainerState();
}

class _CardContainerState extends State<CardContainer> {
  late String cardNumber = '1212121';
  late String expiryDate = '';
  late String cardHolderName = '';
  late String cvvCode = '';
  String cardType = '';
  int residentId = 7; // Hardcoded for now

  Widget _buildCardLogo() {
    if (cardNumber.startsWith('4')) {
      return Image.asset(
        'assets/images/visa.png',
        height: 50,
        width: 50,
      );
    } else if (cardNumber.startsWith('5')) {
      return Image.asset(
        'assets/images/mastercard.png',
        height: 50,
        width: 50,
      );
    } else {
      return Icon(
        Icons.credit_card,
        size: 30,
        color: GlobalVariables.primaryColor,
      );
    }
  }

  @override
  void initState() {
    super.initState();
    // fetch card details
    Provider.of<Financeprovider>(context, listen: false)
        .fetchCardDetails(residentId);
  }

  @override
  Widget build(BuildContext context) {
    final cardDetails = Provider.of<Financeprovider>(context).cardDetails; //get the card details from the provider
    return Padding(
      padding: const EdgeInsets.all(25.0),
      child: Column(
        children: [
          Container(
            height: 230,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              color: Colors.lightBlueAccent,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey,
                  offset: const Offset(0.0, 0.0),
                  blurRadius: 8.0,
                  spreadRadius: 0.0,
                ),
              ],
            ),
            padding: const EdgeInsets.all(16),
            child: Padding(
              padding: EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Outstanding Amount',
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 16,
                        ),
                      ),
                      _buildCardLogo(),
                    ],
                  ),
                  SizedBox(height: 10),
                  Text(
                    'RM 0',
                    style: TextStyle(
                      color: GlobalVariables.primaryColor,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '$cardNumber',
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        '${cardDetails['cardExpiry']}',
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          TextFormField(
            decoration: InputDecoration(
              labelText: '${cardDetails['cardName']}',
            ),
            keyboardType: TextInputType.number,
            onChanged: (value) {
              setState(() {
                cardNumber = value;
              });
            },
          ),
        ],
      ),
    );
  }
}

// onChanged: (value) {
//                           setState(() {
//                             cardNumber = value;
//                           });
//                           // _detectCardType(value);
//                         },
