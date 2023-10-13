import 'package:flutter/material.dart';
import 'package:jouons_a_pong/pages/page_principale.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Jeu de Pong',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Jeu de Pong"),
        ),
        body: const SafeArea(
          child: PagePrincipale(),
        ),
      ),
    );
  }
}