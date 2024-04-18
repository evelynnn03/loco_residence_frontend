class Visitor {
  final String fullName;
  final String checkInDate;
  final String checkInTime;
  final String checkOutDate;
  final String checkOutTime;
  final String carPlate;
  final String parkingNumber;
  final String unitNo;
  final String phoneNo;

  Visitor({
    required this.fullName,
    required this.checkInDate,
    required this.checkInTime,
    required this.checkOutDate,
    required this.checkOutTime,
    required this.carPlate,
    required this.parkingNumber,
    required this.unitNo,
    required this.phoneNo,
  });

  factory Visitor.fromMap(Map<String, dynamic> data) {
    return Visitor(
        fullName: data['Full Name'] ?? '',
        checkInDate: data['Check-in Date'] ?? '',
        checkInTime: data['Check-in Time'] ?? '',
        checkOutDate: data['Check-out Date'] ?? '',
        checkOutTime: data['Check-out Time'] ?? '',
        carPlate: data['Car Plate'] ?? '',
        parkingNumber: data['Parking Number'] ?? '',
        unitNo: data['Unit No'] ?? '',
        phoneNo: data['Phone Number'] ?? '');
  }

  Map<String, dynamic> toMap() {
    return {
      'Full Name': fullName,
      'Check-in Date': checkInDate,
      'Check-in Time': checkInTime,
      'Check-out Date': checkOutDate,
      'Check-out Time': checkOutTime,
      'Car Plate': carPlate,
      'Parking Number': parkingNumber,
      'Phone Number': phoneNo,
      'Unit No': unitNo
    };
  }
}
