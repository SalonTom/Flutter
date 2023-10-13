// ignore_for_file: avoid_print

import 'package:evenements_a_venir/pages/page_evenements.dart';
import 'package:evenements_a_venir/utilitaires/authentification.dart';
import 'package:flutter/material.dart';

class PageConnexion extends StatefulWidget {
  const PageConnexion({Key? key}) : super(key: key);

  @override
  State<PageConnexion> createState() => _PageConnexionState();
}

class _PageConnexionState extends State<PageConnexion> {

  String? _idUtilisateur;
  String? _mdpUtilisateur;
  String? _emailUtilisateur;
  bool _estConnectable = true;
  String? _message;

  TextEditingController txtEmail = TextEditingController();
  TextEditingController txtMdp = TextEditingController();

  late Authentification authentification;

  bool get estConnectable {
    return _estConnectable;
  }

  set estConnectable(value) {
    _estConnectable = value;
  }

  String? get message {
    return _message;
  }

  set message(value) {
    _message = value;
  }

    @override
  void initState() {
    authentification = Authentification();
    super.initState();
  }

  Future<void> soumettre() async {
    message = null;

    try {
      String userUid = estConnectable ? await authentification.connexion(txtEmail.text, txtMdp.text)
       : await authentification.inscription(txtEmail.text, txtMdp.text);
      
      setState(() {
        _idUtilisateur = userUid;
      });
      print('Utilisateur connecté ==> $userUid');

      // ignore: use_build_context_synchronously
      Navigator.pushReplacement(
        context, 
        MaterialPageRoute(
          builder: (context) => PageEvenements(uidUtilisateur : userUid)
        )
      );
    } catch (error) {
      setState(() {
        message = "Erreur. Veuillez vérifier vos identifiants et votre mot de passe.";
        print(error.toString());
      });
    }
  }

  void changerEtat() {
    setState(() {
      estConnectable = !estConnectable;
    });
  }

  Widget saisirEmail() {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child : TextFormField(
        controller: txtEmail,
        keyboardType: TextInputType.emailAddress,
        decoration: const InputDecoration(
          hintText: 'Adresse mail',
          icon: Icon(Icons.mail),
        ), 
      )
    );
  }

  Widget saisirMdp() {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child : TextFormField(
        controller: txtMdp,
        keyboardType: TextInputType.visiblePassword,
        decoration: const InputDecoration(
          hintText: 'Mot de passe',
          icon: Icon(Icons.lock),
        ),
        obscureText: true,
      )
    );
  }

  Widget boutonPrincipal() {
    return ElevatedButton(
      style: ButtonStyle(
        shape : MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20)
          )
        ),
        
      ),
      onPressed: soumettre,
      child: Text(estConnectable ? "Se connecter" : "S'inscrire")
    );
  }

  Widget boutonSecondaire() {
    return TextButton(
      onPressed: changerEtat,
      child: Text(estConnectable ? "Créer un compte" : "Se connecter")
    );
  }

  Widget messageValidation() {
    return Text(message != null ? '$message' : '');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(estConnectable ? "Page de connexion" : "Page d'inscritpion"),
      ),
      body : Form(
        child: Padding(
          padding: const EdgeInsets.all(15.0), 
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              saisirEmail(),
              saisirMdp(),
              boutonPrincipal(),
              boutonSecondaire(),
              messageValidation()
            ]
          ),
        )
      )
    );
  }
}