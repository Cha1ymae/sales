import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sales/models/sale.dart';
import 'package:sales/models/user.dart';

class SalesController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String? _userId = FirebaseAuth.instance.currentUser?.uid;

 Future<void> ajouterVente(Sale vente) async {
  await _firestore.collection('sales').doc(vente.saleId).set(vente.toMap());

  DocumentReference userRef = _firestore.collection('users').doc(vente.commercialId);
  
  await _firestore.runTransaction((transaction) async {
    DocumentSnapshot snapshot = await transaction.get(userRef);
    
    if (snapshot.exists) {
      int currentSalesCount = snapshot['salesCount'] ?? 0;
      double currentRevenue = snapshot['totalRevenue'] ?? 0.0;

      transaction.update(userRef, {
        'salesCount': currentSalesCount + 1,
        'totalRevenue': currentRevenue + vente.amount,
      });
    }
  });
}


  // Récupérer uniquement les ventes de l’utilisateur connecté
  Stream<List<Sale>> obtenirVentesUtilisateur() {
    if (_userId == null) return Stream.value([]);
    
    return _firestore
        .collection('sales')
        .where('commercialId', isEqualTo: _userId) // Filtrer par userId
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) => Sale.fromMap(doc.data())).toList();
        });
  }

  // Récupérer le nombre de ventes de l’utilisateur
  Stream<int> obtenirNombreVentes() {
    return obtenirVentesUtilisateur().map((ventes) => ventes.length);
  }
  Stream<List<UserModel>> obtenirClassementCommerciaux() {
    return FirebaseFirestore.instance
        .collection('users')
        .where('role', isEqualTo: 'commercial')
        .orderBy('salesCount', descending: true) // Trier par ventes
        .snapshots()
        .map((snapshot) {

          return snapshot.docs.map((doc) => UserModel.fromFirestore(doc)).toList();
        });
  }
}