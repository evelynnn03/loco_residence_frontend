import 'package:flutter/material.dart';
import 'package:loco_frontend/src/services/announcement_service.dart';

import '../models/announcement.dart';

class AnnouncementProvider with ChangeNotifier {
  List<Announcement> _announcements = [];

  List<Announcement> get announcements => _announcements;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> fetchAnnouncements() async {
    _isLoading = true;
    notifyListeners();
    try {
      _announcements = await AnnouncementService().getAllAnnouncements();
      print('Announcements: $_announcements');
    } catch (e) {
      print('Error fetching announcements: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
