import 'package:flutter/material.dart';
import 'package:loco_frontend/src/models/time_slot.dart';
import 'package:loco_frontend/src/services/timeSlot_service.dart';

class TimeSlotProvider with ChangeNotifier {
  List<TimeSlot> _timeSlots = [];

  List<TimeSlot> get timeSlots => _timeSlots;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  fetchAvailableTimeSlots(String facilityId, String date) async {
    _isLoading = true;
    notifyListeners();

    try {
      _timeSlots =
          await TimeSlotService().getAvailableTimeSlots(facilityId, date);
      print('Time Slots: $_timeSlots');
    } catch (e) {
      print('Error fetching available time slots: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
