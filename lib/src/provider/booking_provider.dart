import 'package:flutter/material.dart';
import 'package:loco_frontend/src/models/time_slot.dart';
import 'package:loco_frontend/src/services/booking_service.dart';

import '../models/booking.dart';
import '../models/facility_sections.dart';

class BookingProvider with ChangeNotifier {
  List<TimeSlot> _timeSlots = [];
  List<FacilitySections> _facilitySections = [];
  List<Booking> _bookings = [];


  List<int> get facilitySectionIds => _facilitySections.map((section) => section.id).toList();
  List<String> get facilitySectionNames => _facilitySections.map((section) => section.sectionName).toList();
  List<TimeSlot> get timeSlots => _timeSlots;
  List<FacilitySections> get facilitySections => _facilitySections;
  List<Booking> get bookings => _bookings;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void setBookings(List<Booking> bookings) {
    _bookings = bookings;
    notifyListeners();
  }

  Future<void> fetchAvailableTimeSlots(String facilityId, String date) async {
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

// In BookingProvider class
  Future<void> fetchFacilitySections(
      String facilityId, String date, List<String> timeSlots) async {
    print(
        "2. fetchFacilitySections called with facilityId: $facilityId, date: $date, timeSlots: $timeSlots");
    _isLoading = true;
    notifyListeners();
    try {
      _facilitySections = await BookingService()
          .getFacilitiesSections(facilityId, date, timeSlots);
      print("3. Facility Sections fetched: $_facilitySections");
      notifyListeners();
    } catch (e) {
      print("4. Error fetching facility sections: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> bookFacilitySections(String facilityId, String date,
      List<String> timeSlots, String sectionId, BuildContext context) async {
    _isLoading = true;
    notifyListeners(); // Notify listeners that loading state has changed

    try {
      // Call the BookingService and pass the context to update the provider
      _bookings = await BookingService().bookFacilitySection(
          facilityId, date, timeSlots, sectionId, context); // Pass context here

      print('Booking Details: $_bookings');
      notifyListeners(); // Notify listeners to update UI after the booking is fetched
    } catch (e) {
      print('Error booking facility section: $e');
    } finally {
      _isLoading = false;
      notifyListeners(); // Notify listeners that loading state has changed
    }
  }
}
