import 'package:flutter/material.dart';

import 'ToDb.dart';

class Categorie extends ToDb {
  final int? id;
  final String nom;
  final double plafond;
  final Color color;
  final IconData icon;

  Categorie({
    this.id,
    required this.nom,
    required this.plafond,
    required this.color,
    required this.icon,
  });

  @override
  String toString() {
    return 'Categorie(id: $id, nom: $nom, plafond: $plafond, color: $color, icon: ${icon.toString()})';
  }

  static Categorie fromDAO(Map<String, dynamic> map) {
    return Categorie(
        id: map['idcat'],
        nom: map['nom'],
        plafond: map['plafond'],
        color: Color(map['color']),
        icon: IconData(map['icon'], fontFamily: 'MaterialIcons'));
  }

  Map<String, dynamic> toMap() {
    return {
      'idcat': id,
      'nom': nom,
      'plafond': plafond,
      'color': color.value,
      'icon': icon.codePoint,
    };
  }
}
