import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:loco_frontend/src/constants/api_path.dart';
import 'package:loco_frontend/src/models/card.dart';

import '../models/invoice.dart';

//rmb to check what's the resident id after you seed the data
class FinanceService {
  Future<List<Card>> getCardDetails(int residentId) async {
    try {
      final response = await http.get(
        Uri.parse('${apiPath}finances/card/$residentId'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json', // To ensure you get JSON response
        },
      );
      if (response.statusCode == 200) {
        final List<dynamic> res = json.decode(response.body);
        final List<Card> cardList = res
            .map((card) => Card.fromJson(card as Map<String, dynamic>))
            .toList();
        return cardList;
      } else {
        print('Response status: ${response.statusCode}');
        print('Response headers: ${response.headers}');
        print('Response body: ${response.body}');
        throw Exception('Failed to get card details');
      }
    } catch (e) {
      throw Exception('Failed to get card details: $e');
    }
  }

  Future<List<Invoice>> getInvoiceDetails(int residentId) async {
    try {
      final response = await http.get(
        Uri.parse('${apiPath}finances/invoice/$residentId'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json', // To ensure you get JSON response
        },
      );
      if (response.statusCode == 200) {
        final List<dynamic> res = json.decode(response.body);
        final List<Invoice> invoiceList = res
            .map((invoice) => Invoice.fromJson(invoice as Map<String, dynamic>))
            .toList();
        return invoiceList;
        
      } else {
        print('Response status: ${response.statusCode}');
        print('Response headers: ${response.headers}');
        print('Response body: ${response.body}');
        throw Exception('Failed to get invoice details');
      }
    } catch (e) {
      throw Exception('Failed to get invoice details: $e');
    }
  }
}
