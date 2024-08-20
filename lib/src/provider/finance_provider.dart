import 'package:flutter/material.dart';
import 'package:loco_frontend/src/services/finance_service.dart';

class Financeprovider with ChangeNotifier {
  final Map<String, String> cardDetailsToShow = {
    'cardNo': '',
    'cardType': '',
    'cardExpiry': '',
    'cardCvv': '',
    'cardName': '',
  };

  Map<String, String> get cardDetails => cardDetailsToShow;

  void setCardDetails(Map<String, String> details) {
    cardDetailsToShow['cardNo'] = details['cardNo']!;
    cardDetailsToShow['cardType'] = details['cardType']!;
    cardDetailsToShow['cardExpiry'] = details['cardExpiry']!;
    cardDetailsToShow['cardCvv'] = details['cardCvv']!;
    cardDetailsToShow['cardName'] = details['cardName']!;
    notifyListeners();
  }

  fetchCardDetails(int residentId) async {
    final card = await FinanceService().getCardDetails(residentId);
    final cardDetails = {
      'cardNo': card.cardNo,
      'cardType': card.cardType,
      'cardExpiry': card.cardExpiry.toString(),
      'cardCvv': card.cardCvv,
      'cardName': card.cardName,
    };
    setCardDetails(cardDetails);
  }
}
