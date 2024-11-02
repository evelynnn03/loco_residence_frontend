import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:loco_frontend/src/constants/api_path.dart';
import '../models/complaint.dart';
import 'package:path/path.dart' as path;

//rmb to check what's the resident id after you seed the data
class ComplaintService {
  Future<List<Complaint>> getResidentComplaints(int residentId) async {
    try {
      final response = await http.get(
        Uri.parse('${apiPath}complaints/view_resident_complaints/$residentId'),
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

  Future<List<Complaint>> getAllComplaints(int residentId) async {
    try {
      final response = await http.get(
        Uri.parse('${apiPath}complaints/view_all_complaints'),
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
      if (title.isEmpty || description.isEmpty) {
        throw Exception('All fields are required');
      }

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
        // Validate image size (10MB limit)
        if (await image.length() > 10 * 1024 * 1024) {
          throw Exception('Image size too large. Maximum size is 10MB');
        }

        final ext = path.extension(image.path).toLowerCase();
        if (!['.jpg', '.jpeg', '.png', '.gif'].contains(ext)) {
          throw Exception(
              'Invalid image format. Supported formats: jpg, jpeg, png, gif');
        }

        final imageBytes = await image.readAsBytes();
        final imageFile = http.MultipartFile.fromBytes(
          'image',
          imageBytes,
          filename: path.basename(image.path),
        );
        request.files.add(imageFile);
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      final responseData = json.decode(response.body);

      if (response.statusCode == 200) {
        print('Complaint created successfully');
      } else {
        print(
            'Failed to create complaint. Status code: ${response.statusCode}');

        // Handle specific error messages from Django
        throw Exception(responseData['error'] ?? 'Failed to create complaint');
      }
    } catch (e) {
      throw Exception(e.toString().replaceAll('Exception: ', ''));
    }
  }
}
