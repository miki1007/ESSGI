import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:pro/firebase_options.dart';
import 'package:pro/services/Auth/auth_get.dart';
import 'package:pro/theme/themeProvider.dart';
import 'package:provider/provider.dart';

void main() async {
  //Firebase Setup
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(ChangeNotifierProvider(
    create: (context) => Themeprovider(),
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const AuthGet(),
      theme: Provider.of<Themeprovider>(context).themeData,
    );
  }
}
