import 'Compte.dart';
import 'Transaction.dart';

class Virement {
  final Compte depuis;
  final Compte vers;
  final double montant;
  final DateTime date;
  final TypeTransaction type;

  Virement({
    required this.depuis,
    required this.vers,
    required this.montant,
    required this.date,
    required this.type,
  });
}
