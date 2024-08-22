import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:loco_frontend/src/models/invoice.dart';
import 'package:loco_frontend/src/widgets/buttons.dart';
import 'package:provider/provider.dart';
import '../../constants/global_variables.dart';
import '../../provider/finance_provider.dart';
import '../../widgets/list_tiles.dart';

class PaymentDetails extends StatefulWidget {
  const PaymentDetails({super.key});
  static const String routeName = '/payment_details';

  @override
  State<PaymentDetails> createState() => _PaymentDetailsState();
}

class _PaymentDetailsState extends State<PaymentDetails> {
  int residentId = 8; // Hardcoded for now

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<FinanceProvider>(context, listen: false)
        .fetchInvoices(residentId);
  }

  @override
  Widget build(BuildContext context) {
    final invoiceList = Provider.of<FinanceProvider>(context).invoices;
    return DefaultTabController(
      length: 2, // invoice and history
      child: Scaffold(
        backgroundColor: GlobalVariables.backgroundColor,
        appBar: AppBar(
          backgroundColor: GlobalVariables.secondaryColor,
          title: Text(
            'Payment Details',
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color: GlobalVariables.primaryColor,
            ),
          ),
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: GlobalVariables.primaryColor,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          bottom: const TabBar(
            indicatorColor: GlobalVariables.primaryColor,
            labelColor: GlobalVariables.primaryColor,
            labelStyle: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            unselectedLabelColor: GlobalVariables.tabNotSelected,
            unselectedLabelStyle: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            tabs: [
              Tab(text: 'Invoice'),
              Tab(text: 'History'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            buildTabContent(false), // Invoice tab
            buildTabContent(true), // History tab
          ],
        ),
      ),
    );
  }

  // the header & the contents for each tab
  Widget buildTabContent(bool isHistory) {
    return Stack(
      children: [
        Column(
          children: [
            const SizedBox(height: 10),
            Container(
              color: GlobalVariables.primaryColor,
              width: double.infinity,
              height: 70,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: getHeaderTitles(isHistory),
              ),
            ),
            Expanded(
              // for the fading effect
              child: ShaderMask(
                shaderCallback: (Rect bounds) {
                  return LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent, // No effect at the top
                      Colors.white.withOpacity(1.0), // Fades to white
                    ],
                    stops: [0.5, 1.0],
                  ).createShader(bounds);
                },
                blendMode: BlendMode.dstOut,
                child: MyListTile(
                  items: isHistory ? getHistoryItems() : getInvoiceItems(),
                ),
              ),
            ),
          ],
        ),

        // button for the invoice tab (make payment button)
        if (!isHistory)
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: MyButton(
                text: 'Make Payment',
                onTap: () {
                  // Handle button tap
                },
              ),
            ),
          ),
      ],
    );
  }

  // the header for invoice/history
  List<Widget> getHeaderTitles(bool isHistory) {
    return [
      Expanded(
        child: Text(
          isHistory ? 'Date Paid' : 'Date Issued',
          style: TextStyle(
              color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
      ),
      Expanded(
        child: Text(
          isHistory ? 'Amount Paid' : 'Total',
          style: TextStyle(
              color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
      ),
      Expanded(
        child: Text(
          'Invoice No.',
          style: TextStyle(
              color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
      ),
    ];
  }

  // the contents for invoice tab
  List<Invoice> getInvoiceItems() {
    final invoiceList = Provider.of<FinanceProvider>(context).invoices;
    // Filter the invoices where status is 'unpaid'
    final unpaidInvoices =
        invoiceList.where((invoice) => invoice.status == 'unpaid').toList();
    return unpaidInvoices;
  }

  // the contents for history tab
  List<Invoice> getHistoryItems() {
    final invoiceList = Provider.of<FinanceProvider>(context).invoices;
    // Filter the invoices where status is 'paid'
    final paidInvoices =
        invoiceList.where((invoice) => invoice.status == 'paid').toList();
    return paidInvoices;
  }
}
