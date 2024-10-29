class Resident extends CustomUser {
  Resident({
    required int? id,
    required String? email,
    required String? firstName,
    required String? lastName,
    required String? fullName,
    required String? phoneNumber,
    required CustomUser_Role role,
  }) : super(
          id: id,
          email: email,
          firstName: firstName,
          lastName: lastName,
          fullName: fullName,
          phoneNumber: phoneNumber,
          role: role,
        );

  factory Resident.fromJson(Map<String, dynamic> json) {
    return Resident(
      id: json['id'],
      email: json['email'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      fullName: json['full_name'],
      phoneNumber: json['phone_number'],
      role: CustomUser_Role.values.firstWhere(
        (r) => r.name == json['role'],
        orElse: () => CustomUser_Role.RESIDENT,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'first_name': firstName,
      'last_name': lastName,
      'full_name': fullName,
      'phone_number': phoneNumber,
      'role': role.name,
    };
  }

  @override
  String toString() {
    return 'Resident $fullName (email: $email, phone: $phoneNumber)';
  }

  Resident copyWith({
    int? id,
    String? email,
    String? firstName,
    String? lastName,
    String? fullName,
    String? phoneNumber,
    CustomUser_Role? role,
  }) {
    return Resident(
      id: id ?? this.id,
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      fullName: fullName ?? this.fullName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      role: role ?? this.role,
    );
  }
}

class CustomUser {
  final int? id;
  final String? email;
  final String? firstName;
  final String? lastName;
  final String? fullName;
  final String? phoneNumber;
  final CustomUser_Role role;

  CustomUser({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.fullName,
    required this.phoneNumber,
    required this.role,
  });
}

enum CustomUser_Role {
  SUPER_ADMIN,
  ADMIN,
  GUARD,
  RESIDENT,
}
