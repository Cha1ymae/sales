import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:sales/view/welcome_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: "AIzaSyAWjemoe2wf3SI0Fp-CtK64NQeSkD6meqc", 
      appId: "1:115362818316:web:b07edf5a663191af4ac129",
      messagingSenderId: "115362818316", 
      projectId: "sales-797d9", 
      authDomain: "sales-797d9.firebaseapp.com", 
      storageBucket: "sales-797d9.firebasestorage.app", 
    ),
  );

  // Lancez l'application
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sales App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: WelcomePage(), // Démarrez sur la WelcomePage
    );
  }
}
