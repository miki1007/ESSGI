import 'package:flutter/material.dart';
/*
  USER BIO BOX
  this is the simple bio box with text inside. we will use this for the user bio on the user 
  profile page
  ___________________________________________
  To use this widget you just need :
  -Text
*/

class MyBioBox extends StatelessWidget {
  final String text;
  const MyBioBox({super.key, required this.text});
  //BUILD UI
  @override
  Widget build(BuildContext context) {
    //Container
    return Container(
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary,
          borderRadius: BorderRadius.circular(12)),
      //padding inside
      padding: const EdgeInsets.all(25),
      child: Text(
        text.isNotEmpty ? text : "Empty bio ...",
        style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary),
      ),
    );
  }
}
