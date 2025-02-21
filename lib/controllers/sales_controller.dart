import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sales/models/sale.dart';
import 'package:sales/models/user.dart';

class SalesController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //  Ajouter une vente
Future<void> ajouterVente(Sale vente) async {
  await FirebaseFirestore.instance.collection('sales').doc(vente.saleId).set(vente.toMap());

  DocumentReference userRef = FirebaseFirestore.instance.collection('users').doc(vente.commercialId);

  await FirebaseFirestore.instance.runTransaction((transaction) async {
    DocumentSnapshot snapshot = await transaction.get(userRef);

    if (snapshot.exists) {
      int currentSalesCount = (snapshot['salesCount'] ?? 0).toInt();
      double currentRevenue = (snapshot['totalRevenue'] ?? 0.0).toDouble();


      transaction.update(userRef, {
        'salesCount': currentSalesCount + 1,
        'totalRevenue': currentRevenue + vente.amount,
      });

    } else {
      //  Si le document n'existe pas encore, on le crée avec des valeurs initiales
      transaction.set(userRef, {
        'salesCount': 1,
        'totalRevenue': vente.amount,
      });
    }
  });

  // Vérifier les données Firestore immédiatement après la mise à jour
  DocumentSnapshot updatedSnapshot = await userRef.get();
  print("[Firestore après mise à jour] salesCount = ${updatedSnapshot['salesCount']}, totalRevenue = ${updatedSnapshot['totalRevenue']}");
}


    

  // Récupérer les ventes de l’utilisateur connecté
  Stream<List<Sale>> obtenirVentesUtilisateur() {
  User? user = _auth.currentUser;

  if (user == null) {
    return Stream.value([]);
  }


  return _firestore
      .collection('sales')
      .where('commercialId', isEqualTo: user.uid)
      .snapshots()
      .map((snapshot) {
        return snapshot.docs.map((doc) => Sale.fromMap(doc.data())).toList();
      });
}


  // Récupérer le nombre de ventes de l’utilisateur
  Stream<int> obtenirNombreVentes() {
    User? user = _auth.currentUser;

    if (user == null) {
      return Stream.value(0);
    }

    return _firestore
        .collection('sales')
        .where('commercialId', isEqualTo: user.uid)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.length;
        });
  }

  //  Récupérer le classement des commerciaux
  Stream<List<UserModel>> obtenirClassementCommerciaux() {
    return _firestore
        .collection('users')
        .where('role', isEqualTo: 'commercial')
        .orderBy('salesCount', descending: true) // Trier par ventes
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) => UserModel.fromFirestore(doc)).toList();
        });
  }
}
