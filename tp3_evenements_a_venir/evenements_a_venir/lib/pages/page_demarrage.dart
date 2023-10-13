import 'dart:async';

import 'package:evenements_a_venir/pages/page_connexion.dart';
import 'package:evenements_a_venir/pages/page_evenements.dart';
import 'package:evenements_a_venir/utilitaires/authentification.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class PageDemarrage extends StatefulWidget {
  const PageDemarrage({Key? key}) : super(key: key);

  @override
  State<PageDemarrage> createState() => _PageDemarrageState();
}

class _PageDemarrageState extends State<PageDemarrage> {

  late Widget pageToShow;
  Authentification authentification = Authentification();


  @override
  void initState() {
    User? user;
    authentification.lireUtilisateur().then((value) {
      user = value;
      MaterialPageRoute materialPageRoute;
      if (user != null) {
        materialPageRoute =
            MaterialPageRoute(builder: (context) => PageEvenements(uidUtilisateur : user?.uid));
      } else {
        materialPageRoute =
            MaterialPageRoute(builder: (context) => const PageConnexion());
      }
      Navigator.pushReplacement(context, materialPageRoute);
    });
    
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return const CircularProgressIndicator();
  }
}