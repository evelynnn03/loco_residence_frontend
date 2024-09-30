import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/facility.dart';
import 'package:loco_frontend/src/constants/api_path.dart';

class FacilityService {
  Future<List<Facility>> getFacilities() async {
    try {
      final response =
          await http.get(Uri.parse('${apiPath}bookings/facilities'));

      if (response.statusCode == 200) {
        final List<dynamic> res = json.decode(response.body);
        return res
            .map((facility) =>
                Facility.fromJson(facility as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception('Failed to load facilities');
      }
    } catch (e) {
      throw Exception('Failed to load facilities: $e');
    }
  }
}
