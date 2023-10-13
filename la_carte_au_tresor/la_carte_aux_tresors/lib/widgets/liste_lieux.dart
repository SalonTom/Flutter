import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:la_carte_aux_tresors/modeles/lieu.dart';
import 'package:la_carte_aux_tresors/pages/dialogue_lieu.dart';
import 'package:la_carte_aux_tresors/utils/gestion_bdd.dart';

class ListeLieux extends StatefulWidget {
  const ListeLieux({Key? key}) : super(key: key);

  @override
  State<ListeLieux> createState() => _ListeLieuxState();
}

class _ListeLieuxState extends State<ListeLieux> {

  GestionBdd bdd = GestionBdd();
  List<Lieu> lieux = [];

  @override
  void initState() {
    bdd.lireLieux().then((value) {
      setState(() {  
        lieux = value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: lieux.length,
      itemBuilder: (context, index) {
        return Dismissible(
          key: UniqueKey(),
          onDismissed: (dismiss) {
            bdd.detruireLieu(lieux[index]).then((value) {
              bdd.lireLieux().then((value) {
                setState(() {  
                  lieux = value;
                });
              });

              var snackBar = SnackBar(
                content: Text('${lieux[index].designation} a été effacé'),
              );

              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            });
          }, 
          child : ListTile(
            leading: CircleAvatar(
              backgroundImage: lieux[index].pathToImage != 'assets/lieu_image_par_defaut.jpg' ?
              FileImage(File(lieux[index].pathToImage))
              : const AssetImage('assets/lieu_image_par_defaut.jpg') as ImageProvider
            ),
            title: Text(lieux[index].designation),
            trailing: IconButton(
              onPressed: () {
                showDialog(
                  context: context, 
                  builder: (context) => DialogueLieu(false, lieux[index]).constuireDialogue(context)
                ).then((value) {
                  bdd.lireLieux().then((value) {
                    setState(() {  
                      lieux = value;
                    });
                  });
                });
              },
              icon: const Icon(Icons.edit),
            ),
            subtitle: Text("Latitude : ${lieux[index].latitude} - Longitude : ${lieux[index].longitude}"),
          )
        );
      },
    );
  }
}