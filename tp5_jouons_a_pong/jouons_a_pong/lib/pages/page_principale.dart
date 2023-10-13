import 'dart:math';

import 'package:flutter/material.dart';
import 'package:jouons_a_pong/widgets/balle.dart';
import 'package:jouons_a_pong/widgets/batte.dart';

enum Direction { haut, bas, gauche, droite }

class PagePrincipale extends StatefulWidget {
  const PagePrincipale({Key? key}) : super(key: key);

  @override
  State<PagePrincipale> createState() => _PagePrincipaleState();
}

class _PagePrincipaleState extends State<PagePrincipale> with SingleTickerProviderStateMixin {
  double largeur = 400;
  double hauteur = 400;
  double posX = 0;
  double posY = 0;
  double largeurBatte = 0;
  double hauteurBatte = 0;
  double positionBatte = 0;

  int score = 0;

  late Animation animation;
  late AnimationController controleur;

  Direction vDir = Direction.bas;
  Direction hDir = Direction.droite;

  int increment = 10;

  bool scoreWasUpdated = false;

  double randX = 1;
  double randY = 1;

  @override
  void initState() {
    posX = 0;
    posY = 0;
    controleur = AnimationController(
      duration: const Duration(minutes: 10000),
      vsync: this,
    );

    animation = Tween<double>(begin: 0, end: 100).animate(controleur);
    animation.addListener(() {
      safeSetState(() {
        (hDir == Direction.droite)
            ? posX += ((increment * randX).round())
            : posX -= ((increment * randX).round());
        (vDir == Direction.bas)
            ? posY += ((increment * randY).round())
            : posY -= ((increment * randY).round());
      });
      testerBordures();
    });

    controleur.forward();
    super.initState();
  }

  @override
  void dispose() {
    controleur.dispose();
    super.dispose();
  }

  void testerBordures() {
    if(posX + 50 >= largeur){      
        hDir = Direction.gauche;
        randX = nombreAleatoire();
    } else if(posX <= 0) {      
        hDir = Direction.droite;
        randX = nombreAleatoire();
    }

    if(posY + 50 >= hauteur - hauteurBatte) {
      if(posX >= positionBatte && posX <= positionBatte + largeurBatte) {
        vDir = Direction.haut;

        if(!scoreWasUpdated) {
          score ++;
          scoreWasUpdated = true;
        }

        randY = nombreAleatoire();
      } else if(posY + 50 >= hauteur) {
        controleur.stop();
        afficherMessage(context);
      }
    } else if (posY <= 0) {
      vDir = Direction.bas;
      scoreWasUpdated = false;

      randY = nombreAleatoire();
    }
  }

  
  void deplacerBatte(DragUpdateDetails details, BuildContext context) {
    safeSetState(() {
      positionBatte = (positionBatte + details.delta.dx < 0) ? 
      0 : (positionBatte + details.delta.dx + largeurBatte > largeur) ? largeur - largeurBatte : positionBatte + details.delta.dx;
    });
  }

  void safeSetState(Function function) {
    if (mounted && controleur.isAnimating) {
      setState(() {
        function();
      });
    }
  }

  void afficherMessage(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Perdu ..."),
          content: const Text("On relance une partie ?"),
          actions: [
            TextButton(
              onPressed: (){
                Navigator.pop(context);
                dispose();
              }, 
              child: const Text("Arrêter")
            ),
            ElevatedButton(
              onPressed: (){
                setState(() {
                  posX = 0;
                  posY = 0;
                  score = 0;
                  Navigator.pop(context);
                  controleur.repeat();
                });
              }, 
              child: const Text("Relancer")),
          ],
        );
      },
    );
  }

  double nombreAleatoire() {
    return (Random().nextInt(151) + 50) / 100;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        hauteur = constraints.maxHeight;
        largeur = constraints.maxWidth;
        largeurBatte = largeur / 5;
        hauteurBatte = hauteur / 20;

        return Stack(
          children: [
            Positioned(
              top: posY,
              left : posX,
              child: Balle(),
            ),
            Positioned(
              bottom: 0,
              left: positionBatte,
              child: GestureDetector(
                onHorizontalDragUpdate: (details) {
                  deplacerBatte(details, context);
                },
                child: Batte(batteHeight: hauteurBatte, batteWidth: largeurBatte),
              )
              
            ),
            Positioned(
              top: 0,
              right: 10,
              child: Text(
                'Score : $score',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20
                ),
              ),
            )
          ],
        );
      },
    );
  }

}
