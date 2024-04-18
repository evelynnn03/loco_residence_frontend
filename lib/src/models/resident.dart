class Resident {
  final double outstandingAmount;
  final String residentEmail;
  final String residentHP;
  final String residentIC;
  final String residentName;
  final String residentPassword;
  final String unitNo;

  Resident({
    required this.outstandingAmount,
    required this.residentEmail,
    required this.residentHP,
    required this.residentIC,
    required this.residentName,
    required this.residentPassword,
    required this.unitNo,
  });

  factory Resident.fromMap(Map<String, dynamic> data) {
    return Resident(
      outstandingAmount: (data['Outstanding Amount (RM)'] ?? 0).toDouble(),
      residentEmail: data['Resident Email'] ?? '',
      residentHP: data['Resident HP'] ?? '',
      residentIC: data['Resident IC'] ?? '',
      residentName: data['Resident Name'] ?? '',
      residentPassword: data['Resident Password'] ?? '',
      unitNo: data['Unit No'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'Outstanding Amount (RM)': outstandingAmount,
      'Resident Email': residentEmail,
      'Resident HP': residentHP,
      'Resident IC': residentIC,
      'Resident Name': residentName,
      'Resident Password': residentPassword,
      'Unit No': unitNo,
    };
  }
}
