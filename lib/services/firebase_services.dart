import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sales/models/user.dart';

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Obtenir l'utilisateur actuel
  User? get currentUser => _auth.currentUser;

  // Inscription avec email et mot de passe
  Future<UserModel?> signUp(String name, String email, String password, String phone, String role) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User? user = userCredential.user;

      if (user != null) {
        UserModel newUser = UserModel(
          userId: user.uid,
          name: name,
          email: email,
          phone: phone,
          role: role,
          salesCount: 0,
          totalRevenue: 0.0,
          createdAt: DateTime.now(),
        );

        await _firestore.collection('users').doc(user.uid).set(newUser.toMap());
        return newUser;
      }
    } catch (e) {
      print("Erreur d'inscription : $e");
      return null;
    }
    return null;
  }

  //  Connexion avec email et mot de passe
  Future<UserModel?> signIn(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(email: email, password: password);
      User? user = userCredential.user;

      if (user != null) {
        DocumentSnapshot doc = await _firestore.collection('users').doc(user.uid).get();
        if (doc.exists) {
          return UserModel.fromMap(doc.data() as Map<String, dynamic>);
        }
      }
    } catch (e) {
      print("Erreur de connexion : $e");
      return null;
    }
    return null;
  }

  // Déconnexion
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // 🔹 Obtenir un utilisateur par son ID
  Future<UserModel?> getUser(String userId) async {
    DocumentSnapshot doc = await _firestore.collection('users').doc(userId).get();
    if (doc.exists) {
      return UserModel.fromMap(doc.data() as Map<String, dynamic>);
    }
    return null;
  }

  //  Ajouter une vente
  Future<void> addSale(String clientName, String product, double amount) async {
    if (currentUser == null) return;

    String saleId = _firestore.collection('sales').doc().id;
    Map<String, dynamic> saleData = {
      'saleId': saleId,
      'commercialId': currentUser!.uid,
      'clientName': clientName,
      'product': product,
      'amount': amount,
      'status': 'vendu',
      'createdAt': Timestamp.now(),
    };

    await _firestore.collection('sales').doc(saleId).set(saleData);
  }

  // Récupérer les ventes en temps réel
  Stream<QuerySnapshot> getSalesStream() {
    return _firestore.collection('sales').orderBy('createdAt', descending: true).snapshots();
  }
}