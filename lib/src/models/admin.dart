class Admin {
  final String adminName;
  final String adminHP;
  final String adminEmail;
  final String adminPassword;

  Admin(
      {required this.adminName,
      required this.adminHP,
      required this.adminEmail,
      required this.adminPassword});

  factory Admin.fromMap(Map<String, dynamic> data) {
    return Admin(
      adminName: data['Admin Name'] ?? '',
      adminEmail: data['Admin Email'] ?? '',
      adminHP: data['Admin HP'] ?? '',
      adminPassword: data['Admin Password'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'Admin Name': adminName,
      'Admin Email': adminEmail,
      'Admin HP': adminHP,
      'Admin Password': adminPassword,
    };
  }
}
