import 'package:budjet_app/classes/Livret.dart';
import 'package:flutter/material.dart';

class Compte {
  final double solde;
  final String banque;
  final Livret livret;
  final Color color;

  Compte({
    required this.solde,
    required this.livret,
    required this.banque,
    required this.color,
  });
}
