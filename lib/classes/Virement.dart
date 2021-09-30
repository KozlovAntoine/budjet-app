import 'package:budjet_app/classes/ToDb.dart';
import 'package:budjet_app/data/dao/CompteDAO.dart';

import 'Compte.dart';
import 'TypeTransaction.dart';

class Virement extends ToDb {
  final int? id;
  final Compte depuis;
  final Compte vers;
  final double montant;
  final DateTime date;
  final TypeTransaction type;

  Virement({
    this.id,
    required this.depuis,
    required this.vers,
    required this.montant,
    required this.date,
    required this.type,
  });

  static Future<Virement> fromDAO(Map<String, dynamic> map) async {
    Compte dps = await CompteDAO().getFromId(map['depuis']);
    Compte vrs = await CompteDAO().getFromId(map['vers']);
    return Virement(
      id: map['idv'],
      date: DateTime.parse(map['date']),
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
      'date': date.toString(),
      'montant': montant,
    };
  }
}
