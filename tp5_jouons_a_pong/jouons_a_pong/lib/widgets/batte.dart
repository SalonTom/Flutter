import 'package:flutter/material.dart';

class Batte extends StatelessWidget {
  const Batte({
    Key? key,
    required this.batteHeight,
    required this.batteWidth
  }) : super(key: key);

  final double batteHeight;
  final double batteWidth;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: batteHeight,
      width: batteWidth,
      decoration: const BoxDecoration(color: Colors.blue),
    );
  }
}