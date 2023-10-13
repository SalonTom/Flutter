import 'package:evenements_a_venir/modeles/favori.dart';
import 'package:evenements_a_venir/pages/dialogue_evenement.dart';
import 'package:evenements_a_venir/pages/liste_evenements.dart';
import 'package:evenements_a_venir/pages/page_connexion.dart';
import 'package:evenements_a_venir/utilitaires/authentification.dart';
import 'package:flutter/material.dart';

class PageEvenements extends StatefulWidget {
  PageEvenements({
    Key? key,
    required this.uidUtilisateur,
  }) : super(key: key);
  
  final String? uidUtilisateur;

  @override
  State<PageEvenements> createState() => _PageEvenementsState();
}

class _PageEvenementsState extends State<PageEvenements> {

  Authentification authentification = Authentification();

  Future<void> logOut() async {
    await authentification.deconnexion();
    // ignore: use_build_context_synchronously
    Navigator.pushReplacement(
        context, 
        MaterialPageRoute(
          builder: (context) => const PageConnexion()
        )
      );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("Mes événements à venir"),
        actions: [
          IconButton(
            onPressed: logOut,
            icon:const Icon(Icons.logout)
          )
        ],
      ),
      body: ListeEvenements(uidUtilisateur: widget.uidUtilisateur,),
      floatingActionButton: FloatingActionButton(
        onPressed: () => {
          Navigator.pushReplacement(context, MaterialPageRoute(
            builder: (context) => DialogueEvenement(uidUtilisateur: widget.uidUtilisateur, creationOrConsultation: true, evenement: null,)
          ))
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}