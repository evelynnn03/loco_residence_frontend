import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:loco_frontend/src/constants/global_variables.dart';
import 'package:provider/provider.dart';
import '../provider/finance_provider.dart';

class CardContainer extends StatefulWidget {
  const CardContainer({super.key});

  @override
  State<CardContainer> createState() => _CardContainerState();
}

class _CardContainerState extends State<CardContainer> {
  String? cardNumber; // Changed to nullable
  String? expiryDate; // Changed to nullable
  String? cardHolderName; // Changed to nullable
  String? cvvCode; // Changed to nullable
  String cardType = '';
  int residentId = 1; // Hardcoded for now

  Widget _buildCardLogo() {
    final cardDetails = Provider.of<FinanceProvider>(context).cardDetails;
    final screenSize = MediaQuery.of(context).size; // Get the screen size
    final logoSize = screenSize.width * 0.15;

    // Safely access card number
    final cardNumber = cardDetails['cardNo'] ?? '';

    if (cardNumber.startsWith('4')) {
      return Image.asset(
        'assets/images/visa.png',
        height: logoSize,
        width: logoSize,
      );
    } else if (cardNumber.startsWith('5')) {
      return Image.asset(
        'assets/images/mastercard.png',
        height: logoSize,
        width: logoSize,
      );
    } else {
      return Icon(
        Icons.credit_card,
        size: GlobalVariables.responsiveIconSize(context, 30),
        color: GlobalVariables.primaryColor,
      );
    }
  }

  String formatDate(String? dateString) {
    if (dateString == null || dateString.isEmpty) {
      return ''; // Return empty if dateString is null or empty
    }
    try {
      DateTime dateTime = DateTime.parse(dateString);
      return DateFormat('MM/yy').format(dateTime);
    } catch (e) {
      return ''; // Return empty if parsing fails
    }
  }

  @override
  Widget build(BuildContext context) {
    final financeProvider = Provider.of<FinanceProvider>(context);
    final cardDetails = financeProvider.cardDetails;
    final totalOutstandingAmount = financeProvider.totalOutstandingAmount;
    final formattedAmount = totalOutstandingAmount.toStringAsFixed(2);
    final isLoading = financeProvider.isLoading;

    final screenHeight = MediaQuery.of(context).size.height;

    double cardHeight(double height) => height < 600 ? 210 : 230;
    double amountSizedBoxHeight(double height) => height < 210 ? 8 : 10;
    double cardNoSizedBoxHeight(double height) => height < 210 ? 35 : 40;

    String? cardNumberEnding;
    if (cardDetails.isNotEmpty &&
        cardDetails.containsKey('cardNo') &&
        cardDetails['cardNo'] != null) {
      String cardNumber = cardDetails['cardNo']!;
      cardNumberEnding = cardNumber.length >= 4
          ? cardNumber.substring(cardNumber.length - 4)
          : null; // Ensure card number has at least 4 digits
    } else {
      cardNumberEnding = null; // Handle case when there's no card
    }

    return Padding(
      padding: const EdgeInsets.all(25.0),
      child: Column(
        children: [
          isLoading
              ? const CircularProgressIndicator()
              : Container(
                  height: cardHeight(screenHeight),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    gradient: const LinearGradient(
                      colors: [
                        Color.fromARGB(255, 211, 166, 255), // First color
                        Color.fromRGBO(62, 165, 255, 1),
                        Color.fromRGBO(255, 235, 155, 1)
                      ],
                      begin:
                          Alignment.topLeft, // Starting point of the gradient
                      end: Alignment.bottomRight, // End point of the gradient
                    ),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.grey,
                        offset: Offset(0.0, 0.0),
                        blurRadius: 8.0,
                        spreadRadius: 0.0,
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Outstanding Amount',
                              style: GlobalVariables.bold16(
                                context,
                                color: Colors.black54,
                              ),
                            ),
                            _buildCardLogo(),
                          ],
                        ),
                        SizedBox(
                            height:
                                amountSizedBoxHeight(cardHeight(screenHeight))),
                        Text(
                          'RM $formattedAmount',
                          style: const TextStyle(
                            color: GlobalVariables.primaryColor,
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                            height:
                                cardNoSizedBoxHeight(cardHeight(screenHeight))),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            cardNumberEnding == null
                                ? Text(
                                    'Add a card below',
                                    style: GlobalVariables.bold16(
                                      context,
                                      color: Colors.black54,
                                    ),
                                  )
                                : Text(
                                    '**** $cardNumberEnding',
                                    style: GlobalVariables.bold16(
                                      context,
                                      color: Colors.black54,
                                    ),
                                  ),
                            Text(
                              formatDate(cardDetails['cardExpiry']),
                              style: GlobalVariables.bold16(
                                context,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
