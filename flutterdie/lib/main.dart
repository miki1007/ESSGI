import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(
    MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.red,
        appBar: AppBar(
          title: const Text('Dice app'),
          backgroundColor: Colors.white,
        ),
        body: const Dicepage(),
      ),
    ),
  );
}

class Dicepage extends StatefulWidget {
  const Dicepage({super.key});

  @override
  State<Dicepage> createState() => _DicepageState();
}

class _DicepageState extends State<Dicepage> {
  int leftdice = 5;
  int rightdice = 3;
  void changediestate(){
    setState(() {
      leftdice = Random().nextInt(6) + 1;

      rightdice = Random().nextInt(6) + 1;
    });

  }
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextButton(
              onPressed: () {
                changediestate();

              },
              child: Image.asset('images/dice$leftdice.png'),

            ),
          ),
          Expanded(
            child: TextButton(
              onPressed: () {
            changediestate();
              },
              child: Image.asset('images/dice$rightdice.png'),
            ),
          ),
        ],
      ),
    );
  }
}