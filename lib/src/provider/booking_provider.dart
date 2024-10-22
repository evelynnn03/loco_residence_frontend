import 'package:flutter/material.dart';
import 'package:loco_frontend/src/models/time_slot.dart';
import 'package:loco_frontend/src/services/booking_service.dart';
import 'package:loco_frontend/src/utils/resident_utils.dart';

import '../models/booking.dart';
import '../models/facility_sections.dart';

class BookingProvider with ChangeNotifier {
  List<TimeSlot> _timeSlots = [];
  List<FacilitySections> _facilitySections = [];
  List<Booking> _bookings = [];
  List<Booking> _resientBookings = [];
  List<int> get facilitySectionIds => _facilitySections.map((section) => section.id).toList();
  List<String> get facilitySectionNames => _facilitySections.map((section) => section.sectionName).toList();
  List<TimeSlot> get timeSlots => _timeSlots;
  List<FacilitySections> get facilitySections => _facilitySections;
  List<Booking> get bookings => _bookings;
  List<Booking> get residentBookings => _resientBookings;

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

  Future<void> fetchResidentBookings() async {
    _isLoading = true;
    notifyListeners();

    try {
      _resientBookings =
          await BookingService().getAllBookings(temporaryResidentId);
      print('Resident Bookings: $_resientBookings');
    } catch (e) {
      print('Error fetching resident bookings: $e');
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
          facilityId, date, timeSlots, sectionId, temporaryResidentId ,context); // Pass context here

      print('Booking Details: $_bookings');
      notifyListeners(); // Notify listeners to update UI after the booking is fetched
    } catch (e) {
      print('Error booking facility section: $e');
    } finally {
      _isLoading = false;
      notifyListeners(); // Notify listeners that loading state has changed
    }
  }


  Future<String> cancelBooking(int bookingId) async {
    _isLoading = true;
    notifyListeners();

    try {
      await BookingService().cancelBooking(bookingId,temporaryResidentId);
      _bookings.removeWhere((booking) => booking.id == bookingId);
      _resientBookings.removeWhere((booking) => booking.id == bookingId);
      notifyListeners();
      return 'Booking canceled successfully';  // Return success message
    } catch (e) {
      print('Error canceling booking: $e');
      return 'Error occurred while canceling booking'; // Return error message
    }
  }

}
