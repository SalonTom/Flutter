import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evenements_a_venir/modeles/detail_evenement.dart';
import 'package:evenements_a_venir/modeles/favori.dart';
import 'package:evenements_a_venir/pages/dialogue_evenement.dart';
import 'package:flutter/material.dart';
import 'package:evenements_a_venir/utilitaires/gestion_firebase.dart';

const double FONT_SIZE = 15.0;

class ListeEvenements extends StatefulWidget {
  const ListeEvenements({
    Key? key,
    required this.uidUtilisateur,
  }) : super(key: key);

  final String? uidUtilisateur;

  @override
  State<ListeEvenements> createState() => _ListeEvenementsState();
}

class _ListeEvenementsState extends State<ListeEvenements> {

  List<DetailEvenement> listeEvenements = [];
  late List<Favori> favoris;

  FirebaseFirestore bdd = FirebaseFirestore.instance;

  @override
  void initState() {
    if (mounted) {
      GestionFireBase.lireListeDetails().then((details) {
        setState(() {
          listeEvenements = details;
        });
      });

      GestionFireBase.lireFavoris(widget.uidUtilisateur).then((value) {
        setState(() {
          favoris = value;
        });
      });
      super.initState();
    }
  }

  bool estFavori(String? idEvenement) {
    bool ans = false;
    if(favoris.isNotEmpty) {
      Favori favori = favoris.firstWhere(
        (favori) => (favori.eventId == idEvenement),
        orElse: () => Favori("0", "0", "0")
      );

      if(favori.eventId != "0") ans = true;
    }

    return ans;
  }

  @override
  Widget build(BuildContext context) {

    void basculerEtatFavori(DetailEvenement detail) async {
      if(estFavori(detail.id)) {
        Favori favori = favoris.firstWhere((favori) => (favori.eventId == detail.id));
        String? idFavori = favori.id;

        await GestionFireBase.detruireFavori(idFavori ?? "ID Inconnu");
      } else {
        await GestionFireBase.ajouterFavori(detail, widget.uidUtilisateur as String);
      }

      List<Favori> majFavoris = await GestionFireBase.lireFavoris(
        widget.uidUtilisateur
      );

      setState(() {
        favoris = majFavoris;
      });
    }

    void goToEditPage(DetailEvenement evenement) {
      Navigator.pushReplacement(context, MaterialPageRoute(
        builder: ((context) => DialogueEvenement(uidUtilisateur: widget.uidUtilisateur, creationOrConsultation: false, evenement: evenement))
        )
      );
    }
    
    return ListView.builder(
      itemCount: listeEvenements.length,
      itemBuilder: (context, index) {
        return ListTile(
          onLongPress: () => {
            goToEditPage(listeEvenements[index])
          },
          title: Text(listeEvenements[index].description),
          subtitle: Text(
              '${listeEvenements[index].date} - De ${listeEvenements[index].heureDebut} à ${listeEvenements[index].heureFin}',
              style: const TextStyle(
                color: Colors.grey,
                fontSize: FONT_SIZE,
            ),
          ),
          trailing: IconButton(
            icon: Icon(
              estFavori(listeEvenements[index].id) ? Icons.star : Icons.star_border_outlined,
              color: estFavori(listeEvenements[index].id) ? Colors.orangeAccent : Colors.grey,
            ),
            onPressed: () {
              basculerEtatFavori(listeEvenements[index]);
            },
          )
        );
      }
    );
  }
}