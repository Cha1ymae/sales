import 'package:flutter/material.dart';
import 'package:sales/controllers/sales_controller.dart';
import 'package:sales/models/sale.dart';

class SalesListPage extends StatelessWidget {
  final SalesController _salesController = SalesController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Mes ventes")),
      body: StreamBuilder<List<Sale>>(
        stream: _salesController.obtenirVentesUtilisateur(), 
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());

          var ventes = snapshot.data!;
          if (ventes.isEmpty) {
            return Center(child: Text("Vous n'avez encore enregistré aucune vente."));
          }

          return ListView.builder(
            itemCount: ventes.length,
            itemBuilder: (context, index) {
              var vente = ventes[index];
              return Card(
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: ListTile(
                  title: Text("Client : ${vente.clientName}"),
                  subtitle: Text("Montant: ${vente.amount} € - Statut: ${vente.status}"),
                  trailing: Text(vente.createdAt.toString().substring(0, 16)), // Date formatée
                ),
              );
            },
          );
        },
      ),
    );
  }
}
