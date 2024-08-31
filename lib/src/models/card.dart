
class Card {
  final int? id;
  final int residentId;
  final String cardNo;
  final String cardType;
  final DateTime cardExpiry;
  final String cardCvv;
  final String cardName;
  final String cardAddress;
  final String cardCity;
  final String cardState;
  final String cardZip;
  final String cardCountry;
  final String cardPhone;
  final String cardEmail;
  final DateTime cardDob;
  final String cardSsn;
  final String cardStatus;


  Card({
    this.id,
    required this.residentId,
    required this.cardNo,
    required this.cardType,
    required this.cardExpiry,
    required this.cardCvv,
    required this.cardName,
    required this.cardAddress,
    required this.cardCity,
    required this.cardState,
    required this.cardZip,
    required this.cardCountry,
    required this.cardPhone,
    required this.cardEmail,
    required this.cardDob,
    required this.cardSsn,
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
      cardAddress: json['card_address'],
      cardCity: json['card_city'],
      cardState: json['card_state'],
      cardZip: json['card_zip'],
      cardCountry: json['card_country'],
      cardPhone: json['card_phone'],
      cardEmail: json['card_email'],
      cardDob: DateTime.parse(json['card_dob']),
      cardSsn: json['card_ssn'],
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
      'card_address': cardAddress,
      'card_city': cardCity,
      'card_state': cardState,
      'card_zip': cardZip,
      'card_country': cardCountry,
      'card_phone': cardPhone,
      'card_email': cardEmail,
      'card_dob': cardDob.toIso8601String(),
      'card_ssn': cardSsn,
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
    String? cardAddress,
    String? cardCity,
    String? cardState,
    String? cardZip,
    String? cardCountry,
    String? cardPhone,
    String? cardEmail,
    DateTime? cardDob,
    String? cardSsn,
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
      cardAddress: cardAddress ?? this.cardAddress,
      cardCity: cardCity ?? this.cardCity,
      cardState: cardState ?? this.cardState,
      cardZip: cardZip ?? this.cardZip,
      cardCountry: cardCountry ?? this.cardCountry,
      cardPhone: cardPhone ?? this.cardPhone,
      cardEmail: cardEmail ?? this.cardEmail,
      cardDob: cardDob ?? this.cardDob,
      cardSsn: cardSsn ?? this.cardSsn,
      cardStatus: cardStatus ?? this.cardStatus,
    );
  }
}