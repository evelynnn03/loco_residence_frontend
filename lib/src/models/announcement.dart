import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';

class Announcement {
  final String details;
  final File? imageFile;
  final String imageUrl;
  final DateTime timestamp;

  Announcement({
    required this.details,
    this.imageFile,
    required this.imageUrl,
    required this.timestamp,
  });

  factory Announcement.fromMap(Map<String, dynamic> data) {
    return Announcement(
      details: data['Details'] ?? '',
      imageUrl: data['Image URL'] ?? '',
      timestamp: data['Timestamp'] != null
          ? (data['Timestamp'] as Timestamp).toDate()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'Details': details,
      'Image URL': imageUrl,
      'Timestamp': timestamp,
    };
  }
}
