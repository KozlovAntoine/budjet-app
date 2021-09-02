import 'package:flutter/material.dart';

class Categorie {
  final String nom;
  final double plafond;
  final Color color;
  final IconData? icon;

  Categorie({
    required this.nom,
    required this.plafond,
    required this.color,
    required this.icon,
  });

  @override
  String toString() {
    return 'Categorie(nom: $nom, plafond: $plafond, color: $color, icon: ${icon.toString()})';
  }
}
