import 'Categorie.dart';
import 'Compte.dart';

enum TypeTransaction { IMMEDIAT, DIFFERET, PERMANANT }

class TransactionBud {
  final double? montant;
  final String? nom;
  final Categorie? categorie;
  final DateTime? date;
  final TypeTransaction? type;
  final Compte compte;

  TransactionBud({
    this.montant,
    this.nom,
    this.categorie,
    this.date,
    this.type,
    required this.compte,
  });

  @override
  String toString() {
    return 'Transaction(montant: $montant, nom: $nom, categorie: $categorie, date: $date, type: $type, compte: $compte)';
  }
}
