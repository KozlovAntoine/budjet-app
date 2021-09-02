import 'Categorie.dart';
import 'Compte.dart';

enum TypeTransaction { IMMEDIAT, DIFFERET, PERMANANT }

class Transaction {
  final double montant;
  final String nom;
  final Categorie categorie;
  final DateTime date;
  final TypeTransaction type;
  final Compte compte;

  Transaction({
    required this.montant,
    required this.nom,
    required this.categorie,
    required this.date,
    required this.type,
    required this.compte,
  });
}
