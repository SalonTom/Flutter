import 'dart:io';

import 'package:flutter/material.dart';
import 'package:la_carte_aux_tresors/modeles/lieu.dart';
import 'package:la_carte_aux_tresors/pages/page_camera.dart';
import 'package:la_carte_aux_tresors/utils/gestion_bdd.dart';

class DialogueLieu {

  final TextEditingController txtDes = TextEditingController();
  final TextEditingController txtLat = TextEditingController();
  final TextEditingController txtLon = TextEditingController();

  final bool estNouveau;
  final Lieu lieu;


  GestionBdd gestionBdd = GestionBdd();

  DialogueLieu(this.estNouveau, this.lieu);

  Widget afficherImage() {
    return estNouveau ? Container() : Image(
        image: lieu.pathToImage != 'assets/lieu_image_par_defaut.jpg' ?
              FileImage(File(lieu.pathToImage))
              : const AssetImage('assets/lieu_image_par_defaut.jpg') as ImageProvider
    );
  }

  Widget afficherBoutonPhoto(BuildContext context) {
    return estNouveau
        ? Container()
        : IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => PageCamera(lieu: lieu)));
            },
            icon: const Icon(Icons.camera_front));
  } 

  Widget constuireDialogue(BuildContext context) {

    txtDes.text = estNouveau ? 'Nouveau Lieu' : lieu.designation;
    txtLat.text = '${lieu.latitude}';
    txtLon.text = '${lieu.longitude}';

    return AlertDialog(
      title: Text(estNouveau ? "Nouvel Endroit" : "Modifier le lieu"),
      content: SingleChildScrollView(
        child: Column(
          children: [
            TextField(
              controller: txtDes,
              decoration: const InputDecoration(
                hintText: 'Designation',
              ),
            ),
            TextField(
              controller: txtLat,
            keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                hintText: 'Latitude',
              ),
            ),
            TextField(
              controller: txtLon,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                hintText: 'Longitude',
              ),
            ),
            afficherImage(),
            afficherBoutonPhoto(context),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children : [
                ElevatedButton(
                  onPressed: (){
                    Navigator.pop(context);
                  }, 
                  child: const Text("Annuler")
                ),
                ElevatedButton(
                  onPressed: (){
                    lieu.designation = txtDes.text;
                    lieu.latitude = double.tryParse(txtLat.text) as double;
                    lieu.longitude = double.tryParse(txtLon.text) as double;

                    if(estNouveau) {
                      lieu.idLieu = null;
                      lieu.pathToImage = 'assets/lieu_image_par_defaut.jpg';
                      gestionBdd.insererLieu(lieu).then((value) {
                        Navigator.pop(context);
                      });
                    } else {
                      gestionBdd.modifierLieu(lieu).then((value) {
                        Navigator.pop(context);
                      });
                    }
                  }, 
                  child: const Text("Enregistrer")
                ),
              ]
            )
          ],
        ),
      ),
    );
  }
}

