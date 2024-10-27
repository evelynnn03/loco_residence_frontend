import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:loco_frontend/src/constants/api_path.dart';
import 'package:loco_frontend/src/provider/visitor_provider.dart';
import 'package:provider/provider.dart';
import '../models/visitor.dart';

class VisitorService {
  Future<List<Visitor>> getAllVisitors({
    required String userType,
    int? residentId,
  }) async {
    try {
      // Construct the appropriate URL based on user type and resident ID
      final String endpoint =
          userType.toLowerCase() == 'resident' && residentId != null
              ? '${apiPath}visitors/view_all_visitors/$residentId'
              : '${apiPath}visitors/view_all_visitors';

      // Validate resident ID is provided for resident users
      if (userType.toLowerCase() == 'resident' && residentId == null) {
        throw Exception('Resident ID is required for resident users');
      }

      final response = await http.get(
        Uri.parse(endpoint),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> res = json.decode(response.body);
        final List<Visitor> visitorList = res
            .map((visitor) => Visitor.fromJson(visitor as Map<String, dynamic>))
            .toList();
        return visitorList;
      } else {
        print('Failed to load visitors: ${response.statusCode}');
        throw Exception('Failed to load visitors');
      }
    } catch (e) {
      print('Error occurred: $e');
      throw Exception('Failed to load visitors: $e');
    }
  }

  Future<List<Visitor>> registerVisitor(
      String fullName,
      String hpNumber,
      String carPlateNo,
      DateTime checkInDate,
      String purpose,
      int residentId,
      BuildContext context) async {
    try {
      // Create a new DateTime with only the date component
      final dateOnly =
          DateTime(checkInDate.year, checkInDate.month, checkInDate.day);
      final formattedDate = DateFormat('yyyy-MM-dd').format(dateOnly);

      final queryParams = {
        'full_name': fullName,
        'hp_number': hpNumber,
        'car_plate_no': carPlateNo,
        'check_in_date': formattedDate,
        'purpose_of_visit': purpose,
      };

      final response = await http.post(
        Uri.parse('${apiPath}visitors/register_visitor/$residentId/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(queryParams),
      );

      if (response.statusCode == 201) {
        final Map<String, dynamic> res = json.decode(response.body);

        if (res.containsKey('message') &&
            res['message'] == 'Visitor registered successfully') {
          if (res.containsKey('visitor')) {
            final Visitor visitor =
                Visitor.fromJson(res['visitor'] as Map<String, dynamic>);

            Provider.of<VisitorProvider>(context, listen: false)
                .setVisitor([visitor]);

            return [visitor];
          } else {
            print('No visitor details found in the response.');
            return [];
          }
        } else {
          print('Unexpected response: ${response.body}');
          return [];
        }
      } else {
        print(
            'Failed to register: ${response.statusCode}, Response: ${response.body}');
        throw Exception('Failed to register visitor');
      }
    } catch (e) {
      print('Error occurred: $e');
      throw Exception('Failed to register visitor: $e');
    }
  }

  // update check-in time
  Future<Visitor> checkInVisitor(int visitorId) async {
    try {
      final response = await http.post(
        Uri.parse('${apiPath}visitors/check_in_visitor/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'visitor_id': visitorId}),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        if (data['message'] == 'Visitor checked in successfully') {
          return Visitor.fromJson(data['visitor']);
        } else {
          throw Exception(data['error'] ?? 'Unknown error occurred');
        }
      } else if (response.statusCode == 400) {
        final Map<String, dynamic> error = json.decode(response.body);
        throw Exception(error['error']);
      } else if (response.statusCode == 404) {
        throw Exception('Visitor not found');
      } else {
        throw Exception('Failed to check in visitor');
      }
    } catch (e) {
      throw Exception('Failed to check in visitor: $e');
    }
  }

  // Update check-out visitor
  Future<Visitor> checkOutVisitor(int visitorId) async {
    try {
      final response = await http.post(
        Uri.parse('${apiPath}visitors/check_out_visitor/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'visitor_id': visitorId}),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        if (data['message'] == 'Visitor checked out successfully') {
          return Visitor.fromJson(data['visitor']);
        } else {
          throw Exception(data['error'] ?? 'Unknown error occurred');
        }
      } else if (response.statusCode == 400) {
        final Map<String, dynamic> error = json.decode(response.body);
        throw Exception(error['error']);
      } else if (response.statusCode == 404) {
        throw Exception('Visitor not found');
      } else {
        throw Exception('Failed to check out visitor');
      }
    } catch (e) {
      throw Exception('Failed to check out visitor: $e');
    }
  }
}
