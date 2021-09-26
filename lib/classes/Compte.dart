import 'package:budjet_app/data/dao/CompteDAO.dart';
import 'package:flutter/material.dart';

import 'package:budjet_app/classes/Livret.dart';

class Compte {
  final int id;
  final double solde;
  final String banque;
  final Livret livret;
  final Color color;
  final DateTime lastModification;

  Compte({
    required this.id,
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

  static Compte fromDAO(CompteDAO dao) {
    return Compte(
        id: dao.idcpt,
        solde: dao.solde,
        livret: Livret.stringToLivret(dao.livret),
        banque: dao.nom,
        color: Color(dao.color),
        lastModification: DateTime.parse(dao.lastModification));
  }
}
