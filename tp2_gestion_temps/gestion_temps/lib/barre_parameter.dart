import 'package:flutter/material.dart';
import 'package:gestion_temps/bouton_parameter.dart';

typedef CallbackSetting = void Function(String, int);

class BarreParameter extends StatefulWidget {
  BarreParameter({
    Key? key,
    required this.title,
    required this.valeur,
    required this.parameter,
    required this.callback,
    required this.majKey,
  }) : super(key: key);

  final String title;
  final int valeur;
  final Function callback;
  final String majKey;
  String parameter;

  @override
  State<BarreParameter> createState() => _BarreParameterState();
}

class _BarreParameterState extends State<BarreParameter> {

  @override
  late String parameter;

  @override
  void initState() {
    parameter = widget.parameter;
    super.initState();
  }

  @override  
  Widget build(BuildContext context) {

    increaseParameter() {
      setState(() {
        parameter = '${int.parse(parameter) + widget.valeur}';
        widget.callback(parameter, widget.majKey);
      });
    }
    decreaseParameter() {
      setState(() {
        if(int.parse(parameter) >= widget.valeur) {
          parameter = '${int.parse(parameter) - widget.valeur}';
        } else {
          parameter = '0';
        }
        widget.callback(parameter, widget.majKey);
      });
    }

    return GridView.count(
      crossAxisCount: 3,
      scrollDirection: Axis.vertical,
      childAspectRatio: 3,
      mainAxisSpacing: 0.3,
      crossAxisSpacing: 10,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5.0),
          child : Align(
            alignment: Alignment.bottomLeft,
            child : Text(widget.title),
          )
        ),
        const SizedBox.shrink(),
        const SizedBox.shrink(),
        BoutonParameter(couleur: Colors.grey, texte: '-', valeur: widget.valeur, parametre: widget.parameter, callback: decreaseParameter),
        Container(
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(width: 1.0, color: Colors.blueGrey),
            )
          ),
          child: Align(
            alignment: Alignment.center,
            child: Text(
                widget.parameter,
                textAlign: TextAlign.center,
              ),
          )
        ),
        BoutonParameter(couleur: Colors.lightGreen, texte: '+', valeur: 5, parametre: widget.parameter, callback: increaseParameter),
      ],
    );
  }
}