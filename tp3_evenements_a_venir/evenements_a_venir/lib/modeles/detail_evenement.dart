class DetailEvenement {
  String? id;
  late String _description;
  late String _date;
  late String _heureDebut;
  late String _heureFin;
  late String _animateur;
  late bool? _estFavori;

  DetailEvenement(String? eventId, String description, String date, String heureDebut, String heureFin, String animateur, bool? estFavori) {
    id = eventId;
    _description = description;
    _date = date;
    _heureDebut = heureDebut;
    _heureFin = heureFin;
    _animateur = animateur;
    _estFavori = estFavori;

  }

  String get description {
    return _description;
  }
  String get date {
    return _date;
  }
  String get heureDebut {
    return _heureDebut;
  }
  String get heureFin {
    return _heureFin;
  }
  String get animateur {
    return _animateur;
  }
  bool? get estFavori {
    return _estFavori;
  }

  static DetailEvenement fromMap(dynamic object) {
    return DetailEvenement(object?.id, object['description'], object['date'], object['heure_debut'], object['heure_fin'], object['animateur'], object['est_favir']);
  }

  static Map<String, dynamic> toMap(DetailEvenement evenement) {
    Map<String, dynamic> propertiesMap = <String, dynamic>{};
    propertiesMap['id'] = evenement.id;
    propertiesMap['description'] = evenement.description;
    propertiesMap['date'] = evenement.date;
    propertiesMap['heure_debut'] = evenement.heureDebut;
    propertiesMap['heure_fin'] = evenement.heureFin;
    propertiesMap['animateur'] = evenement.animateur;
    propertiesMap['est_favir'] = evenement.estFavori;

    return propertiesMap;
  }
}
