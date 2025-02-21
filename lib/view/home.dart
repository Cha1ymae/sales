import 'package:flutter/material.dart';
import 'package:sales/view/sales_list.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Accueil")),
      body: Center(child: Text("Bienvenue !")),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => SalesListPage()));
        },
        child: Icon(Icons.shopping_cart),
      ),
    );
  }
}