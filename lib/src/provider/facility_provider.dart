import 'package:flutter/material.dart';
import '../services/facility_service.dart';
import '../models/facility.dart';

class FacilityProvider with ChangeNotifier {
  final FacilityService _facilityService = FacilityService();

  // List of facilities to manage the state
  List<Facility> _facilities = [];

  // Getter for facilities
  List<Facility> get facilities => _facilities;

  // Boolean to track loading state
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // Fetch facilities from the service
  Future<void> fetchFacilities() async {
    _isLoading = true;
    notifyListeners();

    try {
      _facilities = await _facilityService.getFacilities();
      print('Facilities: $_facilities');
    } catch (e) {
      print('Error fetching facilities: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
