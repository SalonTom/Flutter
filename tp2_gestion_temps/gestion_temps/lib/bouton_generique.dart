import 'package:flutter/material.dart';
class BoutonGenerique extends StatelessWidget {
  final Color couleur;
  final String texte;
  final double taille;
  final VoidCallback action;
  const BoutonGenerique({
    Key? key,
    required this.couleur,
    required this.texte,
    required this.taille,
    required this.action,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child : MaterialButton(
        child: Text(
          texte,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
        onPressed: action,
        color: couleur,
        minWidth: taille,
      ),
    );
  }
}