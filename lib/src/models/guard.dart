class Guard {
  final String guardEmail;
  final String guardHP;
  final String guardIC;
  final String guardName;
  final String guardPassword;
  final String imageUrl;

  Guard(
      {required this.guardEmail,
      required this.guardHP,
      required this.guardIC,
      required this.guardName,
      required this.guardPassword,
      required this.imageUrl});

  factory Guard.fromMap(Map<String, dynamic> data) {
    return Guard(
        guardEmail: data['Guard Email'] ?? '',
        guardHP: data['Guard HP'] ?? '',
        guardIC: data['Guard IC'] ?? '',
        guardName: data['Guard Name'] ?? '',
        guardPassword: data['Guard Password'] ?? '',
        imageUrl: data['Image Url'] ?? '',
        );
  }

  Map<String, dynamic> toMap() {
    return {
      'Guard Email': guardEmail,
      'Guard HP': guardHP,
      'Guard IC': guardIC,
      'Guard Name': guardName,
      'Guard Password': guardPassword,
      'Image Url': imageUrl
    };
  }
}
