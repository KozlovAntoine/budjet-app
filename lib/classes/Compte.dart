import 'package:budjet_app/classes/ToDb.dart';
import 'package:flutter/material.dart';

import 'package:budjet_app/classes/Livret.dart';

class Compte extends ToDb {
  final int? id;
  final double solde;
  final String banque;
  final Livret livret;
  final Color color;
  final DateTime lastModification;

  Compte({
    this.id,
    required this.solde,
    required this.livret,
    required this.banque,
    required this.color,
    required this.lastModification,
  });

  @override
  String toString() {
    return 'Compte(id $id, solde: $solde, banque: $banque, livret: $livret, color: $color, lastModification: $lastModification)';
  }

  static Compte fromDAO(Map<String, dynamic> map) {
    return Compte(
        id: map['idcpt'],
        solde: map['solde'],
        livret: Livret.stringToLivret(map['livret']),
        banque: map['nom'],
        color: Color(map['color']),
        lastModification: DateTime.parse(map['lastModification']));
  }

  Map<String, dynamic> toMap() {
    return {
      'idcpt': id,
      'solde': solde,
      'nom': banque,
      'livret': livret.name,
      'color': color.value,
      'lastModification': lastModification.toString(),
    };
  }
}
