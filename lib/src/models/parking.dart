import 'block.dart';

class Parking {
  final int? id;
  final String? parkingNo;
  final Block? block;

  Parking({
    this.id,
    this.parkingNo,
    this.block,
  });

  factory Parking.fromJson(Map<String, dynamic> json) {
    return Parking(
      id: json['id'],
      parkingNo: json['parking_no'],
      block: json['block'] != null ? Block.fromJson(json['block']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'parking_no': parkingNo,
      'block': block?.toJson(),
    };
  }

  @override
  String toString() {
    return 'Parking #$id - Parking No: $parkingNo';
  }

  Parking copyWith({
    int? id,
    String? parkingNo,
    Block? block,
  }) {
    return Parking(
      id: id ?? this.id,
      parkingNo: parkingNo ?? this.parkingNo,
      block: block ?? this.block,
    );
  }
}