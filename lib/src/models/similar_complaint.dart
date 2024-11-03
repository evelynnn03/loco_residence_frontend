import 'dart:convert';
import 'dart:typed_data';

class SimilarComplaint {
  final String title;
  final String description;
  final String category;
  final DateTime date;
  final double similarityScore;
  final String similarityReason;
  final Uint8List? image; // Optional image field
  final String? resident; // Optional resident field if it may be null

  SimilarComplaint({
    required this.title,
    required this.description,
    required this.category,
    required this.date,
    required this.similarityScore,
    required this.similarityReason,
    this.image,
    this.resident,
  });

  // Method to convert an instance of SimilarComplaint to JSON
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'category': category,
      'date': date.toIso8601String(),
      'similarity_score': similarityScore,
      'similarity_reason': similarityReason,
      'image': image != null ? base64Encode(image!) : null,
      'resident': resident,
    };
  }

  // Factory constructor to create a SimilarComplaint instance from JSON
  factory SimilarComplaint.fromJson(Map<String, dynamic> json) {
    return SimilarComplaint(
      title: json['title'],
      description: json['description'],
      category: json['category'],
      date: DateTime.parse(json['date']),
      similarityScore: (json['similarity_score'] as num).toDouble(),
      similarityReason: json['similarity_reason'],
      image: json['image'] != null ? base64Decode(json['image']) : null,
      resident: json['resident'],
    );
  }

  // CopyWith method to create a copy with updated fields
  SimilarComplaint copyWith({
    String? title,
    String? description,
    String? category,
    DateTime? date,
    double? similarityScore,
    String? similarityReason,
    Uint8List? image,
    String? resident,
  }) {
    return SimilarComplaint(
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      date: date ?? this.date,
      similarityScore: similarityScore ?? this.similarityScore,
      similarityReason: similarityReason ?? this.similarityReason,
      image: image ?? this.image,
      resident: resident ?? this.resident,
    );
  }

  // Override toString for better readability
  @override
  String toString() {
    return 'SimilarComplaint(title: $title, description: $description, category: $category, date: $date, similarityScore: $similarityScore, similarityReason: $similarityReason, image: ${image != null ? 'Present' : 'None'}, resident: ${resident ?? 'None'})';
  }
}
