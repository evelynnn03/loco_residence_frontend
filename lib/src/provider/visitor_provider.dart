import 'package:flutter/material.dart';
import 'package:loco_frontend/src/utils/resident_utils.dart';
import '../models/visitor.dart';
import '../services/visitor_service.dart';

class VisitorProvider with ChangeNotifier {
  List<Visitor> _visitors = [];
  bool _isLoading = false;

  List<Visitor> get visitors => _visitors;
  bool get isLoading => _isLoading;

  void setVisitor(List<Visitor> visitors) {
    _visitors = visitors;
    notifyListeners();
  }

  Future<void> fetchAllVisitors() async {
    _isLoading = true;
    notifyListeners();

    try {
      _visitors = await VisitorService().getAllVisitors(temporaryResidentId);
      print('Visitors: $_visitors');
    } catch (e) {
      print('Error fetching visitors: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> registerVisitor(
      String fullName,
      String hpNumber,
      String carPlateNo,
      DateTime checkInDate,
      String purpose,
      int residentId,
      BuildContext context) async {
    _isLoading = true;
    notifyListeners();

    try {
      // Register the visitor and get the list of visitors as a result
      final List<Visitor> newVisitors = await VisitorService().registerVisitor(
          fullName,
          hpNumber,
          carPlateNo,
          checkInDate,
          purpose,
          residentId,
          context);

      if (newVisitors.isNotEmpty) {
        // Add the new visitors to the list of visitors
        _visitors.addAll(newVisitors);

        print('New visitor registered: $newVisitors');
      }
    } catch (e) {
      print('Error registering visitor: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> checkInVisitor(int visitorId) async {
    _isLoading = true;
    notifyListeners();

    try {
      await VisitorService().checkInVisitor(visitorId);

      // Update the visitor's check-in status in the local list
      final index = _visitors.indexWhere((v) => v.id == visitorId);
      if (index != -1) {
        // Create a copy of the visitor with updated check-in time
        final updatedVisitor = _visitors[index].copyWith(
          checkInTime: DateTime.now(), // Using DateTime directly
        );
        _visitors[index] = updatedVisitor;
        print('Visitor checked in at: ${updatedVisitor.checkInTime}');
      }
    } catch (e) {
      print('Error checking in visitor: $e');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> checkOutVisitor(int visitorId) async {
    _isLoading = true;
    notifyListeners();

    try {
      await VisitorService().checkOutVisitor(visitorId);

      // Update the visitor's check-out status in the local list
      final index = _visitors.indexWhere((v) => v.id == visitorId);
      if (index != -1) {
        final now = DateTime.now();

        // Create a copy of the visitor with updated check-out time and date
        final updatedVisitor = _visitors[index].copyWith(
          checkOutTime: now, // Using DateTime for time
          checkOutDate: now, // Using DateTime for date
        );
        _visitors[index] = updatedVisitor;
        print('Visitor checked out at: ${updatedVisitor.checkOutTime}');
      }
    } catch (e) {
      print('Error checking out visitor: $e');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Helper method to get visitor by ID
  Visitor? getVisitorById(int id) {
    try {
      return _visitors.firstWhere((visitor) => visitor.id == id);
    } catch (e) {
      return null;
    }
  }
}
