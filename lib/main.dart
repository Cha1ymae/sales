import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:sales/view/welcome_page.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("📢 Message reçu en arrière-plan : ${message.notification?.title}");
}

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
    Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    print("Message reçu en arrière-plan : ${message.notification?.title}");
  }
   FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print(" Notification reçue !");
    print(" Titre : ${message.notification?.title}");
    print(" Message : ${message.notification?.body}");
  });
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
