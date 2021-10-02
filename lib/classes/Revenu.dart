import 'package:budjet_app/classes/ToDb.dart';
import 'package:budjet_app/data/dao/CompteDAO.dart';
import 'package:flutter/material.dart';

import 'Compte.dart';
import 'TypeTransaction.dart';

class Revenu extends ToDb {
  final int? id;
  final String nom;
  final double montant;
  final DateTime dateInitial;
  final DateTime dateActuel;
  final DateTime dateFin;
  final TypeTransaction type;
  final Color color;
  final Compte compte;

  Revenu({
    this.id,
    required this.nom,
    required this.montant,
    required this.dateInitial,
    required this.dateActuel,
    required this.dateFin,
    required this.type,
    required this.compte,
    required this.color,
  });

  static Future<Revenu> fromDAO(Map<String, dynamic> map) async {
    Compte cpt = await CompteDAO().getFromId(map['compte']);
    return Revenu(
        id: map['idr'],
        nom: map['nom'],
        montant: map['montant'],
        dateInitial: DateTime.parse(map['dateInitial']),
        dateActuel: DateTime.parse(map['dateActuel']),
        dateFin: DateTime.parse(map['dateFin']),
        type: TypeTransaction.values[map['type']],
        color: Color(map['color']),
        compte: cpt);
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'idr': id,
      'nom': nom,
      'montant': montant,
      'dateInitial': dateInitial.toString(),
      'dateActuel': dateActuel.toString(),
      'dateFin': dateFin.toString(),
      'type': type.index,
      'compte': compte.id,
      'color': color.value,
    };
  }

  @override
  String toString() {
    return 'Revenu(id: $id, nom: $nom, montant: $montant, date: $dateActuel, dateInitial: $dateInitial, datefin: $dateFin, type: $type, compte: $compte)';
  }
}
