import 'package:flutter/material.dart';
import 'package:la_carte_aux_tresors/utils/gestion_bdd.dart';
import 'package:la_carte_aux_tresors/widgets/liste_lieux.dart';

class GererLieux extends StatefulWidget {
  const GererLieux({Key? key}) : super(key: key);

  @override
  State<GererLieux> createState() => _GererLieuxState();
}

class _GererLieuxState extends State<GererLieux> {

  GestionBdd gestionBdd = GestionBdd();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Gérer lieux"),
      ),
      body: const ListeLieux(),
    );
  }
}