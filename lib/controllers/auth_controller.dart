import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:sales/models/user.dart';

class AuthController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //  Connexion utilisateur
  Future<User?> signIn(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(email: email, password: password);
      User? user = userCredential.user;

      if (user != null) {
        await enregistrerTokenFCM(user.uid); // Enregistre le token FCM
      }

      return user;
    } catch (e) {
      print(" Erreur de connexion : $e");
      return null;
    }
  }

  // Inscription utilisateur + Firestore
  Future<User?> signUp({
    required String name,
    required String email,
    required String password,
    required String phone,
    required String role,
  }) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
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

      await enregistrerTokenFCM(userCredential.user!.uid); //  Enregistre le token FCM

      return userCredential.user;
    } catch (e) {
      print("⚠ Erreur d'inscription : $e");
      return null;
    }
  }

  //  Enregistrer le Token FCM dans Firestore
  Future<void> enregistrerTokenFCM(String userId) async {
    try {
      String? token = await FirebaseMessaging.instance.getToken();
      if (token != null) {
        await _firestore.collection('users').doc(userId).update({'fcmToken': token});
      } else {
        print(" Aucune notification FCM trouvée.");
      }
    } catch (e) {
      print("⚠ Erreur lors de l'enregistrement du token FCM : $e");
    }
  }

  //  Écouteur de l'état de connexion
  Stream<User?> authStateChanges() {
    return _auth.authStateChanges();
  }

  //  Déconnexion
  Future<void> signOut() async {
    await _auth.signOut();
    print(" Déconnexion réussie !");
  }
}
