import '../utils/date__utils.dart';
import 'parking.dart';
import 'resident.dart';

class ResidentParking {
  final int? id;
  final Parking? parking;
  final Resident? resident;
  final bool isOccupied;

  ResidentParking({
    this.id,
    this.parking,
    this.resident,
    this.isOccupied = false,
  });

  factory ResidentParking.fromJson(Map<String, dynamic> json) {
    return ResidentParking(
      id: json['id'],
      parking: json['parking'] != null 
          ? Parking.fromJson(json['parking']) 
          : null,
      resident: json['resident'] != null 
          ? Resident.fromJson(json['resident']) 
          : null,
      isOccupied: json['is_occupied'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'parking': parking?.toJson(),
      'resident': resident?.toJson(),
      'is_occupied': isOccupied,
    };
  }

  @override
  String toString() {
    return 'Resident Parking #$id - Occupied: $isOccupied';
  }

  ResidentParking copyWith({
    int? id,
    Parking? parking,
    Resident? resident,
    bool? isOccupied,
  }) {
    return ResidentParking(
      id: id ?? this.id,
      parking: parking ?? this.parking,
      resident: resident ?? this.resident,
      isOccupied: isOccupied ?? this.isOccupied,
    );
  }
}