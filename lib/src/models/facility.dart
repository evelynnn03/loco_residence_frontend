class Facility {
  final int? id;
  final String name;
  final String description;
  final bool bookingRequired;

  Facility({
    this.id,
    required this.name,
    required this.description,
    this.bookingRequired = true,
  });

  // Factory method to create a Facility from JSON (if needed)
  factory Facility.fromJson(Map<String, dynamic> json) {
    return Facility(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      bookingRequired: json['booking_required'] ?? true,
    );
  }

  // Method to convert a Facility object to JSON (if needed)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'booking_required': bookingRequired,
    };
  }

  @override
  String toString() {
    return 'Facility $id - $name , booking required: $bookingRequired';
  }

  Facility copyWith({
    int? id,
    String? name,
    String? description,
    bool? bookingRequired,
  }) {
    return Facility(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      bookingRequired: bookingRequired ?? this.bookingRequired,
    );
  }
}
