import 'package:budjet_app/classes/ToDb.dart';
import 'package:flutter/material.dart';

import 'package:budjet_app/classes/Livret.dart';

class Compte extends ToDb {
  int? id;
  final double soldeInitial;
  final String banque;
  final Livret livret;
  final Color color;
  final DateTime lastModification;
  int? transactionId;

  Compte({
    this.id,
    this.transactionId,
    required this.soldeInitial,
    required this.livret,
    required this.banque,
    required this.color,
    required this.lastModification,
  });

  @override
  String toString() {
    return 'Compte(id $id, solde: $soldeInitial, banque: $banque, livret: $livret, color: $color, lastModification: $lastModification, transactionId: $transactionId)';
  }

  static Compte fromDAO(Map<String, dynamic> map) {
    return Compte(
        id: map['idcpt'],
        soldeInitial: map['solde'],
        livret: Livret.stringToLivret(map['livret']),
        banque: map['nom'],
        color: Color(map['color']),
        transactionId: map['transactionId'],
        lastModification: DateTime.parse(map['lastModification']));
  }

  Map<String, dynamic> toMap() {
    return {
      'idcpt': id,
      'solde': soldeInitial,
      'nom': banque,
      'livret': livret.name,
      'color': color.value,
      'lastModification': lastModification.toString(),
      'transactionId': transactionId,
    };
  }
}
