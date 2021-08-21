import 'Compte.dart';

class Virement {
  final Compte depuis;
  final Compte vers;
  final double montant;
  final DateTime date;

  Virement({
    required this.depuis,
    required this.vers,
    required this.montant,
    required this.date,
  });
}
