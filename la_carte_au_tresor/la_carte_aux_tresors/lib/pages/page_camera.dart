import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:la_carte_aux_tresors/modeles/lieu.dart';
import 'package:la_carte_aux_tresors/pages/page_image.dart';

class PageCamera extends StatefulWidget {
  PageCamera({
    Key? key,
    required this.lieu,
  }) : super(key: key);

  Lieu lieu;

  @override
  State<PageCamera> createState() => _PageCameraState();
}

class _PageCameraState extends State<PageCamera> {

  late Lieu lieu;
  late CameraController _controleur;
  late List<CameraDescription> cameras;
  late CameraDescription camera;
  CameraPreview? apercuCamera;
  late Image image;

  Future<CameraDescription> definirCamera() async {
    var cameras = await availableCameras();
    if(cameras.isNotEmpty) {
      camera = cameras.first;
      return Future<CameraDescription>.value(camera);
    }
    return Future<CameraDescription>.value(null);
  }

  @override
  void initState() {
    lieu = widget.lieu;
    definirCamera().then((value) {
      _controleur = CameraController(value, ResolutionPreset.medium);
      _controleur.initialize().then((value) {
        setState(() {
          apercuCamera = CameraPreview(_controleur);
        });
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _controleur.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Prendre une photo"),
      ),
      body: Column(
        children : [
          Container(child: apercuCamera),
          const Spacer(),
          Container(
            width: MediaQuery.of(context).size.width/2,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color:Colors.black)
            ),
            child : IconButton(
              onPressed: () {
                _controleur.takePicture().then((value) {
                  lieu.pathToImage = value.path;
                  Navigator.pushReplacement(
                    context, 
                    MaterialPageRoute(builder: (context) => PageImage(imagePath: lieu.pathToImage, lieu: lieu)));
                });
              }, 
              icon: const Icon(Icons.add_a_photo_outlined)),
          ),
          const Spacer()
        ]
      )
    );
  }
}