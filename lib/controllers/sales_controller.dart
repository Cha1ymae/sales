import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sales/models/sale.dart';

class SalesController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> ajouterVente(Sale vente) async {
    await _firestore.collection('sales').doc(vente.saleId).set(vente.toMap());
  }

  Stream<List<Sale>> obtenirVentes() {
    return _firestore.collection('sales').orderBy('createdAt', descending: true).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => Sale.fromMap(doc.data())).toList();
    });
  }
}