import 'package:flutter/material.dart';
import '../services/announcement_service.dart';
import '../models/announcement.dart';

class AnnouncementProvider with ChangeNotifier {
  List<Announcement> _announcements = [];
  List<Announcement> get announcements => _announcements;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // Get only the latest 3 announcements
  List<Announcement> get latestThreeAnnouncements {
    if (_announcements.isEmpty) return [];
    return _announcements.take(3).toList();
  }

  Future<void> fetchAnnouncements() async {
    _isLoading = true;
    notifyListeners();

    try {
      _announcements = await AnnouncementService().getAllAnnouncements();
      print('Fetched ${_announcements.length} announcements');
      print('Latest 3 announcements: ${latestThreeAnnouncements.length}');
    } catch (e) {
      print('Error fetching announcements: $e');
      _announcements = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
