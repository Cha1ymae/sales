import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sales/models/user.dart'; // Modèle UserModel

class AuthController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // 🔐 Connexion (seulement email et mot de passe)
  Future<User?> signIn(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      print("⚠ Erreur de connexion : $e");
      return null;
    }
  }

  // 📝 Inscription avec rôle
  Future<User?> signUp({
    required String name,
    required String email,
    required String password,
    required String phone,
    required String role, // commercial ou technicien
  }) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Création de l'utilisateur Firestore
      UserModel newUser = UserModel(
        userId: userCredential.user!.uid,
        name: name,
        role: role,
        email: email,
        phone: phone,
        salesCount: 0,
        totalRevenue: 0.0,
        createdAt: DateTime.now(),
      );

      await _firestore.collection('users').doc(userCredential.user!.uid).set(newUser.toMap());

      return userCredential.user;
    } catch (e) {
      print(" Erreur d'inscription : $e");
      return null;
    }
  }

  Stream<User?> authStateChanges() {
    return _auth.authStateChanges();
  }

  
  Future<void> signOut() async {
    await _auth.signOut();
  }
}