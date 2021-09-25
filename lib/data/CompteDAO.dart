class CompteDAO {
  final int idcpt;
  final double solde;
  final String nom;
  final String livret;
  final int color;
  final String lastModification;

  CompteDAO(
      {required this.idcpt,
      required this.solde,
      required this.nom,
      required this.livret,
      required this.color,
      required this.lastModification});

  Map<String, dynamic> toMap() {
    return {
      'idcpt': idcpt,
      'solde': solde,
      'nom': nom,
      'livret': livret,
      'color': color,
      'lastModification': lastModification
    };
  }

  Map<String, dynamic> toMapInsert() {
    return {
      'solde': solde,
      'nom': nom,
      'livret': livret,
      'color': color,
      'lastModification': lastModification
    };
  }
}
