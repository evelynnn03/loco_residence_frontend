import 'dart:convert';

class TimeSlot {
  final int id;
  final String startTime;
  final String endTime;

  TimeSlot({
    required this.id,
    required this.startTime,
    required this.endTime,
  });

  // Factory method to create a Booking from a JSON map
  factory TimeSlot.fromJson(Map<String, dynamic> json) {
    return TimeSlot(
      id: json['id'],
      startTime: json['start_time'],
      endTime: json['end_time'],
    );
  }

  // Method to convert Booking to JSON map
  Map<String, dynamic> toJson() {
    return {'id': id, 'start_time': startTime, 'end_time': endTime};
  }

  // Static method to parse a list of bookings from JSON
  static List<TimeSlot> listFromJson(String str) {
    final jsonData = json.decode(str) as List<dynamic>;
    return jsonData
        .map((json) => TimeSlot.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  // Method to convert a list of bookings to JSON
  static String listToJson(List<TimeSlot> bookings) {
    final jsonData = bookings.map((booking) => booking.toJson()).toList();
    return json.encode(jsonData);
  }
}
