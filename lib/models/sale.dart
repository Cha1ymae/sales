import 'package:cloud_firestore/cloud_firestore.dart';

class Sale {
  String saleId;
  String commercialId;
  String clientName;
  String product;
  double amount;
  String status;
  DateTime createdAt;

  Sale({
    required this.saleId,
    required this.commercialId,
    required this.clientName,
    required this.product,
    required this.amount,
    required this.status,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'saleId': saleId,
      'commercialId': commercialId,
      'clientName': clientName,
      'product': product,
      'amount': amount,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
    };
  }


  
  factory Sale.fromMap(Map<String, dynamic> map) {
  return Sale(
    saleId: map['id'] ?? 'unknown',
    commercialId: map['commercialId'] ?? 'unknown',
    clientName: map['clientName'] ?? 'unknown',
    product: map['product'] ?? 'Aucun produit',
    amount: (map['amount'] ?? 0).toDouble(),
    status: map['status'] ?? 'inconnu',
    createdAt: map['createdAt'] is Timestamp
        ? (map['createdAt'] as Timestamp).toDate()
        : DateTime.tryParse(map['createdAt'] ?? '') ?? DateTime.now()
  );
}

}