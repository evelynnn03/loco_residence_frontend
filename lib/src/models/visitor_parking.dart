import '../utils/date__utils.dart';
import 'parking.dart';
import 'visitor.dart';

class VisitorParking {
  final int? id;
  final Visitor? visitor;
  final Parking? parking;
  final bool isOccupied;

  VisitorParking({
    this.id,
    this.visitor,
    this.parking,
    this.isOccupied = false,
  });

  factory VisitorParking.fromJson(Map<String, dynamic> json) {
    return VisitorParking(
      id: json['id'],
      visitor: json['visitor'] != null 
          ? Visitor.fromJson(json['visitor']) 
          : null,
      parking: json['parking'] != null 
          ? Parking.fromJson(json['parking']) 
          : null,
      isOccupied: json['is_occupied'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'visitor': visitor?.toJson(),
      'parking': parking?.toJson(),
      'is_occupied': isOccupied,
    };
  }

  @override
  String toString() {
    return 'Visitor Parking #$id - Occupied: $isOccupied';
  }

  VisitorParking copyWith({
    int? id,
    Visitor? visitor,
    Parking? parking,
    bool? isOccupied,
  }) {
    return VisitorParking(
      id: id ?? this.id,
      visitor: visitor ?? this.visitor,
      parking: parking ?? this.parking,
      isOccupied: isOccupied ?? this.isOccupied,
    );
  }
}