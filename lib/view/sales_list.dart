import 'package:flutter/material.dart';
import 'package:sales/controllers/sales_controller.dart';
import 'package:sales/models/sale.dart';

class SalesListPage extends StatelessWidget {
  final SalesController _salesController = SalesController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Ventes en temps réel")),
      body: StreamBuilder<List<Sale>>(
        stream: _salesController.obtenirVentes(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
          
          var ventes = snapshot.data!;
          return ListView.builder(
            itemCount: ventes.length,
            itemBuilder: (context, index) {
              var vente = ventes[index];
              return ListTile(
                title: Text("${vente.clientName} - ${vente.product}"),
                subtitle: Text("Montant: ${vente.amount} € - Statut: ${vente.status}"),
              );
            },
          );
        },
      ),
    );
  }
}