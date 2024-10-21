import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:loco_frontend/src/constants/api_path.dart';
import 'package:loco_frontend/src/models/booking.dart';
import 'package:loco_frontend/src/models/facility_sections.dart';
import 'package:provider/provider.dart';
import '../models/time_slot.dart';
import '../provider/booking_provider.dart';

class BookingService {
  Future<List<TimeSlot>> getAvailableTimeSlots(
      String facilityId, String date) async {
    try {
      final response = await http.post(
        Uri.parse('${apiPath}bookings/available_time_slots'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'facility_id': facilityId,
          'date': date,
        }),
      );
      print('Facility ID: $facilityId, Date: $date');

      if (response.statusCode == 200) {
        final List<dynamic> res = json.decode(response.body);
        final List<TimeSlot> timeSlotList = res
            .map((timeSlot) =>
                TimeSlot.fromJson(timeSlot as Map<String, dynamic>))
            .toList();
        return timeSlotList;
      } else {
        print('Failed to load: ${response.statusCode}');
        throw Exception('Failed to load available time slots');
      }
    } catch (e) {
      print('Error occurred: $e'); // Log the error
      throw Exception('\nFailed to load available time slots: $e');
    }
  }

  Future<List<FacilitySections>> getFacilitiesSections(
      String facilityId, String date, List<String> timeSlots) async {
    try {
      final response = await http.post(
        Uri.parse('${apiPath}bookings/available_facility_sections'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'facility_id': facilityId,
          'date': date,
          'time_slots': timeSlots,
        }),
      );

      print('Facility ID: $facilityId, Date: $date, Time Slots: $timeSlots');

      if (response.statusCode == 200) {
        final List<dynamic> res = json.decode(response.body);
        final List<FacilitySections> sectionList = res
            .map((facilitySection) => FacilitySections.fromJson(
                facilitySection as Map<String, dynamic>))
            .toList();
        return sectionList;
      } else {
        print(
            'Failed to load: ${response.statusCode}, Response: ${response.body}');
        throw Exception('Failed to load facility sections');
      }
    } catch (e) {
      print('Error occurred: $e'); // Log the error
      throw Exception('\nFailed to load facility sections: $e');
    }
  }

  // book facility section
  Future<List<Booking>> bookFacilitySection(String facilityId, String date,
      List<String> timeSlots, String sectionId, BuildContext context) async {
    try {
      final response = await http.post(
        Uri.parse('${apiPath}bookings/book_facility_section/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'facility_id': facilityId,
          'date': date,
          'time_slots': timeSlots,
          'section_id': sectionId,
        }),
      );

      if (response.statusCode == 201) {
        final Map<String, dynamic> res = json.decode(response.body);

        if (res.containsKey('message') &&
            res['message'] == 'Booking successful') {
          if (res.containsKey('bookings')) {
            final List<Booking> bookings = [];
            for (var bookingData in res['bookings']) {
              final booking =
                  Booking.fromJson(bookingData as Map<String, dynamic>);
              bookings.add(booking);
            }

            // Update provider with the new bookings
            Provider.of<BookingProvider>(context, listen: false)
                .setBookings(bookings);

            return bookings;
          } else {
            print('No booking details found in the response.');
            return [];
          }
        } else {
          print('Unexpected response: ${response.body}');
          return [];
        }
      } else {
        print(
            'Failed to book: ${response.statusCode}, Response: ${response.body}');
        throw Exception('Failed to book facility section');
      }
    } catch (e) {
      print('Error occurred: $e');
      throw Exception('Failed to book facility section: $e');
    }
  }

  //get all bookings
  Future<List<Booking>> getAllBookings() async {
    try {
      final response = await http.get(
        Uri.parse('${apiPath}bookings/get_all_bookings/'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> res = json.decode(response.body);
        final List<Booking> bookingList = res
            .map((booking) => Booking.fromJson(booking as Map<String, dynamic>))
            .toList();
        return bookingList;
      } else {
        print('Failed to load: ${response.statusCode}');
        throw Exception('Failed to load available all bookings');
      }
    } catch (e) {
      print('Error occurred: $e'); // Log the error
      throw Exception('\nFailed to load available time slots: $e');
    }
  }

  Future<void> cancelBooking(int bookingId) async {
    try {
      final response = await http.post(
        Uri.parse('${apiPath}bookings/cancel_booking/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'booking_id': bookingId,
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> res = json.decode(response.body);

        // Handle the response from the Django backend
        final String message = res['message'];
        final canceledBooking = res['canceled_booking'];
        final int bookingId = canceledBooking['id'];
        final String section = canceledBooking['section'];
        final String date = canceledBooking['date'];

        // Print or use the data as needed
        print(
            'Booking #$bookingId in $section on $date cancelled successfully.');
        print('Message from server: $message');

        // You can also show this info in a dialog or snack bar in your UI
        // Example:
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(content: Text('Booking #$bookingId cancelled successfully.')),
        // );
      } else {
        print(
            'Failed to cancel booking: ${response.statusCode}, Response: ${response.body}');
        throw Exception('Failed to cancel booking');
      }
    } catch (e) {
      print('Error occurred: $e');
      throw Exception('Failed to cancel booking: $e');
    }
  }
}
