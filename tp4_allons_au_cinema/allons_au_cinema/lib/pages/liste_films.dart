import 'package:allons_au_cinema/modeles/films.dart';
import 'package:allons_au_cinema/pages/detail_film.dart';
import 'package:allons_au_cinema/utils/http_helper.dart';
import 'package:flutter/material.dart';

class ListeFilms extends StatefulWidget {
  const ListeFilms({Key? key,}) : super(key: key);
  @override
  State<ListeFilms> createState() => _ListeFilmsState();
}

class _ListeFilmsState extends State<ListeFilms> {

  final HttpHelper httpHelper = HttpHelper();
  int filmsCount = 0;
  List<dynamic> listeFilms = [];

  final String iconBase = 'https://image.tmdb.org/t/p/w92/';
  final String imageParDefaut = 'https://images.freeimages.com/images/large-previews/5eb/movieclapboard-1184339.jpg';

  Future<void> initialiser() async {
    var films = await httpHelper.recevoirNouveauxFilms();
    setState(() {
      filmsCount = listeFilms.length;
      listeFilms = films;
    });
  }

  void openFilmDetail(Film film){
    Navigator.push(context,
      MaterialPageRoute(
        builder: ((context) => DetailFilm(film: film))
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    initialiser().then((value) => null);
    NetworkImage image;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Films"),
      ),
      body: ListView.builder(
        itemCount: filmsCount == null ? 0 : filmsCount,
        itemBuilder: (context, index) {
          image = listeFilms[index].urlAffiche != null ? NetworkImage(iconBase + listeFilms[index].urlAffiche) : NetworkImage(imageParDefaut);
          return Card(
            child: ListTile(
              onTap: () {
                openFilmDetail(listeFilms[index]);
              },
              leading: CircleAvatar(
                backgroundImage: image,
              ),
              title: Text(listeFilms[index].titre + ''),
              subtitle: Text('Date de sortie : ${listeFilms[index].dateDeSortie} - Note : ${listeFilms[index].note}'),
            ),
          );
        },
      ),
    );
  }
}