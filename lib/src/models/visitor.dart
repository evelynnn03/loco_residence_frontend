class Visitor {
  final int id;
  final int residentId;
  final String fullName;
  final String hpNumber;
  final DateTime checkInDate;
  final DateTime? checkInTime;
  final DateTime? checkOutDate;
  final DateTime? checkOutTime;
  final String carPlateNo;
  final String? parkingNumber;
  final String purpose;

  Visitor({
    required this.id,
    required this.residentId,
    required this.fullName,
    required this.hpNumber,
    required this.checkInDate,
    this.checkInTime,
    this.checkOutDate,
    this.checkOutTime,
    required this.carPlateNo,
    this.parkingNumber,
    required this.purpose,
  });

  // Factory method to create a Visitor instance from JSON
  factory Visitor.fromJson(Map<String, dynamic> json) {
    DateTime parseDateOnly(String dateString) {
      try {
        // Parse as DateTime and then extract only the date
        return DateTime.parse(dateString).toLocal();
      } catch (e) {
        print('Error parsing date: $dateString');
        return DateTime.now();
      }
    }

    DateTime? parseTimeOnly(String? timeString) {
      try {
        if (timeString == null) return null;

        // Parse the time string assuming it's in "HH:mm:ss" format.
        final timeParts = timeString.split(":").map(int.parse).toList();
        final now = DateTime.now();
        return DateTime(now.year, now.month, now.day, timeParts[0],
            timeParts[1], timeParts[2]);
      } catch (e) {
        print('Error parsing time: $timeString');
        return null;
      }
    }

    return Visitor(
      id: json['id'],
      residentId: json['resident'],
      fullName: json['full_name'],
      hpNumber: json['hp_number'],
      checkInDate: parseDateOnly(
          json['check_in_date'] ?? DateTime.now().toIso8601String()),
      checkInTime: parseTimeOnly(json['check_in_time']),
      checkOutDate: json['check_out_date'] != null
          ? parseDateOnly(json['check_out_date'])
          : null,
      checkOutTime: parseTimeOnly(json['check_out_time']),
      carPlateNo: json['car_plate_no'],
      parkingNumber: json['Parking Number'],
      purpose: json['purpose_of_visit'],
    );
  }

  // Method to convert Visitor object to JSON
  Map<String, dynamic> toJson() {
    String formatDateOnly(DateTime date) =>
        '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

    String formatTimeOnly(DateTime time) =>
        '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}:${time.second.toString().padLeft(2, '0')}';

    return {
      'id': id,
      'resident': residentId,
      'full_name': fullName,
      'hp_number': hpNumber,
      'check_in_date': formatDateOnly(checkInDate),
      'check_in_time':
          checkInTime != null ? formatTimeOnly(checkInTime!) : null,
      'check_out_date':
          checkOutDate != null ? formatDateOnly(checkOutDate!) : null,
      'check_out_time':
          checkOutTime != null ? formatTimeOnly(checkOutTime!) : null,
      'car_plate_no': carPlateNo,
      'parking_number': parkingNumber,
      'purpose_of_visit': purpose,
    };
  }

  @override
  String toString() {
    return 'Visitor $id - $fullName\nPhone: $hpNumber\nCheck-in Date & Time: $checkInDate, ${checkInTime ?? 'N/A'}\n'
        'Check-out Date & Time: ${checkOutDate ?? 'N/A'}, ${checkOutTime ?? 'N/A'}\n'
        'Car Plate: $carPlateNo\nParking No.: ${parkingNumber ?? 'N/A'}\n'
        'Purpose: $purpose\nResident ID: $residentId';
  }

  Visitor copyWith({
    int? id,
    int? residentId,
    String? fullName,
    String? phoneNo,
    DateTime? checkInDate,
    DateTime? checkInTime,
    DateTime? checkOutDate,
    DateTime? checkOutTime,
    String? carPlate,
    String? parkingNumber,
    String? purpose,
  }) {
    return Visitor(
      id: id ?? this.id,
      residentId: residentId ?? this.residentId,
      fullName: fullName ?? this.fullName,
      hpNumber: phoneNo ?? hpNumber,
      checkInDate: checkInDate ?? this.checkInDate,
      checkInTime: checkInTime ?? this.checkInTime,
      checkOutDate: checkOutDate ?? this.checkOutDate,
      checkOutTime: checkOutTime ?? this.checkOutTime,
      carPlateNo: carPlate ?? carPlateNo,
      parkingNumber: parkingNumber ?? this.parkingNumber,
      purpose: purpose ?? this.purpose,
    );
  }
}
