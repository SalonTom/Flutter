import 'dart:io';
import 'package:flutter/material.dart';
import 'package:la_carte_aux_tresors/modeles/lieu.dart';
import 'package:la_carte_aux_tresors/pages/page_principale.dart';
import 'package:la_carte_aux_tresors/utils/gestion_bdd.dart';

class PageImage extends StatelessWidget {
  const PageImage({
    Key? key,
    required this.imagePath,
    required this.lieu,
  }) : super(key: key);

  final String imagePath;
  final Lieu lieu;
  
  @override
  Widget build(BuildContext context) {

    GestionBdd gestionBdd = GestionBdd();

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              gestionBdd.modifierLieu(lieu).then((value) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const PagePrincipale())
                );
              });
            },
            icon: const Icon(Icons.save)),
        ],
        title: const Text("Visualisation de la photo"),
      ),
      body: Image(image: FileImage(File(imagePath))),
    );
  }
}