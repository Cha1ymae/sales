import 'package:flutter/material.dart';
import 'package:sales/controllers/sales_controller.dart';
import 'package:sales/models/user.dart';
import 'package:sales/view/auth.dart';
import 'package:sales/view/login_page.dart';

class WelcomePage extends StatefulWidget {
  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  final SalesController _salesController = SalesController();

  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Bienvenue")),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
            },
            child: Text("Se connecter"),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => AuthPage()));
            },
            child: Text("S'inscrire"),
          ),
          SizedBox(height: 30),
          Text("🏆 Classement des commerciaux 🏆", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),

          Expanded(
            child:StreamBuilder<List<UserModel>>(
  stream: _salesController.obtenirClassementCommerciaux(),
  builder: (context, snapshot) {

    if (snapshot.connectionState == ConnectionState.waiting) {
      return Center(child: CircularProgressIndicator());
    }

    if (!snapshot.hasData) {
      return Center(child: Text("Aucun commercial trouvé."));
    }

    var commerciaux = snapshot.data!;

    if (commerciaux.isEmpty) {
      return Center(child: Text("Aucun commercial trouvé."));
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
          ),
        ],
      ),
    );
  }
}
