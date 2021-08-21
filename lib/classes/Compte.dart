import 'package:flutter/material.dart';

class Compte {
  final double solde;
  final String nom;
  final String banque;
  final double plafond;
  final double decouvretAutorise;
  final double interet;
  final Color color;

  Compte({
    required this.solde,
    required this.nom,
    required this.banque,
    required this.plafond,
    required this.decouvretAutorise,
    required this.interet,
    required this.color,
  });
}
