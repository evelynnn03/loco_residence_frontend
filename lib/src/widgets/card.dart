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
  late String cardNumber = '';
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
    // Fetch card details and invoice details
    Provider.of<FinanceProvider>(context, listen: false)
        .fetchCardDetails(residentId);
    Provider.of<FinanceProvider>(context, listen: false)
        .fetchInvoices(residentId);
  }

  @override
  Widget build(BuildContext context) {
    final cardDetails = Provider.of<FinanceProvider>(context).cardDetails;
    final totalOutstandingAmount =
        Provider.of<FinanceProvider>(context).totalOutstandingAmount;
        //if cardDetails['cardNo'] is empty, it means the data is still loading
    final isLoading = cardDetails['cardNo'] == '';

    return Padding(
      padding: const EdgeInsets.all(25.0),
      child: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                Container(
                  height: 230,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    color: Colors.lightBlueAccent,
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
                            const Text(
                              'Outstanding Amount',
                              style: TextStyle(
                                color: Colors.black54,
                                fontSize: 16,
                              ),
                            ),
                            _buildCardLogo(),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'RM $totalOutstandingAmount',
                          style: const TextStyle(
                            color: GlobalVariables.primaryColor,
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 40),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              cardDetails['cardNo'] ?? '',
                              style: const TextStyle(
                                color: Colors.black54,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              cardDetails['cardExpiry'] ?? '',
                              style: const TextStyle(
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
                  decoration: const InputDecoration(),
                  readOnly: true,
                  initialValue: cardDetails['cardName'] ?? '',
                ),
              ],
            ),
    );
  }
}
