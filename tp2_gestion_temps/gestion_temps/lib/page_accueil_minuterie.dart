import 'package:flutter/material.dart';
import 'package:gestion_temps/bouton_generique.dart';
import 'package:gestion_temps/modele_minuteur.dart';
import 'package:gestion_temps/page_parameters.dart';
import 'package:percent_indicator/percent_indicator.dart';

class PageAccueilMinuterie extends StatelessWidget {
  PageAccueilMinuterie({ Key? key }) : super(key: key);

  final Minuteur minuteur = Minuteur();
  final List<PopupMenuItem<String>> elementsMenu = [];

  void allerParametres(BuildContext context) {
    Navigator.push(context,  MaterialPageRoute(
        builder: (_) => const PageParameters()
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    minuteur.demarrerTravail();

    elementsMenu.add(
      const PopupMenuItem(
        value: "Paramètres",
        child: Text("Paramètres"),
      )
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ma gestion du temps"),
        actions: <Widget>[
          PopupMenuButton(
            itemBuilder: (BuildContext context) {
              return elementsMenu.toList();
            },
            onSelected: (s) {
              allerParametres(context);
            },
          )
        ],
      ),
      body: Center(
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            final double largeurDisponible = constraints.maxWidth;
            return Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: BoutonGenerique(couleur: Colors.lightGreen, texte: "Travail", taille: 25.0, action: minuteur.travail),
                    ),
                    Expanded(
                      child: BoutonGenerique(couleur: Colors.blueGrey, texte: "Mini pause", taille: 25.0, action: minuteur.miniPause),
                    ),
                    Expanded(
                      child: BoutonGenerique(couleur: Colors.grey, texte: "Maxi pause", taille: 25.0, action: minuteur.maxiPause),
                    ),
                  ],
                ),
                Expanded(
                  child: StreamBuilder(
                    initialData : ModeleMinuteur('00:00', 1),
                    stream : minuteur.stream(),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      ModeleMinuteur minuteur = snapshot.data;
                      return CircularPercentIndicator(
                        radius: largeurDisponible/2 - 10,
                        lineWidth: 10.0,
                        percent: (minuteur.pourcentage == null) ? 1 : minuteur.pourcentage,
                        center: Text(
                          (minuteur.temps == null) ? '00:00' : minuteur.temps,
                          style: Theme.of(context).textTheme.headline4,
                        ),
                        progressColor: const Color(0xff009688),
                      );
                    }
                  
                  )
                ),
                Row(
                  children: [
                    Expanded(
                      child: BoutonGenerique(couleur: Colors.black, texte: "Arrêter", taille: 25.0, action: minuteur.arreterMinuteur),
                    ),
                    Expanded(
                      child: BoutonGenerique(couleur: Colors.lightGreen, texte: "Relancer", taille: 25.0, action: minuteur.relancerMinuteur),
                    ),
                  ],
                ),

              ],
            );
          }
        ),
      )
    );
  }
}