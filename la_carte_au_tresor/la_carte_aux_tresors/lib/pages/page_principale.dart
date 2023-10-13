import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:la_carte_aux_tresors/modeles/lieu.dart';
import 'package:la_carte_aux_tresors/pages/dialogue_lieu.dart';
import 'package:la_carte_aux_tresors/pages/gerer_lieux.dart';
import 'package:la_carte_aux_tresors/utils/gestion_bdd.dart';
import 'package:location/location.dart';

class PagePrincipale extends StatefulWidget {
  const PagePrincipale({Key? key}) : super(key: key);

  @override
  State<PagePrincipale> createState() => _PagePrincipaleState();
}

class _PagePrincipaleState extends State<PagePrincipale> {
  CameraPosition position = const CameraPosition(
    target: LatLng(50, 3),
    zoom: 12,
  );

  List<Marker> _marqueurs = [];
  List<Lieu>? _lieux;

  GoogleMapController? mapController;
  GestionBdd gestionBdd = GestionBdd();

  Future<LatLng> _lirePositionActuelle() async {
    Location localisation = Location();
    bool serviceActif;
    PermissionStatus autorisationAccordee;
    LocationData donneesLocalisation;
    serviceActif = await localisation.serviceEnabled();
    if (serviceActif) {
      serviceActif = await localisation.requestService();
      if (!serviceActif) {
        return position.target;
      }
      autorisationAccordee = await localisation.hasPermission();
      if (autorisationAccordee == PermissionStatus.denied) {
        autorisationAccordee = await localisation.requestPermission();
        if (autorisationAccordee != PermissionStatus.granted) {
          return position.target;
        }
      }
      donneesLocalisation = await localisation.getLocation();

      LatLng camPostion = LatLng(
          donneesLocalisation.latitude ?? position.target.latitude,
          donneesLocalisation.longitude ?? position.target.longitude);

      mapController?.moveCamera(CameraUpdate.newCameraPosition(
          CameraPosition(target: camPostion, zoom: 12)));

      return camPostion;
    } else {
      return position.target;
    }
  }

  void addMarkerToList(LatLng coord, String titre, String id) {
    Marker marqueur = Marker(
        markerId: MarkerId(id),
        infoWindow: InfoWindow(
          title: titre,
        ),
        position: coord,
        icon: (id == 'positionCourante')
            ? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue)
            : BitmapDescriptor.defaultMarker);

    setState(() {
      _marqueurs.add(marqueur);
    });
  }

  Future<void> _lireDonnees() async {
    _lieux = await gestionBdd.lireLieux();
    _lieux?.forEach((lieu) => addMarkerToList(
        LatLng(lieu.latitude, lieu.longitude),
        lieu.designation,
        '${lieu.idLieu}'));
  }

  Future<void> _insererDonnees(Lieu lieu) async {
    await gestionBdd.insererLieu(lieu);
  }

  Future<int> _detruireLieu(Lieu lieu) async{
    int locationDeletedId = await gestionBdd.detruireLieu(lieu);
    return Future<int>.value(locationDeletedId);
  }

  @override
  void initState() {
    // gestionBdd.chargerLieux().then((value) => null);
    _lirePositionActuelle().then((value) => {
      setState(() {
        try {
          position = CameraPosition(target: value);
          addMarkerToList(value, 'Vous êtes ici !', 'positionCourante');
          _lireDonnees().then((value) => null);
        } catch (error) {
          print("Erreur lors de l'initialisation...");
        }
      })
    }).catchError((error) => print(error));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("La carte aux trésors"),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const GererLieux())
              ).then((value) {
                setState(() {
                  _marqueurs.clear();
                  _lirePositionActuelle().then((value) => addMarkerToList(value, 'Vous êtes ici !', 'positionCourante'));
                  _lireDonnees().then((value) => null);
                });
              });
            }, 
            icon: const Icon(Icons.menu))
        ],
      ),
      body: GoogleMap(
        onMapCreated: (controller) {
          setState(() {
            mapController = controller;
          });
        },
        initialCameraPosition: position,
        markers: Set.of(_marqueurs),
      ),
      floatingActionButton: Stack(
        children: [
          Positioned(
            bottom: 40,
            left: 40,
            child: FloatingActionButton(
              onPressed: (() {
                int markerIndex = _marqueurs.indexWhere((element) => element.markerId.value == 'positionCourante');
                Lieu lieu;

                if(markerIndex == -1) {
                  lieu = Lieu(0, '', 0.0, 0.0, '');
                } else {
                  Marker marker = _marqueurs[markerIndex];
                  lieu = Lieu(0, marker.infoWindow.title as String, marker.position.latitude, marker.position.longitude, '');
                }
                showDialog(
                  context: context, 
                  builder: (context) => DialogueLieu(true, lieu).constuireDialogue(context)
                ).then((value) {
                  setState(() {                  
                    _marqueurs.clear();
                    _lirePositionActuelle().then((value) => addMarkerToList(value, 'Vous êtes ici !', 'positionCourante'));
                    _lireDonnees().then((value) => null);
                  });
                });
              }), 
              child: const Icon(Icons.add_location),            
            )
          )
        ],
      ),
    );
  }
}
