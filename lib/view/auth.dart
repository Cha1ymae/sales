import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sales/controllers/auth_controller.dart';
import 'package:sales/view/login_page.dart';

class AuthPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<AuthPage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneController = TextEditingController();
  String? _selectedRole;
  final AuthController _authController = AuthController();

Future<void> _signUp() async {
  if (_nameController.text.isEmpty ||
      _emailController.text.isEmpty ||
      _passwordController.text.isEmpty ||
      _phoneController.text.isEmpty ||
      _selectedRole == null) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Remplissez tous les champs !")));
    return;
  }

  User? user = await _authController.signUp(
    name: _nameController.text.trim(),
    email: _emailController.text.trim(),
    password: _passwordController.text.trim(),
    phone: _phoneController.text.trim(),
    role: _selectedRole!,
  );

  if (user != null) {
    print("Inscription réussie, redirection vers la page de connexion...");
    // Après l'inscription, redirige vers la page de connexion
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()), 
    );
  } else {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Erreur d'inscription")));
  }
}



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Inscription")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: _nameController, decoration: InputDecoration(labelText: "Nom")),
            TextField(controller: _emailController, decoration: InputDecoration(labelText: "Email")),
            TextField(controller: _passwordController, decoration: InputDecoration(labelText: "Mot de passe"), obscureText: true),
            TextField(controller: _phoneController, decoration: InputDecoration(labelText: "Téléphone")),
            DropdownButtonFormField<String>(
              value: _selectedRole,
              items: ["commercial", "technicien"].map((role) => DropdownMenuItem(value: role, child: Text(role))).toList(),
              onChanged: (value) => setState(() => _selectedRole = value),
              decoration: InputDecoration(labelText: "Rôle"),
            ),
            SizedBox(height: 20),
            ElevatedButton(onPressed: _signUp, child: Text("S'inscrire")),
          ],
        ),
      ),
    );
  }
}