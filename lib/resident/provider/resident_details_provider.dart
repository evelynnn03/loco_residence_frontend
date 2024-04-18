import 'package:flutter/material.dart';

class ResidentDetailsProvider extends ChangeNotifier {
  Map<String, Object> _residentDetails = {
    'residentId': '',
    'Unit No': '',
  };

  Map<String, Object> get residentDetails => _residentDetails;

  void setResidentDetails(Map<String, Object> details) {
    _residentDetails = details;
    notifyListeners();
  }

  String get residentId {
    return _residentDetails['residentId'].toString();
  }

  String get unitNumber {
    return _residentDetails['Unit No'].toString();
  }
}
