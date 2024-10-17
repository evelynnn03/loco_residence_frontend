import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loco_frontend/guard/widget/pop_up_window.dart';
import 'package:loco_frontend/src/widgets/card.dart';
import 'package:loco_frontend/src/widgets/horizontal_tiles.dart';
import '../../provider/finance_provider.dart';
import '../../constants/global_variables.dart';
import 'package:provider/provider.dart';
import '../../../config/themes/theme_provider.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});
  static const String routeName = '/payment_screen';

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    const int residentId = 1;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchCardDetails(residentId);
      Provider.of<FinanceProvider>(context, listen: false)
          .fetchInvoices(residentId);
    });
  }

  // Define an async method to fetch the card details
  Future<void> _fetchCardDetails(int residentId) async {
    final financeProvider =
        Provider.of<FinanceProvider>(context, listen: false);

    // Await the fetchCardDetails method
    await financeProvider.fetchCardDetails(residentId);
  }

  @override
  Widget build(BuildContext context) {
    final mode = Provider.of<ThemeProvider>(context);
    final cardDetails = Provider.of<FinanceProvider>(context).cardDetails;
    final screenHeight = MediaQuery.of(context).size.height;
    double sizedBoxHeight(double height) => height < 600 ? 20 : 25;

    // Get the last 4 digits of the card number, if available
    String? cardNumberEnding = cardDetails['cardNo']?.isNotEmpty == true
        ? cardDetails['cardNo']!.substring(cardDetails['cardNo']!.length - 4)
        : null; // Use null if no card number is available

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Payment',
          style: GlobalVariables.appbarStyle(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const CardContainer(),
            Padding(
              padding: const EdgeInsets.only(top: 25.0),
              child: Column(
                children: [
                  const HorizontalTiles(
                    title: 'Payment Details',
                    icon: Icons.arrow_circle_right_outlined,
                    routeName: '/payment_details',
                  ),
                  SizedBox(height: sizedBoxHeight(screenHeight)),
                  HorizontalTiles(
                    title: 'Card Settings',
                    icon: Icons.expand_more_rounded,
                    isDropdown: true,
                    dropdownHeight: screenHeight < 600 ? 350 : 400,
                    children: [
                      SizedBox(height: sizedBoxHeight(screenHeight)),
                      if (cardDetails.isNotEmpty &&
                          cardNumberEnding != null) ...[
                        HorizontalTiles(
                          title: '•••• $cardNumberEnding',
                          icon: IconButton(
                            icon: Icon(
                              Icons.delete,
                              color: GlobalVariables.white,
                              size: GlobalVariables.responsiveIconSize(
                                  context, 32),
                            ),
                            onPressed: () {
                              Popup(
                                title: 'Delete Card?',
                                content: const Text(
                                  'Are you sure you want to\ndelete this card?',
                                  style: TextStyle(color: Colors.black),
                                  textAlign: TextAlign.center,
                                ),
                                buttons: [
                                  ButtonConfig(
                                    text: 'Yes',
                                    onPressed: () async {
                                      final financeProvider =
                                          Provider.of<FinanceProvider>(context,
                                              listen: false);
                                      final cardId = financeProvider.cardId;
                                      print('Card id: $cardId');

                                      if (cardId != null) {
                                        try {
                                          await financeProvider
                                              .deleteCard(cardId);
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                'Card deleted successfully',
                                              ),
                                            ),
                                          );
                                          Navigator.of(context).pop();
                                        } catch (e) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                'Error deleting card: $e',
                                              ),
                                            ),
                                          );
                                        }
                                      } else {
                                        // Handle the case where cardId is null, e.g., show an error
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              'No card ID found to delete',
                                            ),
                                          ),
                                        );
                                      }
                                    },
                                  ),
                                  ButtonConfig(
                                      text: 'Cancel',
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      })
                                ],
                              ).show(context);
                            },
                          ),
                          tileColor: GlobalVariables.primaryColor,
                          textColor: GlobalVariables.white,
                          iconSize:
                              GlobalVariables.responsiveIconSize(context, 35),
                        ),
                        SizedBox(height: sizedBoxHeight(screenHeight)),
                      ],
                      HorizontalTiles(
                        title: 'Card Details',
                        icon: Icons.credit_card,
                        routeName: '/card_details',
                        tileColor: GlobalVariables.primaryColor,
                        textColor: GlobalVariables.white,
                        iconSize:
                            GlobalVariables.responsiveIconSize(context, 35),
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
}
