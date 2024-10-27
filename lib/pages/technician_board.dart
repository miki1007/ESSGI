import 'package:flutter/material.dart';
import 'package:pro/component/my_drawer.dart';

class TechnicianBoard extends StatefulWidget {
  const TechnicianBoard({super.key});

  @override
  State<TechnicianBoard> createState() => _TechnicianBoardState();
}

class _TechnicianBoardState extends State<TechnicianBoard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        drawer: MyDrawer(),
        appBar: AppBar(
          title: const Text('Technician board'),
          foregroundColor: Theme.of(context).colorScheme.primary,
        ));
  }
}
