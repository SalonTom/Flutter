import 'package:flutter/material.dart';

class Balle extends StatelessWidget {
  Balle({Key? key}) : super(key: key);

  double diametre = 50.0;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: diametre,
      width: diametre,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.yellow
      )
    );
  }
}