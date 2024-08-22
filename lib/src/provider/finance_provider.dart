import 'package:flutter/material.dart';
import 'package:loco_frontend/src/services/finance_service.dart';

import '../models/invoice.dart';

class FinanceProvider with ChangeNotifier {
  final Map<String, String> cardDetailsToShow = {
    'cardNo': '',
    'cardType': '',
    'cardExpiry': '',
    'cardCvv': '',
    'cardName': '',
  };

  double _totalOutstandingAmount = 0.0;

  List<Invoice> _invoices = [];

  Map<String, String> get cardDetails => cardDetailsToShow;
  List<Invoice> get invoices => _invoices;
  double get totalOutstandingAmount => _totalOutstandingAmount;

  void setCardDetails(Map<String, String> details) {
    cardDetailsToShow['cardNo'] = details['cardNo']!;
    cardDetailsToShow['cardType'] = details['cardType']!;
    cardDetailsToShow['cardExpiry'] = details['cardExpiry']!;
    cardDetailsToShow['cardCvv'] = details['cardCvv']!;
    cardDetailsToShow['cardName'] = details['cardName']!;
    notifyListeners();
  }

  fetchCardDetails(int residentId) async {
    final cardList = await FinanceService().getCardDetails(residentId);
    final card = cardList.first;
    final cardDetails = {
      'cardNo': card.cardNo,
      'cardType': card.cardType,
      'cardExpiry': card.cardExpiry.toString(),
      'cardCvv': card.cardCvv,
      'cardName': card.cardName,
    };
    setCardDetails(cardDetails);
  }

  fetchInvoices(int residentId) async {
    try {
      _invoices = await FinanceService().getInvoiceDetails(residentId);
      // Calculate total outstanding amount
      for (var invoice in _invoices) {
        _totalOutstandingAmount += double.parse(invoice.amount);
      }
      notifyListeners();
    } catch (e) {
      // Handle error
      print('Error fetching invoices: $e');
    }
  }

}