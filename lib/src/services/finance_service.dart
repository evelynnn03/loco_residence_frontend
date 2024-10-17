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
        throw Exception('No card found');
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

  Future<void> updateCardDetails(
      int residentId, Map<String, String> updatedDetails) async {
    try {
      // Use PUT for full update or PATCH for partial update
      final response = await http.post(
        Uri.parse('${apiPath}finances/cards/create_update/$residentId/'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json', // Always expect a JSON response
        },
        body:
            jsonEncode(updatedDetails), // Send the updated card details as JSON
      );

      if (response.statusCode == 200) {
        print('Card details updated successfully');
      } else if (response.statusCode == 201) {
        print('Card created successfully');
      } else {
        print(
            'Failed to create/update card details. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        throw Exception('Failed to create/update card details');
      }
    } catch (e) {
      // Catch and handle any errors that may occur
      print('Error occurred while creating/updating card details: $e');
      throw Exception('Failed to create/update card details: $e');
    }
  }

  Future<void> deleteCard(int cardId) async {
    try {

      final response = await http.delete(
        Uri.parse('${apiPath}finances/delete_card/$cardId'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> res = json.decode(response.body);

        final String message = res['message'];
        final deletedCard = res['deleted_card'];
        final int cardId = deletedCard['id'];
        final String cardNo = deletedCard['card_no'];

        print('Card #$cardId - $cardNo, deleted successfully.');
        print('Message from server: $message');
      } else {
        print(
            'Failed to delete card: ${response.statusCode}, Response: ${response.body}');
        throw Exception('Failed to delete card');
      }
    } catch (e) {
      print('Error occurred: $e');
      throw Exception('Failed to delete card: $e');
    }
  }
}
