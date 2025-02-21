import 'package:cloud_firestore/cloud_firestore.dart';

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

  /// Convertit l'objet en Map pour Firestore
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

  /// Crée un objet `UserModel` à partir d'une Map
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      userId: map['userId'] ?? '',
      name: map['name'] ?? 'Inconnu',
      role: map['role'] ?? 'commercial',
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
      salesCount: map['salesCount'] ?? 0,
      totalRevenue: (map['totalRevenue'] ?? 0.0).toDouble(),
      fcmToken: map['fcmToken'],
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'])
          : DateTime.now(), // Valeur par défaut
    );
  }

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
  Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

  return UserModel(
    userId: doc.id,
    name: data['name'] ?? 'Inconnu',
    role: data['role'] ?? 'commercial',
    email: data['email'] ?? '',
    phone: data['phone'] ?? '',
    salesCount: (data['salesCount'] ?? 0).toInt(),
    totalRevenue: (data['totalRevenue'] ?? 0.0).toDouble(),
    createdAt: data['createdAt'] != null
        ? DateTime.tryParse(data['createdAt']) ?? DateTime.now()
        : DateTime.now(),
  );
}

  }

