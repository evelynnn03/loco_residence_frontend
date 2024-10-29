import 'block.dart';
import 'resident.dart';

class Unit {
  final int? id;
  final Resident? resident;
  final Block? block;
  final String? unitNo;

  Unit({
    this.id,
    this.resident,
    this.block,
    this.unitNo,
  });

  factory Unit.fromJson(Map<String, dynamic> json) {
    return Unit(
      id: json['id'],
      resident: json['resident'] != null ? Resident.fromJson(json['resident']) : null,
      block: json['block'] != null ? Block.fromJson(json['block']) : null,
      unitNo: json['unit_no'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'resident': resident?.toJson(),
      'block': block?.toJson(),
      'unit_no': unitNo,
    };
  }

  @override
  String toString() {
    return 'Unit $unitNo (id: $id, block: ${block?.name}, resident: ${resident?.fullName})';
  }

  Unit copyWith({
    int? id,
    Resident? resident,
    Block? block,
    String? unitNo,
  }) {
    return Unit(
      id: id ?? this.id,
      resident: resident ?? this.resident,
      block: block ?? this.block,
      unitNo: unitNo ?? this.unitNo,
    );
  }
}