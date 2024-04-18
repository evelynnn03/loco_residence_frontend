import 'package:flutter/material.dart';

class VisitorDetailsProvider extends ChangeNotifier {
  List<Map<String, Object>> _visitorDetailsList = [];

  List<Map<String, Object>> get visitorDetailsList => _visitorDetailsList;

  // Add visitor details to the list
  void addVisitorDetails(Map<String, Object> details) {
    _visitorDetailsList.add(details);
    notifyListeners();
  }

  // Remove visitor details from the list
  void removeVisitorDetails(String visitorId) {
    _visitorDetailsList
        .removeWhere((details) => details['visitorId'] == visitorId);
    notifyListeners();
  }

  bool containsVisitor(String visitorId) {
    return _visitorDetailsList
        .any((details) => details['visitorId'] == visitorId);
  }

  int returnRemainingParkingLot() {
    final int parkingLots = 20 - _visitorDetailsList.length;
    return parkingLots;
  }

  void printVisitorDetailsList() {
    for (Map<String, Object> visitorDetails in _visitorDetailsList) {
      print('Visitor Details:');
      for (MapEntry<String, Object> entry in visitorDetails.entries) {
        print('${entry.key}: ${entry.value}');
      }
      print('\n'); // Add a line break between visitors for better readability
    }
  }

  Map<String, Object> returnVisitorDetailsBasedOnParkingLot(
      String parkingLotNo) {
    //return the fist occurance of the visitorBased on the object, else return empty map
    Map<String, Object> result = visitorDetailsList.firstWhere(
      (visitor) => visitor['Parking Number'] == parkingLotNo,
      orElse: () => Map<String, Object>.from({
        'visitorId': '',
        'Full Name': '',
        'Car Plate': '',
        'Check-in Time': '',
        'Check-in Date': '',
        'Phone Number': '',
        "Unit No": '',
        'Parking Number': '',
      }),
    );

    return result;
  }
}
