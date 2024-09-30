import 'package:flutter/material.dart';
import 'package:loco_frontend/src/models/time_slot.dart';
import 'package:loco_frontend/src/services/booking_service.dart';

import '../models/facility_sections.dart';

class BookingProvider with ChangeNotifier {
  List<TimeSlot> _timeSlots = [];
  List<FacilitySections> _facilitySections = [];

  List<TimeSlot> get timeSlots => _timeSlots;
  List<FacilitySections> get facilitySections => _facilitySections;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  fetchAvailableTimeSlots(String facilityId, String date) async {
    _isLoading = true;
    notifyListeners();

    try {
      _timeSlots =
          await BookingService().getAvailableTimeSlots(facilityId, date);
      print('Time Slots: $_timeSlots');
    } catch (e) {
      print('Error fetching available time slots: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  fetchFacilitySections(String facilityId, String date, List<String> timeSlots) async {
    _isLoading = true;
    notifyListeners();
     try {
      _facilitySections =
          await BookingService().getFacilitiesSections(facilityId, date, timeSlots);
      print('Facility Sections: $_facilitySections');
    } catch (e) {
      print('Error fetching facility sections: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
