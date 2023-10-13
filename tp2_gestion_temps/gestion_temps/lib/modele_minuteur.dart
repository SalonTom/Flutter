import 'dart:async';

class ModeleMinuteur {
  String temps;
  double pourcentage;

  ModeleMinuteur(this.temps, this.pourcentage);
}

class Minuteur {
  double _rayon = 1;
  bool _estActif = true;
  Duration _temps = const Duration();
  Duration _tempsTotal = const Duration();

  int tempsTravail = 30;
  int tempsPauseCourte = 5;
  int tempsPauseLongue = 20;

  get pourcentage => (_tempsTotal.inMinutes > 0) ? _temps.inMinutes/_tempsTotal.inMinutes : null;

  String retournerTemps(Duration t) {
    String minutes = (t.inMinutes < 10) ? '0${t.inMinutes}' : '${t.inMinutes}';
    int numSeconds = t.inSeconds - (t.inMinutes*60);
    String seconds = (numSeconds < 10) ? '0$numSeconds' : '$numSeconds';

    return '$minutes:$seconds';
  }

  Stream<ModeleMinuteur> stream() async* {
    yield* Stream.periodic(const Duration(seconds: 1), (int a) {
      String temps;
      if (_estActif) {
        _temps = _temps - const Duration(seconds: 1);
        _rayon = _temps.inSeconds / _tempsTotal.inSeconds;
        if (_temps.inSeconds <= 0) {
          _estActif = false;
        }
      }
      temps = retournerTemps(_temps);
      return ModeleMinuteur(temps, _rayon);
    });
 }

  void demarrerTravail() {
    _temps = Duration(minutes : tempsTravail);
    _tempsTotal = Duration(minutes : tempsTravail);
  }

  void arreterMinuteur() {
    _estActif = false;
  }

  void relancerMinuteur() {
    _estActif = true;
  }

  void travail() {
    _tempsTotal = Duration(minutes : tempsTravail);
    _temps = Duration(minutes: tempsTravail);
  }

  void miniPause() {
    _tempsTotal = Duration(minutes : tempsPauseCourte);
    _temps = Duration(minutes: tempsPauseCourte);
  }

  void maxiPause() {
    _tempsTotal = Duration(minutes : tempsPauseLongue);
    _temps = Duration(minutes: tempsPauseLongue);
  }
}