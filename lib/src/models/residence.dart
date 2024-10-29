class Residence {
  final int? id;
  final String? name;
  final String? city;
  final String? state;
  final String? zip;
  final String? country;
  final String? address;
  final String? description;

  Residence({
    this.id,
    this.name,
    this.city,
    this.state,
    this.zip,
    this.country,
    this.address,
    this.description,
  });

  factory Residence.fromJson(Map<String, dynamic> json) {
    return Residence(
      id: json['id'],
      name: json['name'],
      city: json['city'],
      state: json['state'],
      zip: json['zip'],
      country: json['country'],
      address: json['address'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'city': city,
      'state': state,
      'zip': zip,
      'country': country,
      'address': address,
      'description': description,
    };
  }

  @override
  String toString() {
    return 'Residence $name (id: $id, address: $address)';
  }

  Residence copyWith({
    int? id,
    String? name,
    String? city,
    String? state,
    String? zip,
    String? country,
    String? address,
    String? description,
  }) {
    return Residence(
      id: id ?? this.id,
      name: name ?? this.name,
      city: city ?? this.city,
      state: state ?? this.state,
      zip: zip ?? this.zip,
      country: country ?? this.country,
      address: address ?? this.address,
      description: description ?? this.description,
    );
  }
}
