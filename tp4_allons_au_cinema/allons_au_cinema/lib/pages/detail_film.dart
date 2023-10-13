import 'dart:ui';

import 'package:allons_au_cinema/modeles/films.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class DetailFilm extends StatelessWidget {
  const DetailFilm({
    Key? key,
    required this.film,
  }) : super(key: key);

  final Film film;
  final urlBaseAffiche = 'https://image.tmdb.org/t/p/w92/';

  @override
  Widget build(BuildContext context) {
    String chemin;
    var screenSize = MediaQuery.of(context).size;

    if (film.urlAffiche != null) {
      chemin = urlBaseAffiche + film.urlAffiche;
    } else {
      chemin =
          'https://images.freeimages.com/images/large-previews/5eb/movie-clapboard1184339.jpg';
    }
    return Scaffold(
        appBar: AppBar(
          title: Text(film.titre),
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(children: [
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Image.network(
                    chemin,
                    height: screenSize.height / 1.5,
                    fit: BoxFit.fill,
                  ),
                ),
                Text(film.resume)
              ]),
            ),
          ),
        ));
  }
}
