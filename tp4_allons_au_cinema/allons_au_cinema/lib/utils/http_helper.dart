import 'dart:convert';
import 'dart:io';

import 'package:allons_au_cinema/modeles/films.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class HttpHelper {
  final String urlBase = 'https://api.themoviedb.org/3/movie';
  final String urlCmd = '/upcoming?';
  final String urlKey = 'api_key=c3bc42894ee25712459056a6bd4110fb';
  final String urlLangage = '&language=fr-FR';

  Future<List<dynamic>> recevoirNouveauxFilms() async {
    String urlNouveauxFilms = urlBase + urlCmd + urlKey + urlLangage;
    http.Response resultat = await http.get(Uri.parse(urlNouveauxFilms));

    if (resultat.statusCode == HttpStatus.ok) {
      final chaineJson = json.decode(resultat.body);
      final filmsMap = chaineJson['results'];
      List films = filmsMap.map((film) => Film.fromJson(film)).toList();
      return films;
    } else {
      return [];
    }

  }
}