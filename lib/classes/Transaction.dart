import 'package:budjet_app/classes/ToDb.dart';
import 'package:budjet_app/data/dao/CategorieDAO.dart';
import 'package:budjet_app/data/dao/CompteDAO.dart';
import 'package:budjet_app/data/database_bud.dart';

import 'Categorie.dart';
import 'Compte.dart';

enum TypeTransaction { IMMEDIAT, DIFFERET, PERMANANT }

class TransactionBud extends ToDb {
  final int? id;
  final double montant;
  final String nom;
  final DateTime date;
  final DateTime dateFin;
  final TypeTransaction type;
  final Compte compte;
  final Categorie categorie;

  TransactionBud({
    this.id,
    required this.montant,
    required this.nom,
    required this.categorie,
    required this.date,
    required this.dateFin,
    required this.type,
    required this.compte,
  });

  @override
  String toString() {
    return 'Transaction(montant: $montant, nom: $nom, categorie: $categorie, date: $date, type: $type, compte: $compte)';
  }

  static Future<TransactionBud> fromDAO(Map<String, dynamic> map) async {
    Compte cpt = await CompteDAO().getFromId(map['compte']);
    Categorie cat = await CategorieDAO().getFromId(map['categorie']);
    return TransactionBud(
      compte: cpt,
      categorie: cat,
      date: DateTime.parse(map['date']),
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
      'date': date.toString(),
      'dateFin': dateFin.toString(),
      'type': type.index,
      'compte': compte.id,
      'categorie': categorie.id,
    };
  }
}
