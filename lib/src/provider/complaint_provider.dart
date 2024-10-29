import 'dart:io';

import 'package:flutter/material.dart';
import 'package:loco_frontend/src/utils/resident_utils.dart';
import '../models/complaint.dart';
import '../services/complaint_service.dart';

class ComplaintProvider with ChangeNotifier {
  List<Complaint> _allComplaints = [];
  List<Complaint> _residentComplaints = [];
  bool _isLoading = false;

  
  List<Complaint> get complaints => _allComplaints;
  List<Complaint> get residentComplaints => _residentComplaints;
  bool get isLoading => _isLoading;

  void setComplaints(List<Complaint> complaints) {
    _allComplaints = complaints;
    notifyListeners();
  }

  Future<void> fetchResidentComplaints() async {
    _isLoading = true;
    notifyListeners();

    try {
      _residentComplaints = await ComplaintService().getResidentComplaints(temporaryResidentId);
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
      _allComplaints = await ComplaintService().getAllComplaints(temporaryResidentId);
      print('Complaints: $_allComplaints');
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
    File? image,
  ) async {
    _isLoading = true;
    notifyListeners();

    try {
      await ComplaintService().createComplaint(
        temporaryResidentId,
        title,
        description,
        date,
        image,
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
