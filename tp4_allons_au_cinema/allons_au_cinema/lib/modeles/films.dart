class Film {

  late int id;
  late String titre;
  late double note;
  late String dateDeSortie;
  late String resume;
  late String urlAffiche;

  Film(int idFilm, String titre, double note, String dateDeSortie, String resume, String urlAffiche) {
    this.id = idFilm;
    this.note = note;
    this.dateDeSortie = dateDeSortie;
    this.resume = resume;
    this.urlAffiche = urlAffiche;
  }

  Film.fromJson(Map<String, dynamic> chaineJson) {
    id = chaineJson['id'];
    titre = chaineJson['title'];
    note = chaineJson['vote_average'] * 1.0;
    dateDeSortie = chaineJson['release_date'];
    resume = chaineJson['overview'];
    urlAffiche = chaineJson['poster_path'];
  }
}