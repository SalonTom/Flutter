class Lieu {
  late int? idLieu;
  late String designation;
  late double latitude;
  late double longitude;
  late String pathToImage;

  Lieu(int? id, String des, double lat, double long, String image) {
    idLieu = id;
    designation = des;
    latitude = lat;
    longitude = long;
    pathToImage = image;
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> lieuMap = <String, dynamic>{};

    lieuMap['id'] = idLieu;
    lieuMap['designation'] = designation;
    lieuMap['latitude'] = latitude;
    lieuMap['longitude'] = longitude;
    lieuMap['pathToImage'] = pathToImage;

    return lieuMap;
  }

  static Lieu fromMap(dynamic objet) {
    Lieu newLieu = Lieu(objet['id'], objet['designation'], objet['latitude'], objet['longitude'], objet['pathToImage']);
    return newLieu;
  }
}