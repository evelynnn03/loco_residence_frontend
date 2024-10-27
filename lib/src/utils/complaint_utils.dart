  import '../models/complaint.dart';

List<Complaint> filterComplaints(
      List<Complaint> complaints, String timeFilter) {
    final now = DateTime.now();

    return complaints.where((complaint) {
      switch (timeFilter) {
        case 'This Week':
          return now.difference(complaint.date).inDays <= 7;
        case 'This Month':
          return now.difference(complaint.date).inDays <= 30;
        case 'This Year':
          return now.difference(complaint.date).inDays <= 365;
        default:
          return true;
      }
    }).toList();
  }