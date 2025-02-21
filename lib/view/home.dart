import 'package:flutter/material.dart';
import 'package:sales/controllers/sales_controller.dart';
import 'package:sales/models/sale.dart';
import 'package:sales/view/add_sale.dart';
import 'package:sales/view/leaderboard.dart'; 

class HomePage extends StatelessWidget {
  final SalesController _salesController = SalesController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tableau de bord"),
        actions: [
          IconButton(
            icon: Icon(Icons.leaderboard),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LeaderboardPage()),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            //  Nombre total de ventes
            StreamBuilder<int>(
              stream: _salesController.obtenirNombreVentes(),
              builder: (context, snapshot) {
                int nombreVentes = snapshot.data ?? 0;
                return Card(
                  elevation: 4,
                  child: ListTile(
                    title: Text(
                      "Total des ventes",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text("$nombreVentes ventes réalisées"),
                  ),
                );
              },
            ),
            SizedBox(height: 20),
            
            // Bouton pour ajouter une vente
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddSalePage()),
                );
              },
              child: Text("Ajouter une vente"),
            ),
            SizedBox(height: 20),

            //  Liste des ventes de l'utilisateur connecté
            Expanded(
              child: StreamBuilder<List<Sale>>(
                stream: _salesController.obtenirVentesUtilisateur(),
                builder: (context, snapshot) {

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text("Aucune vente enregistrée."));
                  }

                  var ventes = snapshot.data!;
                  return ListView.builder(
                    itemCount: ventes.length,
                    itemBuilder: (context, index) {
                      var vente = ventes[index];
                      return Card(
                        margin: EdgeInsets.symmetric(vertical: 8),
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
            ),
          ],
        ),
      ),
    );
  }
}
