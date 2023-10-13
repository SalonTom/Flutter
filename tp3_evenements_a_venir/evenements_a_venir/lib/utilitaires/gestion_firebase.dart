import 'package:evenements_a_venir/modeles/detail_evenement.dart';
import 'package:evenements_a_venir/modeles/favori.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class GestionFireBase {
  static FirebaseFirestore bdd = FirebaseFirestore.instance;

  static Future<List<DetailEvenement>> lireListeDetails() async {
    var data = await bdd.collection('details_evenement').get();
    var details = data.docs.map((detail) => DetailEvenement.fromMap(detail)).toList();
    return details;
  }

  static Future ajouterFavori(DetailEvenement detail, String uid) {
    Favori favori = Favori(null, uid, detail.id);
    var resultat = bdd
        .collection('favoris')
        .add(favori.toMap())
        .then((value) => print(value))
        .catchError((error) => print(error));
    return resultat;
  }

  static Future detruireFavori(String idFavori) async {
    await bdd.collection('favoris').doc(idFavori).delete();
  }

  static Future<List<Favori>> lireFavoris(String? uidUtilisateur) async {
    List<Favori> favoris;
    QuerySnapshot data = await bdd.collection('favoris').where('id_utilisateur', isEqualTo: uidUtilisateur).get();
    favoris = data.docs.map((favori) => Favori.fromMap(favori)).toList();
    
    return favoris;
  }

  static Future ajouterEvenement(DetailEvenement evenement) {
    var resultat = bdd
    .collection('details_evenement')
    .add(DetailEvenement.toMap(evenement))
    .then((valeur) => print(valeur))
    .catchError((error) => print(error));
    return resultat;
  }

  static Future mettreAJourEvenement(DetailEvenement evenement) async {
    var resultat = bdd
    .collection('details_evenement')
    .doc(evenement.id)
    .set(DetailEvenement.toMap(evenement))
    .catchError((error) => print(error));
    return resultat;
  }

}