import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:loco_frontend/src/constants/api_path.dart';

import '../models/announcement.dart';

class AnnouncementService {
  Future<List<Announcement>> getAllAnnouncements() async {
    try {
      final response = await http.get(
        Uri.parse('${apiPath}announcements/view_all_announcements'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> res = json.decode(response.body);
        final List<Announcement> announcementList = res
            .map((announcement) =>
                Announcement.fromJson(announcement as Map<String, dynamic>))
            .toList();
        return announcementList;
      } else {
        throw Exception('Failed to load announcements: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching announcements: $e');
    }
  }
}
