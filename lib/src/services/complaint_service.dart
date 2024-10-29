import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:loco_frontend/src/constants/api_path.dart';
import '../models/complaint.dart';
import 'package:path/path.dart' as path;

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
    File? image,
  ) async {
    try {
      final body = {
        'title': title,
        'description': description,
        'date': date.toIso8601String(), // ISO format for consistency
      };

      var request = http.MultipartRequest(
        'POST',
        Uri.parse('${apiPath}complaints/create_complaint/$residentId/'),
      );
      request.headers.addAll({
        'Content-Type': 'application/json',
        'Accept': 'application/json', // Always expect a JSON response
      });
      request.fields.addAll(body);

      if (image != null) {
        final imageBytes = await image.readAsBytes();
        final imageFile = http.MultipartFile.fromBytes(
          'image',
          imageBytes,
          filename: path.basename(image.path),
        );
        request.files.add(imageFile);
      }

      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        print('Complaint created successfully');
      } else {
        print(
            'Failed to create complaint. Status code: ${response.statusCode}');
        print('Response body: $responseBody');
        throw Exception('Failed to create complaint');
      }
    } catch (e) {
      print('Error occurred while creating complaint: $e');
      rethrow;
    }
  }
}
