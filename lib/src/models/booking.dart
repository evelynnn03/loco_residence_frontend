class Booking {
  final int? id;
  final int residentId;
  final int sectionId;
  final int timeSlotId;
  final String bookingDate;
  final String bookingStatus;

  Booking({
    this.id,
    required this.residentId,
    required this.sectionId,
    required this.timeSlotId,
    required this.bookingDate,
    required this.bookingStatus,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['id'],
      residentId: json['resident'],
      sectionId: json['section'],
      timeSlotId: json['time_slot']
          ['id'], // Extract the id from the time_slot object
      bookingDate: json['booking_date'],
      bookingStatus: json['booking_status'],
    );
  }

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
    return 'Booking #$id for Resident $residentId:\nFacility Section: $sectionId,\nTime slot: $timeSlotId,\nBooking Date: $bookingDate,\nBooking status: $bookingStatus';
  }

  Booking copyWith({
    int? id,
    int? residentId,
    int? sectionId,
    int? timeSlotId,
    String? bookingDate,
    String? bookingStatus,
  }) {
    return Booking(
      id: id ?? this.id,
      residentId: residentId ?? this.residentId,
      sectionId: sectionId ?? this.sectionId,
      timeSlotId: timeSlotId ?? this.timeSlotId,
      bookingDate: bookingDate ?? this.bookingDate,
      bookingStatus: bookingStatus ?? this.bookingStatus,
    );
  }
}
