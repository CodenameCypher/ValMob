import 'package:flutter/material.dart';
import 'package:valmob/screens/home.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:valmob/shared/theme.dart' as shared;

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  print('Firebase initialized');
  runApp(const ValMob());
}

class ValMob extends StatelessWidget {
  const ValMob({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ValMob',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: homescreen(),
    );
  }
}