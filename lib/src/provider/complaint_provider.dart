import 'dart:io';

import 'package:flutter/material.dart';
import 'package:loco_frontend/src/models/similar_complaint.dart';
import 'package:loco_frontend/src/utils/resident_utils.dart';
import '../models/complaint.dart';
import '../services/complaint_service.dart';

class ComplaintProvider with ChangeNotifier {
  List<Complaint> _allComplaints = [];
  List<Complaint> _residentComplaints = [];
  bool _isLoading = false;
  String? _error;

  List<Complaint> get complaints => _allComplaints;
  List<Complaint> get residentComplaints => _residentComplaints;
  bool get isLoading => _isLoading;
  String? get error => _error;

  void setComplaints(List<Complaint> complaints) {
    _allComplaints = complaints;
    notifyListeners();
  }

  void _setError(String? error) {
    _error = error;
    notifyListeners();
  }

  Future<void> fetchResidentComplaints() async {
    _isLoading = true;
    notifyListeners();

    try {
      _residentComplaints =
          await ComplaintService().getResidentComplaints(temporaryResidentId);
      print('Complaints: $_residentComplaints');
    } catch (e) {
      print('Error fetching complaints: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchAllComplaints() async {
    _isLoading = true;
    notifyListeners();

    try {
      _allComplaints =
          await ComplaintService().getAllComplaints(temporaryResidentId);
      print('Complaints: $_allComplaints');
    } catch (e) {
      print('Error fetching complaints: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<Map<String, dynamic>> createComplaint(
    String title,
    String description,
    String category,
    DateTime date,
    File? image,
    bool isForce,
  ) async {
    _isLoading = true;
    _setError(null);
    notifyListeners();

    try {
      final res = await ComplaintService().createComplaint(
        temporaryResidentId,
        title,
        description,
        category,
        date,
        image,
        isForce,
      );

      //if there is similar complaints
      if (res is List<SimilarComplaint>) {
        return {
          'success': false,
          'error': 'Similar complaints already exist',
          'similarComplaints': res,
        };
      }
      
      if (res is String) {
          return {
          'success': true,
          'message': res,
          
        };
      }

      // Case 3: Unexpected response type
      throw Exception('Unexpected response type from server');
    } catch (e) {
      String errorMessage = e.toString();

      // Extract the error message from the exception
      if (errorMessage.contains('Exception: ')) {
        errorMessage = errorMessage.split('Exception: ')[1];
      }

      _setError(errorMessage);
      print('Error creating complaint: $errorMessage');
      return {'success': false, 'error': errorMessage};
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
