import 'package:flutter/material.dart';

class ConnectionWidget {

  Widget noneBody() => const Center(child: Text("En attente de connexion"));
  Widget waitingBody() => const Center(child: CircularProgressIndicator());
  Widget noData() => const Center(child: Text("Aucune donnée"));

  Scaffold noneScaffold() => Scaffold(body: noneBody());
  Scaffold waitingScaffold() => Scaffold(body: waitingBody());

}