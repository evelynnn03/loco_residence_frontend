import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:loco_frontend/src/constants/api_path.dart';
import '../models/time_slot.dart';

class TimeSlotService {
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
}
