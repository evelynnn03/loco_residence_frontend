import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/announcement.dart';

class AnnouncementService {
  final String apiPath = 'http://10.0.2.2:8000/api/v1';
  Future<List<Announcement>> getAllAnnouncements() async {
    try {
      final response = await http.get(
        Uri.parse('$apiPath/announcements/view_all_announcements'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> res = json.decode(response.body);
        final List<Announcement> announcementList = res.map((announcement) {
          // Assuming the Announcement model has an 'image' field
          if (announcement['image'] != null &&
              announcement['image'].isNotEmpty) {
            // Prepend the base URL to the image path
            announcement['image'] = 'http://10.0.2.2:8000${announcement['image']}';
          }
          return Announcement.fromJson(announcement as Map<String, dynamic>);
        }).toList();

        // Get current date for filtering
        final now = DateTime.now();
        final currentMonth = DateTime(now.year, now.month);
        final previousMonth = DateTime(now.year, now.month - 1);

        // Filter announcements for current and previous month
        final filteredAnnouncements = announcementList.where((announcement) {
          final announcementDate = announcement.updatedAt
                  .isAfter(announcement.createdAt)
              ? DateTime(
                  announcement.updatedAt.year, announcement.updatedAt.month)
              : DateTime(
                  announcement.createdAt.year, announcement.createdAt.month);

          return announcementDate.isAtSameMomentAs(currentMonth) ||
              announcementDate.isAtSameMomentAs(previousMonth);
        }).toList();

        // Sort filtered announcements by created_at date (newest first)
        filteredAnnouncements.sort((a, b) {
          int createdComparison = b.createdAt.compareTo(a.createdAt);
          // If created_at dates are the same, sort by updated_at
          if (createdComparison == 0) {
            return b.updatedAt.compareTo(a.updatedAt);
          }
          return createdComparison;
        });
        print(filteredAnnouncements);

        return filteredAnnouncements;
      } else {
        throw Exception('Failed to load announcements: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching announcements: $e');
    }
  }
}
