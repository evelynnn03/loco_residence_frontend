import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:loco_frontend/src/constants/api_path.dart';
import '../models/time_slot.dart';

class BookingService {
  Future<List<TimeSlot>> getTimeSlots(int facilityId, String date) async {
    try {
      final response = await http.get(
        Uri.parse('${apiPath}bookings/available_time_slots/'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json', // To ensure you get JSON response
        },
      );
      if (response.statusCode == 200) {
        final List<dynamic> res = json.decode(response.body);
        final List<TimeSlot> timeSlotList = res
            .map((timeSlot) =>
                TimeSlot.fromJson(timeSlot as Map<String, dynamic>))
            .toList();
        return timeSlotList;
      } else {
        print('Response status: ${response.statusCode}');
        print('Response headers: ${response.headers}');
        print('Response body: ${response.body}');
        throw Exception('Failed to get time slot details');
      }
    } catch (e) {
      throw Exception('Failed to get time slot details: $e');
    }
  }
}
