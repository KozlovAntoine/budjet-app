import 'dart:math';

import 'package:budjet_app/classes/ToDb.dart';
import 'package:budjet_app/data/dao/CategorieDAO.dart';
import 'package:budjet_app/data/dao/CompteDAO.dart';

import 'Categorie.dart';
import 'Compte.dart';
import 'TypeTransaction.dart';

class TransactionBud extends ToDb {
  final int? id;
  final double montant;
  final String nom;
  final DateTime dateInitial;
  final DateTime dateActuel;
  final DateTime dateFin;
  final TypeTransaction type;
  final Compte compte;
  final Categorie categorie;

  TransactionBud({
    this.id,
    required this.montant,
    required this.nom,
    required this.categorie,
    required this.dateInitial,
    required this.dateActuel,
    required this.dateFin,
    required this.type,
    required this.compte,
  });

  @override
  String toString() {
    return 'Transaction(id: $id, montant: $montant, nom: $nom, categorie: $categorie, date: $dateActuel, dateInitial: $dateInitial, datefin: $dateFin, type: $type, compte: $compte)';
  }

  static Future<TransactionBud> fromDAO(Map<String, dynamic> map) async {
    print('TransactionBud from DAO : $map');
    Compte cpt = await CompteDAO().getFromId(map['compte']);
    Categorie cat = await CategorieDAO().getFromId(map['categorie']);
    return TransactionBud(
      id: map['idt'],
      compte: cpt,
      categorie: cat,
      dateInitial: DateTime.parse(map['dateInitial']),
      dateActuel: DateTime.parse(map['dateActuel']),
      dateFin: DateTime.parse(map['dateFin']),
      montant: map['montant'],
      nom: map['nom'],
      type: TypeTransaction.values[map['type']],
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'idt': id,
      'nom': nom,
      'montant': montant,
      'dateInitial': dateInitial.toString(),
      'dateActuel': dateActuel.toString(),
      'dateFin': dateFin.toString(),
      'type': type.index,
      'compte': compte.id,
      'categorie': categorie.id,
    };
  }

  static void montantCroissant(List<TransactionBud> list) {
    list.sort((a, b) => max(a.montant.toInt(), b.montant.toInt()));
  }

  static void montantDecroissant(List<TransactionBud> list) {
    list.sort((a, b) => min(a.montant.toInt(), b.montant.toInt()));
  }

  static void dateCroissant(List<TransactionBud> list) {
    list.sort((a, b) => a.dateActuel.isBefore(b.dateActuel) ? -1 : 1);
  }

  static void dateDecroissant(List<TransactionBud> list) {
    list.sort((a, b) => a.dateActuel.isBefore(b.dateActuel) ? 1 : -1);
  }
}
