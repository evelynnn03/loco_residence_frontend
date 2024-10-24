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
      final updatedVisitor = await VisitorService().checkInVisitor(visitorId);
      final index = _visitors.indexWhere((v) => v.id == visitorId);
      if (index != -1) {
        _visitors[index] = updatedVisitor;
      }
      print('Visitor checked in: $updatedVisitor');
    } catch (e) {
      print('Error checking in visitor: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> checkOutVisitor(int visitorId) async {
    _isLoading = true;
    notifyListeners();

    try {
      final updatedVisitor = await VisitorService().checkOutVisitor(visitorId);
      final index = _visitors.indexWhere((v) => v.id == visitorId);
      if (index != -1) {
        _visitors[index] = updatedVisitor;
      }
      print('Visitor checked out: $updatedVisitor');
    } catch (e) {
      print('Error checking out visitor: $e');
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
