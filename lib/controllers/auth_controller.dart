import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sales/models/user.dart';

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

  // 📝 Inscription + enregistrement dans Firestore
  Future<User?> signUp({
    required String name,
    required String email,
    required String password,
    required String phone,
    required String role, // commercial ou technicien
  }) async {
    try {
      // Étape 1 : Création de l'utilisateur avec Firebase Auth
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Étape 2 : Création du modèle utilisateur
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

      // Étape 3 : Enregistrement dans Firestore
      await _firestore.collection('users').doc(userCredential.user!.uid).set(newUser.toMap());

      return userCredential.user;
    } catch (e) {
      print("⚠ Erreur d'inscription : $e");
      return null;
    }
  }

  // 🔄 Écouteur de l'état de connexion
  Stream<User?> authStateChanges() {
    return _auth.authStateChanges();
  }

  // 🚪 Déconnexion
  Future<void> signOut() async {
    await _auth.signOut();
  }
}
