import 'package:flutter/material.dart';
import 'package:pro/component/my_drawer.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // final int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Container(),
      drawer: MyDrawer(),
      appBar: AppBar(
        title: const Text('H O M E'),
        foregroundColor: Theme.of(context).colorScheme.primary,
      ),
    );
  }
}
