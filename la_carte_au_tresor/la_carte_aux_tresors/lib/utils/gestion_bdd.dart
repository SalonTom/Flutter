// ignore_for_file: avoid_print

import 'package:la_carte_aux_tresors/modeles/lieu.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class GestionBdd {
  int databaseVersion = 1;
  Database? _bdd;
  static final GestionBdd _instance = GestionBdd._createInstance();
  final String baseInsertQuery = 'INSERT INTO lieux (id, designation, latitude, longitude, pathToImage) VALUES';

  GestionBdd._createInstance();

  factory GestionBdd() {
    return _instance;
  }

  //Initialisela connxion avec la base de données.
  Future<Database> ouvrirBdd() async {
    String requestTableCreation = 'CREATE TABLE lieux (id INTEGER PRIMARY KEY, designation VARCHAR(255), latitude DOUBLE, longitude DOUBLE, pathToImage TEXT)';
    // ignore: prefer_conditional_assignment
    if (_bdd == null) {
      _bdd = await openDatabase(
        join(await getDatabasesPath(), 'tresors.db'),
        onCreate: (bdd, databaseVersion) {
          bdd.execute(requestTableCreation);
        }, version: databaseVersion);
    }
    return Future<Database>.value(_bdd);
  }

  // Insère des données par défaut dans la base de données.
  Future<void> chargerLieux() async {
    await ouvrirBdd();
    List<String> lieuxParDefaut = [
      "(null, 'Mairie de Loos', ${50.6151}, ${3.01481}, 'assets/lieu_image_par_defaut.jpg')",
      "(null, 'Decathlon Campus', ${50.6459}, ${3.1421}, 'assets/lieu_image_par_defaut.jpg')",
      "(null, 'Imt Nord Europe Site de Lille', ${50.61148}, ${3.13478}, 'assets/lieu_image_par_defaut.jpg')",
    ];
    lieuxParDefaut.forEach((lieuParDefaut) {
      _bdd?.execute("$baseInsertQuery $lieuParDefaut").then((value) => null);
    });
  }

  //Récupère les lieux présents en base.
  Future<List<Lieu>> lireLieux() async {
    await ouvrirBdd();
    List? locations = await _bdd?.query('lieux');
    List<Lieu>? lieux = locations?.map((location) => Lieu.fromMap(location)).toList();

    return Future<List<Lieu>>.value(lieux);
  }

  //Ajout d'un lieu en base.
  Future<void> insererLieu(Lieu lieu) async {
    await ouvrirBdd();
    // await _bdd?.execute("$baseInsertQuery (null,${lieu.designation},${lieu.latitude},${lieu.longitude},'${lieu.pathToImage == '' ? 'assets/lieu_image_par_defaut.jpg' : lieu.pathToImage}')");
    await _bdd?.insert('lieux', lieu.toMap());
  }

  //Modification d'un lieu en base.
  Future<void> modifierLieu(Lieu lieu) async {
    await ouvrirBdd();
    await _bdd?.update('lieux', lieu.toMap(), where: 'id = ?', whereArgs: [lieu.idLieu]);
  }

  //Suppression d'un lieu en base à partir de sa designation.
  Future<int> detruireLieu(Lieu lieu) async {
    await ouvrirBdd();
    int? locationDeletedId = await _bdd?.delete(
      'lieux', 
      where: 'id = ?',
      whereArgs: [lieu.idLieu]
    );
    return Future<int>.value(locationDeletedId);
  }

}