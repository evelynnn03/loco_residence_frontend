import 'package:flutter/material.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:loco_frontend/src/constants/global_variables.dart';

class CardContainer extends StatefulWidget {
  const CardContainer({super.key});

  @override
  State<CardContainer> createState() => _CardContainerState();
}

class _CardContainerState extends State<CardContainer> {
  late String cardNumber = '';
  late String expiryDate = '';
  late String cardHolderName = '';
  late String cvvCode = '';
  String cardType = '';

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
  Widget build(BuildContext context) {
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
                        '12/26',
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
              labelText: 'Card Number',
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
