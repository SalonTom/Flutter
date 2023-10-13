import 'package:flutter/material.dart';
import 'package:gestion_temps/page_accueil_minuterie.dart';

const double REMPLISSAGE_DEFAUT = 5.0;

const String CLE_TEMPS_TRAVAIL = 'Temps de travail';
const String CLE_PAUSE_COURTE = 'Pause courte';
const String CLE_PAUSE_LONGUE = 'Pause longue';

const int TEMPS_TRAVAIL_DEFAUT = 25;
const int TEMPS_PAUSE_COURTE_DEFAUT = 5;
const int TEMPS_PAUSE_LONGUE_DEFAUT = 20;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: PageAccueilMinuterie(),
    );
  }
}
