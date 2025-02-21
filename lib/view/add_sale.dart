import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sales/controllers/sales_controller.dart';
import 'package:sales/models/sale.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddSalePage extends StatefulWidget {
  @override
  _AddSalePageState createState() => _AddSalePageState();
}

class _AddSalePageState extends State<AddSalePage> {
  final _clientController = TextEditingController();
  final _productController = TextEditingController(); 
  final _amountController = TextEditingController();
  String? _userId;
  final SalesController _salesController = SalesController();

  @override
  void initState() {
    super.initState();
    _userId = FirebaseAuth.instance.currentUser?.uid;
  }

  Future<void> _addSale() async {
    if (_clientController.text.isEmpty ||
        _productController.text.isEmpty ||
        _amountController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Veuillez remplir tous les champs.")),
      );
      return;
    }

    if (_userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur : utilisateur non identifié.")),
      );
      return;
    }

    String saleId = FirebaseFirestore.instance.collection('sales').doc().id;

    // Vérifier si le document existe avant d'accéder aux données
    DocumentSnapshot docSnapshot = await FirebaseFirestore.instance
        .collection("sales")
        .doc(_userId) //  Correction ici (_userId au lieu de userId)
        .get();

    int salesCount = 0;
    if (docSnapshot.exists) {
      salesCount = docSnapshot.get("salesCount") ?? 0;
    } else {
      print(" Le document n'existe pas encore.");
    }

    Sale newSale = Sale(
      saleId: saleId,
      commercialId: _userId!,
      clientName: _clientController.text.trim(),
      product: _productController.text.trim(),
      amount: double.parse(_amountController.text.trim()),
      status: 'vendu',
      createdAt: DateTime.now(),
    );

    await _salesController.ajouterVente(newSale);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Vente ajoutée avec succès !")),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Ajouter une Vente")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: _clientController, decoration: InputDecoration(labelText: "Nom du client")),
            TextField(controller: _productController, decoration: InputDecoration(labelText: "Produit vendu")),
            TextField(controller: _amountController, decoration: InputDecoration(labelText: "Montant"), keyboardType: TextInputType.number),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _addSale,
              child: Text("Enregistrer la vente"),
            ),
          ],
        ),
      ),
    );
  }
}
