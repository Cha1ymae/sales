class UserModel {
  String userId;
  String name;
  String role; // "commercial" ou "technicien"
  String email;
  String phone;
  int salesCount;
  double totalRevenue;
  String? fcmToken;
  DateTime createdAt;

  UserModel({
    required this.userId,
    required this.name,
    required this.role,
    required this.email,
    required this.phone,
    this.salesCount = 0,
    this.totalRevenue = 0.0,
    this.fcmToken,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'name': name,
      'role': role,
      'email': email,
      'phone': phone,
      'salesCount': salesCount,
      'totalRevenue': totalRevenue,
      'fcmToken': fcmToken,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      userId: map['userId'],
      name: map['name'],
      role: map['role'],
      email: map['email'],
      phone: map['phone'],
      salesCount: map['salesCount'] ?? 0,
      totalRevenue: (map['totalRevenue'] ?? 0.0).toDouble(),
      fcmToken: map['fcmToken'],
      createdAt: DateTime.parse(map['createdAt']),
    );
  }
}