class Favori {
  String? id;
  String? _uid;
  String? _eventId;
  
  Favori(String? favoriId, String? uid, String? eventId) {
    id = favoriId;
    _uid = uid;
    _eventId = eventId;
  }

  String? get uid {
    return _uid;
  }

  String? get eventId {
    return _eventId;
  }

  static Favori fromMap(dynamic object) {
    return Favori(object.id, object['id_utilisateur'], object['id_evenement']);
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> propertiesMap = <String, dynamic>{};
    propertiesMap['id_utilisateur'] = uid;
    propertiesMap['id_evenement'] = eventId;

    return propertiesMap;
  }
}