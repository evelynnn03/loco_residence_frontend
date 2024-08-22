import '../utils/date__utils.dart';

class Invoice {
  final int id;
  final int residentId;
  final String invoiceNo;
  final String amount;
  final DateTime createdAt;
  final String status;

  Invoice({
    required this.id,
    required this.residentId,
    required this.invoiceNo,
    required this.amount,
    required this.createdAt,
    required this.status,
  });

  factory Invoice.fromJson(Map<String, dynamic> json) {
    return Invoice(
      id: json['id'],
      residentId: json['resident'],
      invoiceNo: json['invoice_no'],
      amount: json['amount'],
      createdAt: DateTime.parse(json['created_at']),
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'resident': residentId,
      'invoice_no': invoiceNo,
      'amount': amount,
      'created_at': createdAt.toIso8601String(),
      'status': status,
    };
  }

  @override
  String toString() {
    return 'Invoice #$id for Resident $residentId - Amount: $amount';
  }

    // Getter for formatted date
  String get formattedDate => DateUtils.formatDate(createdAt);
}