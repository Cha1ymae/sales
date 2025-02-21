import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sales/models/user.dart';

class UserController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> ajouterUtilisateur(UserModel user) async {
    await _firestore.collection('users').doc(user.userId).set(user.toMap());
  }

  Future<UserModel?> obtenirUtilisateur(String userId) async {
    DocumentSnapshot doc = await _firestore.collection('users').doc(userId).get();
    if (doc.exists) {
      return UserModel.fromMap(doc.data() as Map<String, dynamic>);
    }
    return null;
  }
}