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

  static Sale fromMap(Map<String, dynamic> map) {
    return Sale(
      saleId: map['saleId'],
      commercialId: map['commercialId'],
      clientName: map['clientName'],
      product: map['product'],
      amount: map['amount'],
      status: map['status'],
      createdAt: DateTime.parse(map['createdAt']),
    );
  }
}