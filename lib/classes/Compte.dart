import 'package:flutter/material.dart';

import 'package:budjet_app/classes/Livret.dart';

class Compte {
  final double solde;
  final String banque;
  final Livret livret;
  final Color color;
  final DateTime lastModification;

  Compte({
    required this.solde,
    required this.livret,
    required this.banque,
    required this.color,
    required this.lastModification,
  });

  @override
  String toString() {
    return 'Compte(solde: $solde, banque: $banque, livret: $livret, color: $color, lastModification: $lastModification)';
  }
}
