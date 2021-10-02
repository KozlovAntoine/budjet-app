import 'package:budjet_app/classes/ToDb.dart';
import 'package:budjet_app/data/dao/CompteDAO.dart';

import 'Compte.dart';
import 'TypeTransaction.dart';

class Virement extends ToDb {
  final int? id;
  final Compte depuis;
  final Compte vers;
  final double montant;
  final DateTime dateActuel;
  final DateTime dateInitial;
  final DateTime dateFin;
  final TypeTransaction type;

  Virement({
    this.id,
    required this.depuis,
    required this.vers,
    required this.montant,
    required this.dateActuel,
    required this.dateInitial,
    required this.dateFin,
    required this.type,
  });

  static Future<Virement> fromDAO(Map<String, dynamic> map) async {
    Compte dps = await CompteDAO().getFromId(map['depuis']);
    Compte vrs = await CompteDAO().getFromId(map['vers']);
    return Virement(
      id: map['idv'],
      dateActuel: DateTime.parse(map['dateActuel']),
      dateInitial: DateTime.parse(map['dateInitial']),
      dateFin: DateTime.parse(map['dateFin']),
      depuis: dps,
      vers: vrs,
      montant: map['montant'],
      type: TypeTransaction.values[map['type']],
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'idv': id,
      'type': type.index,
      'depuis': depuis.id,
      'vers': vers.id,
      'dateInitial': dateInitial.toString(),
      'dateActuel': dateActuel.toString(),
      'dateFin': dateFin.toString(),
      'montant': montant,
    };
  }
}
