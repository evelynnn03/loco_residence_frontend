import 'package:flutter/material.dart';

class ResidentParkingDetailsProvider extends ChangeNotifier {
  final List<Map<String, Object>> _residentParkingDetailsList = [];

  List<Map<String, Object>> get residentParkingDetailsList =>
      _residentParkingDetailsList;

  // Add visitor details to the list
  void addResidentDetails(Map<String, Object> details) {
    _residentParkingDetailsList.add(details);
    notifyListeners();
  }

  // Remove visitor details from the list
  void removeResidentDetails(String visitorId) {
    _residentParkingDetailsList
        .removeWhere((details) => details['visitorId'] == visitorId);
    notifyListeners();
  }

  bool containsResident(String residentId) {
    return _residentParkingDetailsList
        .any((details) => details['residentId'] == residentId);
  }

  int returnRemainingParkingLot() {
    final int parkingLots = 20 - _residentParkingDetailsList.length;
    return parkingLots;
  }

  Map<String, Object> returnResidentParkingDetailsBasedOnUnitNo(String unitNo) {
    //return the fist occurance of the visitorBased on the object, else return empty map
    Map<String, Object> result = residentParkingDetailsList.firstWhere(
      (resident) => resident['Unit No'] == unitNo,
      orElse: () => Map<String, Object>.from({
        'residentId': '',
        'Full Name': '',
        'Car Plate': '',
        'Check-in Time': '',
        'Check-in Date': '',
        'Phone Number': '',
        'Unit No': '',
      }),
    );

    return result;
  }
}
