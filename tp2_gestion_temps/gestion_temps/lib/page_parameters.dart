import 'package:flutter/material.dart';
import 'package:gestion_temps/barre_parameter.dart';
import 'package:gestion_temps/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PageParameters extends StatefulWidget {
  const PageParameters({Key? key}) : super(key: key);

  @override
  State<PageParameters> createState() => _PageParametersState();
}

class _PageParametersState extends State<PageParameters> {

  String tempsTravail = '30';
  String tempsPauseCourte = '5';
  String tempsPauseLongue = '20';

  late BarreParameter gestionTempsTravail = BarreParameter(parameter: tempsTravail, title: "Temps de travail", valeur: 5, callback: refresh, majKey: CLE_TEMPS_TRAVAIL);
  late BarreParameter gestionTempsMiniPause = BarreParameter(parameter: tempsPauseCourte, title: "Temps de mini pause", valeur: 1, callback: refresh, majKey: CLE_PAUSE_COURTE);
  late BarreParameter gestionTempsMaxiPause = BarreParameter(parameter: tempsPauseLongue, title: "Temps de maxi pause", valeur: 2, callback: refresh, majKey: CLE_PAUSE_LONGUE);

  refresh(String parametre, String majKey) {
    setState(() {
      switch (majKey) {
        case CLE_TEMPS_TRAVAIL:
          gestionTempsTravail.parameter = parametre;
          break;
        case CLE_PAUSE_COURTE:
          gestionTempsMiniPause.parameter = parametre;
          break;
        case CLE_PAUSE_LONGUE:
          gestionTempsMaxiPause.parameter = parametre;
          break;
      }
    });
  }

  @override
  void initState() {
    tempsTravail = tempsTravail;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Paramètres'),
      ),
      body: GridView.count(
        crossAxisCount: 1,
        scrollDirection: Axis.vertical,
        childAspectRatio: 4,
        mainAxisSpacing: 15,
        crossAxisSpacing: 10,
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: gestionTempsTravail,
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: gestionTempsMiniPause,
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: gestionTempsMaxiPause,
          ),
        ],

      ),
    );
  }
}