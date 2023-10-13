import 'package:flutter/material.dart';

typedef CallbackSetting = void Function(String, int);

class BoutonParameter extends StatelessWidget {
  final Color couleur;
  final String texte;
  final int valeur;
  final String parametre;
  final Function() callback;

  const BoutonParameter({
    Key? key, 
    required this.couleur, 
    required this.texte, 
    required this.valeur, 
    required this.parametre, 
    required this.callback,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      child: Text(
        texte,
        style: const TextStyle(color: Colors.white),
      ),
      onPressed: callback,
      color: couleur,
    );
  }
}