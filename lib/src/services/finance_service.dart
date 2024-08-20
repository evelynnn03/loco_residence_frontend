import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:loco_frontend/src/constants/api_path.dart';
import 'package:loco_frontend/src/models/card.dart';

//rmb to check what's the resident id after you seed the data
class FinanceService {
  Future<Card> getCardDetails(int residentId) async {
    try {
      final response = await http.get(Uri.parse('${apiPath}finances/card/$residentId'));
      if (response.statusCode == 200) {
        final card = Card.fromJson(json.decode(response.body));
        return card;
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
}
