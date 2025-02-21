import 'package:flutter/material.dart';
import 'package:sales/controllers/auth_controller.dart';
import 'package:sales/view/home.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthPage extends StatefulWidget {
  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final AuthController _authController = AuthController();

  Future<void> handleSignIn() async {
    User? user = await _authController.signIn(emailController.text, passwordController.text);
    if (user != null) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HomePage()));
    }
  }

  Future<void> handleSignUp() async {
    User? user = await _authController.signUp(emailController.text, passwordController.text);
    if (user != null) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HomePage()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Authentification Firebase")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: emailController, decoration: InputDecoration(labelText: "Email")),
            TextField(controller: passwordController, decoration: InputDecoration(labelText: "Mot de passe"), obscureText: true),
            ElevatedButton(onPressed: handleSignIn, child: Text("Se connecter")),
            ElevatedButton(onPressed: handleSignUp, child: Text("S'inscrire")),
          ],
        ),
      ),
    );
  }
}