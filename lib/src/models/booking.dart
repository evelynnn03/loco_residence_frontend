class Booking {
  final int? id;
  final int residentId;
  final int sectionId;
  final int timeSlotId;
  final String bookingDate;
  final String bookingStatus;
  final String startTime;
  final String endTime;

  Booking({
    this.id,
    required this.residentId,
    required this.sectionId,
    required this.timeSlotId,
    required this.bookingDate,
    required this.bookingStatus,
    required this.startTime,
    required this.endTime,
  });

  //to receive bookings, show the start and end time
  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['id'],
      residentId: json['resident'],
      sectionId: json['section'],
      timeSlotId: json['time_slot']
          ['id'], // Extract the id from the time_slot object
      startTime: json['time_slot']
          ['start_time'], // Extract the start_time from the time_slot object
      endTime: json['time_slot']
          ['end_time'], // Extract the end_time from the time_slot object
      bookingDate: json['booking_date'],
      bookingStatus: json['booking_status'],
    );
  }

  //to make booking, no need start and end time
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'resident': residentId,
      'section': sectionId,
      'time_slot': {'id': timeSlotId}, 
      'booking_date': bookingDate,
      'booking_status': bookingStatus,

    };
  }

  @override
  String toString() {
    return 'Booking #$id for Resident $residentId:\nFacility Section: $sectionId,\nTime slot: $timeSlotId,\nStart Time: $startTime, \nEnd Time: $endTime \nBooking Date: $bookingDate,\nBooking status: $bookingStatus';
  }

  Booking copyWith({
    int? id,
    int? residentId,
    int? sectionId,
    int? timeSlotId,
    String? bookingDate,
    String? bookingStatus,
    String? startTime,
    String? endTime,
  }) {
    return Booking(
      id: id ?? this.id,
      residentId: residentId ?? this.residentId,
      sectionId: sectionId ?? this.sectionId,
      timeSlotId: timeSlotId ?? this.timeSlotId,
      bookingDate: bookingDate ?? this.bookingDate,
      bookingStatus: bookingStatus ?? this.bookingStatus,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
    );
  }
}
