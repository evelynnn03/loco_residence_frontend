class Visitor {
  final int? id;
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
    this.id,
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
    return Visitor(
      id: json['id'],
      residentId: json['resident'],
      fullName: json['full_name'],
      hpNumber: json['hp_number'],
      checkInDate: json['check_in_date'] != null
          ? DateTime.parse(json['check_in_date'])
          : DateTime.now(),
      checkInTime: json['check_in_time'] != null
          ? DateTime.parse(json['check_in_time'])
          : null,
      checkOutDate: json['check_out_date'] != null
          ? DateTime.parse(json['check_out_date'])
          : null,
      checkOutTime: json['check_out_time'] != null
          ? DateTime.parse(json['check_out_time'])
          : null,
      carPlateNo: json['car_plate_no'],
      parkingNumber: json['Parking Number'],
      purpose: json['purpose_of_visit'],
    );
  }

  // Method to convert Visitor object to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'resident': residentId,
      'full_name': fullName,
      'hp_number': hpNumber,
      'check_in_date': checkInDate.toIso8601String(),
      'check_in_time': checkInTime?.toIso8601String(),
      'check_out_date': checkOutDate?.toIso8601String(),
      'check_out_time': checkOutTime?.toIso8601String(),
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
        'Purpose: $purpose';
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
