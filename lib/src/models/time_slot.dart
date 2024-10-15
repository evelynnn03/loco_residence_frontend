class TimeSlot {
  final int? id;
  final String startTime;
  final String endTime;

  TimeSlot({
    this.id,
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
    return {
      'id': id,
      'start_time': startTime,
      'end_time': endTime,
    };
  }

  @override
  String toString() {
    return 'Time Slot $id: $startTime - $endTime';
  }

  TimeSlot copyWith({
    int? id,
    String? startTime,
    String? endTime,
  }) {
    return TimeSlot(
      id: id ?? this.id,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
    );
  }
}
