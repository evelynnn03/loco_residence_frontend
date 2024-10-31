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

  Future<void> fetchAllVisitors({
    required String userType,
    int? residentId,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      _visitors = await VisitorService().getAllVisitors(
        userType: userType,
        residentId:
            userType.toLowerCase() == 'resident' ? temporaryResidentId : null,
      );
      
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
      final List<Visitor> newVisitors = await VisitorService().registerVisitor(
          fullName,
          hpNumber,
          carPlateNo,
          checkInDate,
          purpose,
          residentId,
          context);

      if (newVisitors.isNotEmpty) {
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

      final index = _visitors.indexWhere((v) => v.id == visitorId);
      if (index != -1) {
        final updatedVisitor = _visitors[index].copyWith(
          checkInTime: DateTime.now(),
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

      final index = _visitors.indexWhere((v) => v.id == visitorId);
      if (index != -1) {
        final now = DateTime.now();
        final updatedVisitor = _visitors[index].copyWith(
          checkOutTime: now,
          checkOutDate: now,
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

  Visitor? getVisitorById(int id) {
    try {
      print('Looking for visitor with ID: $id');
      print('Current visitors: $_visitors');
      return _visitors.firstWhere((visitor) => visitor.id == id);
    } catch (e) {
      print('Visitor not found with ID: $id');
      return null;
    }
  }
}
