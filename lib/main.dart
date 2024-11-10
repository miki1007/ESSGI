import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:pro/firebase_options.dart';
import 'package:pro/pages/onBoard.dart';
import 'package:pro/pages/requested_ticket.dart';
import 'package:pro/services/Auth/auth_get.dart';
import 'package:pro/services/Auth/login_or_register.dart';
import 'package:pro/services/database/database_provider.dart';
import 'package:pro/theme/themeProvider.dart';
import 'package:provider/provider.dart';

void main() async {
  //Firebase Setup
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MultiProvider(
    providers: [
      //theme Provider
      ChangeNotifierProvider(
        create: (context) => Themeprovider(),
      ),

      //database provider
      ChangeNotifierProvider(
        create: (context) => DatabaseProvider(),
      ),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const OnboardPage(),
      theme: Provider.of<Themeprovider>(context).themeData,
      routes: {
        '/loginOrRegister': (context) => const LoginOrRegister(),
        '/authGet': (context) => const AuthGet(),
        '/TicketListPage': (context) => TicketListPage(),
      },
    );
  }
}
