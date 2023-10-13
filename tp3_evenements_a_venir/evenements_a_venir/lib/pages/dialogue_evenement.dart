import 'package:evenements_a_venir/modeles/detail_evenement.dart';
import 'package:evenements_a_venir/pages/page_evenements.dart';
import 'package:evenements_a_venir/utilitaires/gestion_firebase.dart';
import 'package:flutter/material.dart';

class DialogueEvenement extends StatefulWidget {
  const DialogueEvenement({
    Key? key,
    required this.uidUtilisateur,
    required this.creationOrConsultation,
    required this.evenement
    }) : super(key: key);

  final String? uidUtilisateur;
  final bool creationOrConsultation;
  final DetailEvenement? evenement;
  @override
  State<DialogueEvenement> createState() => _DialogueEvenementState();
}

class _DialogueEvenementState extends State<DialogueEvenement> {

  TextEditingController txtDescription = TextEditingController();
  TextEditingController txtDate = TextEditingController();
  TextEditingController txtHeureDebut = TextEditingController();
  TextEditingController txtHeureFin = TextEditingController();
  TextEditingController txtAnimateur = TextEditingController();

  Widget champForm(String hintText, TextEditingController textController, Icon icon) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: TextFormField(
        controller: textController,
        decoration: InputDecoration(
          hintText: hintText,
          icon: icon,
        ),
      )
    );
  }

  Widget? showMessage(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(message),
        );
      } 
    );   
  }

  void leavePage() {
    Navigator.pushReplacement(context, MaterialPageRoute(
      builder: ((context) => PageEvenements(uidUtilisateur: widget.uidUtilisateur))
      )
    );
  }

  @override
  void initState() {
    if(widget.evenement != null) {
      txtDescription.text = widget.evenement?.description != null ? widget.evenement?.description as String : '';
      txtDate.text = widget.evenement?.date != null ? widget.evenement?.date as String : '';
      txtHeureDebut.text = widget.evenement?.heureDebut != null ? widget.evenement?.heureDebut as String : '';
      txtHeureFin.text = widget.evenement?.heureFin != null ? widget.evenement?.heureFin as String : '';
      txtAnimateur.text = widget.evenement?.animateur != null ? widget.evenement?.animateur as String : '';
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.creationOrConsultation ? "Nouvel événement" : "Modification de l'événement"),
        actions: [
          IconButton(onPressed: leavePage, icon: const Icon(Icons.close)),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          champForm("Description", txtDescription, const Icon(Icons.description)),
          champForm("Date", txtDate, const Icon(Icons.date_range)),
          champForm("Heure de début", txtHeureDebut, const Icon(Icons.hourglass_top)),
          champForm("Heure de fin", txtHeureFin, const Icon(Icons.hourglass_bottom)),
          champForm("Animateur", txtAnimateur, const Icon(Icons.person)),

          ElevatedButton(
            onPressed: () async {
              try {
                if (widget.creationOrConsultation) {
                  GestionFireBase.ajouterEvenement(DetailEvenement(null, txtDescription.text, txtDate.text, txtHeureDebut.text, txtHeureFin.text, txtAnimateur.text, false)).then((value) {
                    showMessage("Evenement bien ajouté !");
                    setState(() {});
                  });
                } else {
                  GestionFireBase.mettreAJourEvenement(DetailEvenement(widget.evenement?.id, txtDescription.text, txtDate.text, txtHeureDebut.text, txtHeureFin.text, txtAnimateur.text, widget.evenement?.estFavori)).then((value) {
                    showMessage("Evenement bien modifié !");
                    setState(() {});
                  });
                }
              } catch (error) {
                showMessage("Erreur ...");
              }
            },
            child: Text(widget.creationOrConsultation ? "Créer un nouvel événement" : "Modifier l'événement")
          )
        ],
      ),
    );
  }
}