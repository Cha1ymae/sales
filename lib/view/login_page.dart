import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sales/controllers/auth_controller.dart';
import 'package:sales/view/auth.dart';
import 'package:sales/view/home.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final AuthController _authController = AuthController();

  Future<void> _login() async {
  String email = _emailController.text.trim();
  String password = _passwordController.text.trim();

  if (email.isEmpty || password.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Remplissez tous les champs !")));
    return;
  }

  User? user = await _authController.signIn(email, password);
  if (user != null) {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));
  } else {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Erreur de connexion")));
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Connexion")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: _emailController, decoration: InputDecoration(labelText: "Email")),
            TextField(controller: _passwordController, decoration: InputDecoration(labelText: "Mot de passe"), obscureText: true),
            SizedBox(height: 20),
            ElevatedButton(onPressed: _login, child: Text("Se connecter")),
            TextButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => AuthPage())),
              child: Text("Créer un compte"),
            ),
          ],
        ),
      ),
    );
  }
}