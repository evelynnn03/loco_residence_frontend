import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants/api_path.dart';
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

        return filteredAnnouncements;
      } else {
        throw Exception('Failed to load announcements: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching announcements: $e');
    }
  }
}
