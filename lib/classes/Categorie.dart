import 'package:budjet_app/data/dao/CategorieDAO.dart';
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

  static Categorie fromDAO(CategorieDAO dao) {
    return Categorie(
        nom: dao.nom,
        plafond: dao.plafond,
        color: Color(dao.color),
        icon: IconData(dao.icon, fontFamily: 'MaterialIcons'));
  }
}
