import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AddSalePage extends StatefulWidget {
  @override
  _AddSalePageState createState() => _AddSalePageState();
}

class _AddSalePageState extends State<AddSalePage> {
  final _clientNameController = TextEditingController();
  final _productController = TextEditingController();
  final _amountController = TextEditingController();
  String? _userId;

  @override
  void initState() {
    super.initState();
    _userId = FirebaseAuth.instance.currentUser?.uid;
  }

  Future<void> _addSale() async {
    if (_clientNameController.text.isEmpty ||
        _productController.text.isEmpty ||
        _amountController.text.isEmpty) {
      // Afficher une alerte si les champs sont vides
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text('Erreur'),
          content: Text('Veuillez remplir tous les champs.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        ),
      );
      return;
    }

    try {
      // Ajouter la vente dans Firestore
      await FirebaseFirestore.instance.collection('sales').add({
        'commercialId': _userId,
        'clientName': _clientNameController.text,
        'product': _productController.text,
        'amount': double.parse(_amountController.text),
        'status': 'vendu', // Statut par défaut
        'createdAt': FieldValue.serverTimestamp(),
      });

      // Réinitialiser les champs
      _clientNameController.clear();
      _productController.clear();
      _amountController.clear();

      // Afficher un message de succès
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Vente ajoutée avec succès !'),
      ));
    } catch (e) {
      // Afficher un message d'erreur en cas de problème
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Erreur lors de l\'ajout de la vente : $e'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ajouter une Vente'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _clientNameController,
              decoration: InputDecoration(labelText: "Nom du client"),
            ),
            TextField(
              controller: _productController,
              decoration: InputDecoration(labelText: "Produit vendu"),
            ),
            TextField(
              controller: _amountController,
              decoration: InputDecoration(labelText: "Montant"),
              keyboardType: TextInputType.number,
            ),
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