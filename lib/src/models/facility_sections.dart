class FacilitySections {
  final int? id;
  final int facilityId;
  final String sectionName;
  final bool isAvailable;

  FacilitySections({
    this.id,
    required this.facilityId,
    required this.sectionName,
    this.isAvailable = true,
  });

  factory FacilitySections.fromJson(Map<String, dynamic> json) {
    return FacilitySections(
      id: json['id'],
      facilityId: json['facility'] ?? 0, 
      sectionName: json['section_name'] ?? '', 
      isAvailable: json['is_available'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'facility': facilityId,
      'section_name': sectionName,
      'is_available': isAvailable,
    };
  }

  @override
  String toString() {
    return 'Facility Section #$id - $facilityId, $sectionName - $isAvailable';
  }

  FacilitySections copyWith({
    int? id,
    int? facilityId,
    String? sectionName,
    bool? isAvailable,
  }) {
    return FacilitySections(
      id: id ?? this.id,
      facilityId: facilityId ?? this.facilityId,
      sectionName: sectionName ?? this.sectionName,
      isAvailable: isAvailable ?? this.isAvailable,
    );
  }
}
