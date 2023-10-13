import 'dart:ffi';

import 'package:flutter/material.dart';

class ConvertPage extends StatefulWidget {
  const ConvertPage({ Key? key }) : super(key: key);

  @override
  State<ConvertPage> createState() => _ConvertPageState();
}

class _ConvertPageState extends State<ConvertPage> {
  double _nombreSaisi = 0.0;
  final _valueNumberToConvertEditingController = TextEditingController();
  late String errorText;

  final Map<String, int> _mesuresMap = {
    'mètres': 0,
    'kilomètres': 1,
    'grammes': 2,
    'kilogrammes': 3,
    'pieds': 4,
    'miles': 5,
    'livres': 6,
    'onces': 7
  };

  final dynamic _formules = {
    '0': [1, 0.001, 0, 0, 3.28084, 0.000621371, 0, 0],
    '1': [1000, 1, 0, 0, 3280.84, 0.621371, 0, 0],
    '2': [0, 0, 1, 0.0001, 0, 0, 0.00220462, 0.035274],
    '3': [0, 0, 1000, 1, 0, 0, 2.20462, 35.274],
    '4': [0.3048, 0.0003048, 0, 0, 1, 0.000189394, 0, 0],
    '5': [1609.34, 1.60934, 0, 0, 5280, 1, 0, 0],
    '6': [0, 0, 453.592, 0.453592, 0, 0, 1, 16],
    '7': [0, 0, 28.3495, 0.0283495, 0, 0, 0.0625, 1],
  };

  late String _uniteDepart;
  late String _uniteArrivee;
  String _message = '';

  late double _result;

  @override
  void initState() {
    errorText = '';

    _uniteDepart = _mesuresMap.keys.first;
    _uniteArrivee = _mesuresMap.keys.first;
    super.initState();
  }

  void chooseFirstUnit(String? selectedValue) {
    if (selectedValue is String) {
      setState(() {
        _uniteDepart = selectedValue;
      });
    }
  }
  void chooseSecondUnit(String? selectedValue) {
    if (selectedValue is String) {
      setState(() {
        _uniteArrivee = selectedValue;
      });
    }
  }

  void convertir(double valeur, String depuis, String vers) {
    int numDepuis = _mesuresMap[depuis] ?? 0;
    int numVers = _mesuresMap[vers] ?? 0;
    var multiplicateur = _formules[numDepuis.toString()][numVers];
    var resultat = valeur * multiplicateur;
    String message;
    if (resultat == 0) {
      message = 'Cette conversion ne peut être réalisée!!!';
    } else {
      message =
          '${valeur.toString()} $depuis\n est égal à\n${resultat.toString()} $vers';
    }
    setState(() {
      _message = message;
    });

  }

  final TextStyle styleEntree = TextStyle(
    fontSize: 20,
    color: Colors.blue[900],
  );
  final TextStyle styleLabel = TextStyle(
    fontSize: 20,
    color: Colors.grey[700],
  );


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Convertisseur de Mesures"),
        ),
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          margin: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            children: [
              Text("Valeur à convertir", style: styleEntree),
              const Spacer(),
              TextField(
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                decoration: const InputDecoration(
                  hintText: "Saississez la mesure à convertir"
                ),
                controller: _valueNumberToConvertEditingController,
                onChanged: (value) {
                  try {
                    setState(() {
                      _nombreSaisi = double.tryParse(value) as double;
                      errorText = '';
                    });
                  } catch (error) {
                    setState(() {
                      errorText = "Mauvais type de donnée renseigné...";
                    });
                  }
                }
              ),
              Text(errorText),
              Text("Depuis", style: styleLabel),
              DropdownButton<String>(
                value: _uniteDepart,
                items: _mesuresMap.keys
                    .map((unite) => DropdownMenuItem<String>(
                        value: unite, child: Text(unite)))
                    .toList(),
                onChanged: chooseFirstUnit,
              ),
              const Spacer(),
              Text("Vers", style: styleLabel),
              DropdownButton<String>(
                value: _uniteArrivee,
                items: _mesuresMap.keys
                    .map((unite) => DropdownMenuItem<String>(
                        value: unite, child: Text(unite)))
                    .toList(),
                onChanged: chooseSecondUnit,
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: () {
                  if(_nombreSaisi == 0) {
                    return;
                  } else {
                    convertir(_nombreSaisi, _uniteDepart, _uniteArrivee);
                  }
                },
                child: const Text("Convertir")
              ),
              Text(
                _message?? '',
                textAlign: TextAlign.center,
                style: styleLabel,
              ),
              const Spacer(flex:8)
            ]
        ),
      )
    );
  }
}