import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sales/controllers/auth_controller.dart';
import 'package:sales/view/add_sale.dart'; // Importer la page pour ajouter une vente
import 'package:sales/view/auth.dart';
import 'package:sales/view/sales_list.dart'; // Importer la page pour voir les ventes validées

class HomePage extends StatelessWidget {
  final AuthController _authController = AuthController();

  // Méthode pour récupérer le rôle de l'utilisateur depuis Firestore
  Future<String?> _getUserRole(String userId) async {
    try {
      var userDoc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
      if (userDoc.exists) {
        return userDoc['role']; // Récupère le rôle (commercial ou technicien)
      }
      return null; // Si le rôle n'existe pas
    } catch (e) {
      print('Erreur de récupération du rôle: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: _authController.authStateChanges(), // Écouteur d'état de l'authentification
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasData) {
          // Utilisateur connecté
          String userId = snapshot.data!.uid;

          return FutureBuilder<String?>(
            future: _getUserRole(userId), // Obtenir le rôle de l'utilisateur
            builder: (context, roleSnapshot) {
              if (roleSnapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (roleSnapshot.hasData) {
                String role = roleSnapshot.data!;

                if (role == 'commercial') {
                  // Si l'utilisateur est un commercial, on affiche la page pour ajouter une vente
                  return AddSalePage(); // Ou bien une page comme "Vendre"
                } else if (role == 'technicien') {
                  // Si l'utilisateur est un technicien, on affiche la page des ventes validées
                  return SalesListPage(); // Voir les ventes validées
                } else {
                  return Scaffold(body: Center(child: Text('Rôle inconnu')));
                }
              } else {
                return Scaffold(body: Center(child: Text('Erreur de récupération du rôle')));
              }
            },
          );
        } else {
          // Si l'utilisateur n'est pas connecté, on affiche l'écran de connexion
          return AuthPage(); 
        }
      },
    );
  }
}