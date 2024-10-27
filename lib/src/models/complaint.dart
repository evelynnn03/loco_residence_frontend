import 'dart:convert';
import 'dart:typed_data';

class Complaint {
  final String title;
  final String description;
  final String status;
  final DateTime date;
  final Uint8List? image; // Add the image field as an optional Uint8List

  Complaint({
    required this.title,
    required this.description,
    required this.status,
    required this.date,
    this.image, // Optional image parameter
  });

  // Method to convert an instance of Complaint to JSON
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'date': date.toIso8601String(),
      'image': image != null ? base64Encode(image!) : null, // Convert image to base64
    };
  }

  //from Json
  factory Complaint.fromJson(Map<String, dynamic> json) {
    return Complaint(
      title: json['title'],
      description: json['description'],
      status: json['status'],
      date: DateTime.parse(json['date']),
    );
  }

  // copyWith method to create a copy with updated fields
  Complaint copyWith({
    String? title,
    String? description,
    String? status,
    DateTime? date,
    Uint8List? image,
  }) {
    return Complaint(
      title: title ?? this.title,
      description: description ?? this.description,
      status: status ?? this.status,
      date: date ?? this.date,
      image: image ?? this.image,
    );
  }

  // Override toString for better readability
  @override
  String toString() {
    return 'Complaint(title: $title, description: $description, status: $status, date: $date, image: ${image != null ? 'Present' : 'None'})';
  }
}
