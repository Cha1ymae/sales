import 'package:flutter/material.dart';
import 'package:sales/controllers/sales_controller.dart';
import 'package:sales/models/user.dart';

class LeaderboardPage extends StatelessWidget {
  final SalesController _salesController = SalesController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Classement des Commerciaux")),
      body: StreamBuilder<List<UserModel>>(
        stream: _salesController.obtenirClassementCommerciaux(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());

          List<UserModel> commerciaux = snapshot.data!;

          if (commerciaux.isEmpty) {
            return Center(child: Text("Aucun commercial enregistré."));
          }

          return ListView.builder(
            itemCount: commerciaux.length,
            itemBuilder: (context, index) {
              var commercial = commerciaux[index];

              return Card(
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.blueAccent,
                    child: Text("${index + 1}"), 
                  ),
                  title: Text(commercial.name, style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text("Ventes: ${commercial.salesCount} • CA: ${commercial.totalRevenue} €"),
                  trailing: Icon(Icons.star, color: index == 0 ? Colors.amber : Colors.grey),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
