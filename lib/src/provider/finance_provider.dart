import 'package:flutter/material.dart';
import 'package:loco_frontend/src/services/finance_service.dart';
import 'package:loco_frontend/src/utils/resident_utils.dart';
import '../models/invoice.dart';

class FinanceProvider with ChangeNotifier {
  final Map<String, String> cardDetailsToShow = {
    'cardNo': '',
    'cardType': '',
    'cardExpiry': '',
    'cardCvv': '',
    'cardName': '',
    'residentId': '',
  };

  int? _cardId;
  double _totalOutstandingAmount = 0.0;
  List<Invoice> _invoices = [];
  bool _isLoading = false;

  Map<String, String> get cardDetails => cardDetailsToShow;
  List<Invoice> get invoices => _invoices;
  int? get cardId => _cardId;
  double get totalOutstandingAmount => _totalOutstandingAmount;
  bool get isLoading => _isLoading;

  void setCardDetails(Map<String, String> details) {
    cardDetailsToShow['cardNo'] = details['cardNo'] ?? '';
    cardDetailsToShow['cardType'] = details['cardType'] ?? '';
    cardDetailsToShow['cardExpiry'] = details['cardExpiry'] ?? '';
    cardDetailsToShow['cardCvv'] = details['cardCvv'] ?? '';
    cardDetailsToShow['cardName'] = details['cardName'] ?? '';
    cardDetailsToShow['residentId'] = details['residentId'] ?? '';
    notifyListeners();
  }

  Future<void> updateCardDetails(
      int residentId, Map<String, String> updatedDetails) async {
    _isLoading = true;
    notifyListeners();

    try {
      await FinanceService().updateCardDetails(temporaryResidentId, updatedDetails);
      setCardDetails(updatedDetails);
    } catch (e) {
      print('Error updating card details: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchCardDetails() async {
    _isLoading = true;
    notifyListeners();

    try {
      final cardList = await FinanceService().getCardDetails(temporaryResidentId);
      if (cardList.isNotEmpty) {
        final card = cardList.first;
        _cardId = card.id; // Assuming card has an 'id' property
        final cardDetails = {
          'cardNo': card.cardNo,
          'cardType': card.cardType,
          'cardExpiry': card.cardExpiry.toString(),
          'cardCvv': card.cardCvv,
          'cardName': card.cardName,
          'residentId':
              card.residentId.toString(), // Store residentId if needed
        };
        setCardDetails(cardDetails);
      } else {
        _cardId = null; // No card found
      }
    } catch (e) {
      print('Error fetching card details: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchInvoices() async {
    _isLoading = true;
    notifyListeners();

    try {
      _invoices = await FinanceService().getInvoiceDetails(temporaryResidentId);
      _totalOutstandingAmount = 0.0;
      for (var invoice in _invoices) {
        if (invoice.status.toLowerCase() == 'unpaid') {
          _totalOutstandingAmount += double.parse(invoice.amount);
        }
      }
      notifyListeners();
    } catch (e) {
      print('Error fetching invoices: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteCard(int cardId) async {
    _isLoading = true;
    notifyListeners();

    try {
      // Call the service to delete the card
      await FinanceService().deleteCard(cardId);

      // Clear the card details in the provider once it's deleted
      cardDetails.clear();

      notifyListeners();
    } catch (e) {
      print('Error deleting card: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> makePayment() async{
    _isLoading = true;
    notifyListeners();
    try {
      // Call the service to make payment
      await FinanceService().makePayment(temporaryResidentId);

      // Update the invoice status to 'paid' => assume user pay all the invoice at once
      for (var invoice in invoices) {
        if (invoice.status.toLowerCase() == 'unpaid') {
          updateInvoiceStatus(invoice.id, 'paid');
        }
      }
      _totalOutstandingAmount = 0.0; // Reset the total outstanding amount
      notifyListeners();
    } catch (e) {
      print('error making payment : $e');
    } finally {
      _isLoading = false;
    }
    
  }

  // In finance_provider.dart
  //to update invoice to 'paid'
  void updateInvoiceStatus(int invoiceId, String status) {
    final index = invoices.indexWhere((invoice) => invoice.id == invoiceId);
    if (index != -1) {
      invoices[index] = invoices[index].copyWith(status: status);
      notifyListeners();
    }
  }
}
