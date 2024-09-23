import 'package:flutter/material.dart';
import 'package:loco_frontend/src/models/time_slot.dart';
import 'package:loco_frontend/src/services/booking_service.dart';

class BookingProvider with ChangeNotifier {
  final List<TimeSlot> _timeSlots = [];

  List<TimeSlot> get timeSlots => _timeSlots;

// Method to set time slot details
  void setTimeSlotDetails(List<TimeSlot> slots) {
    _timeSlots
        .clear(); // Clear the previous list if you want to replace the data
    _timeSlots.addAll(slots); // Add the new time slots
    notifyListeners(); // Notify listeners about the change
  }

  // Method to fetch time slot details asynchronously
  Future<void> fetchTimeSlotDetails(int facilityId, String date) async {
    try {
      final timeSlotList =
          await BookingService().getTimeSlots(facilityId, date);
      setTimeSlotDetails(timeSlotList); // Update time slots after fetching

      if (_timeSlots.isEmpty) {
        print('No time slots available');
      } else {
        print('Available Time Slots:');
        for (var slot in _timeSlots) {
          print('Start: ${slot.startTime}');
        }
      }
    } catch (error) {
      // Handle any error, you can log or show a message
      print("Error fetching time slots: $error");
    }
  }
}
