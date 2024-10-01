import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:loco_frontend/src/constants/api_path.dart';
import 'package:loco_frontend/src/models/facility_sections.dart';
import '../models/time_slot.dart';

class BookingService {
  Future<List<TimeSlot>> getAvailableTimeSlots(
      String facilityId, String date) async {
    try {
      final response = await http.get(
        Uri.parse('${apiPath}bookings/available_time_slots').replace(
          queryParameters: {
            'facility_id': facilityId,
            'date': date,
          },
        ),
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

  // Future<List<FacilitySections>> getFacilitiesSections(
  //     String facilityId, String date, List<String> timeSlots) async {
  //   try {
  //     final response = await http.get(
  //       Uri.parse('${apiPath}bookings/available_facility_sections').replace(
  //         queryParameters: {
  //           'facility_id': facilityId,
  //           'date': date,
  //           'time_slots': timeSlots,
  //         },
  //       ),
  //     );
  //     print('Facility ID: $facilityId, Date: $date, Time Slots: $timeSlots');

  //     if (response.statusCode == 200) {
  //       final List<dynamic> res = json.decode(response.body);
  //       final List<FacilitySections> sectionList = res
  //           .map((facilitySection) => FacilitySections.fromJson(
  //               facilitySection as Map<String, dynamic>))
  //           .toList();
  //       return sectionList;
  //     } else {
  //       print('Failed to load: ${response.statusCode}');
  //       throw Exception('Failed to load facility sections');
  //     }
  //   } catch (e) {
  //     print('Error occurred: $e'); // Log the error
  //     throw Exception('\nFailed to load facility sections: $e');
  //   }
  // }

  Future<List<FacilitySections>> getFacilitiesSections(
      String facilityId, String date, List<String> timeSlots) async {
    try {
      // Construct the query parameters, repeating the 'time_slots' key for each entry in the list
      final queryParams = {
        'facility_id': facilityId,
        'date': date,
        // Repeat 'time_slots' for each entry
        ...Map.fromIterable(timeSlots,
            key: (v) => 'time_slots', value: (v) => v),
      };

      final response = await http.get(
        Uri.parse('${apiPath}bookings/available_facility_sections').replace(
          queryParameters: queryParams,
        ),
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
}
