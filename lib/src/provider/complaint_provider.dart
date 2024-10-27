import 'package:flutter/material.dart';
import 'package:loco_frontend/src/utils/resident_utils.dart';
import '../models/complaint.dart';
import '../services/complaint_service.dart';

class ComplaintProvider with ChangeNotifier {
  List<Complaint> _complaints = [];
  bool _isLoading = false;

  
  List<Complaint> get complaints => _complaints;
  bool get isLoading => _isLoading;

  void setComplaints(List<Complaint> complaints) {
    _complaints = complaints;
    notifyListeners();
  }

  Future<void> fetchComplaints() async {
    _isLoading = true;
    notifyListeners();

    try {
      _complaints = await ComplaintService().getComplaints(temporaryResidentId);
      print('Complaints: $_complaints');
    } catch (e) {
      print('Error fetching complaints: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> createComplaint(
    String title,
    String description,
    DateTime date,
    String? imageBase64,
  ) async {
    _isLoading = true;
    notifyListeners();

    try {
      await ComplaintService().createComplaint(
        temporaryResidentId,
        title,
        description,
        date,
        imageBase64,
      );
      notifyListeners();
    } catch (e) {
      print('Error creating complaint: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

 
}
