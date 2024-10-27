import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:loco_frontend/src/constants/api_path.dart';
import '../models/complaint.dart';

//rmb to check what's the resident id after you seed the data
class ComplaintService {
  Future<List<Complaint>> getComplaints(int residentId) async {
    try {
      final response = await http.get(
        Uri.parse('${apiPath}complaints/view_all_complaints/$residentId'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json', // To ensure you get JSON response
        },
      );
      if (response.statusCode == 200) {
        final List<dynamic> res = json.decode(response.body);
        final List<Complaint> complaintlist = res
            .map((complaint) =>
                Complaint.fromJson(complaint as Map<String, dynamic>))
            .toList();
        return complaintlist;
      } else {
        throw Exception('No complaints found');
      }
    } catch (e) {
      throw Exception('Failed to get complaints: $e');
    }
  }

  Future<void> createComplaint(
    int residentId,
    String title,
    String description,
    DateTime date,
    String? imageBase64,
  ) async {
    try {
      final body = jsonEncode({
        'title': title,
        'description': description,
        'date': date.toIso8601String(), // ISO format for consistency
        'image': imageBase64,
      });
      // Use PUT for full update or PATCH for partial update
      final response = await http.post(
          Uri.parse('${apiPath}complaints/create_complaint/$residentId/'),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json', // Always expect a JSON response
          },
          body: body);

      if (response.statusCode == 200) {
        print('Complaint created succesfully');
      } else {
        print('Failed to create complaint. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        throw Exception('Failed to create complaint');
      }
    } catch (e) {
      // Catch and handle any errors that may occur
      print('Error occurred while creating complaint: $e');
      throw Exception('Failed to create complaint: $e');
    }
  }
}
