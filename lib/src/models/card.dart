
class Card {
  final int? id;
  final int residentId;
  final String cardNo;
  final String cardType;
  final DateTime cardExpiry;
  final String cardCvv;
  final String cardName;
  final String cardStatus;


  Card({
    this.id,
    required this.residentId,
    required this.cardNo,
    required this.cardType,
    required this.cardExpiry,
    required this.cardCvv,
    required this.cardName,
    required this.cardStatus,

  });

  factory Card.fromJson(Map<String, dynamic> json) {
    return Card(
      id: json['id'],
      residentId: json['resident'],
      cardNo: json['card_no'],
      cardType: json['card_type'],
      cardExpiry: DateTime.parse(json['card_expiry']),
      cardCvv: json['card_cvv'],
      cardName: json['card_name'],
      cardStatus: json['card_status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'resident': residentId,
      'card_no': cardNo,
      'card_type': cardType,
      'card_expiry': cardExpiry.toIso8601String(),
      'card_cvv': cardCvv,
      'card_name': cardName,
      'card_status': cardStatus,
    };
  }

  @override
  String toString() {
    return 'Card #$id for Resident $residentId - Card Type: $cardType';
  }

  Card copyWith({
    int? id,
    int? residentId,
    String? cardNo,
    String? cardType,
    DateTime? cardExpiry,
    String? cardCvv,
    String? cardName,
    String? cardStatus,
    DateTime? cardCreatedAt,
    DateTime? cardUpdatedAt,
    DateTime? cardDeletedAt,
  }) {
    return Card(
      id: id ?? this.id,
      residentId: residentId ?? this.residentId,
      cardNo: cardNo ?? this.cardNo,
      cardType: cardType ?? this.cardType,
      cardExpiry: cardExpiry ?? this.cardExpiry,
      cardCvv: cardCvv ?? this.cardCvv,
      cardName: cardName ?? this.cardName,
      cardStatus: cardStatus ?? this.cardStatus,
    );
  }
}