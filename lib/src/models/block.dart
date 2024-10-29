import 'residence.dart';

class Block {
  final int? id;
  final Residence? residence;
  final String? name;

  Block({
    this.id,
    this.residence,
    this.name,
  });

  factory Block.fromJson(Map<String, dynamic> json) {
    return Block(
      id: json['id'],
      residence: json['residence'] != null
          ? Residence.fromJson(json['residence'])
          : null,
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'residence': residence?.toJson(),
      'name': name,
    };
  }

  @override
  String toString() {
    return 'Block $name (id: $id, residence: ${residence?.name})';
  }

  Block copyWith({
    int? id,
    Residence? residence,
    String? name,
  }) {
    return Block(
      id: id ?? this.id,
      residence: residence ?? this.residence,
      name: name ?? this.name,
    );
  }
}
