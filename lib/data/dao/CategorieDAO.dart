class CategorieDAO {
  final int? idcat;
  final String nom;
  final double plafond;
  final int color;
  final int icon;

  CategorieDAO({
    required this.idcat,
    required this.nom,
    required this.plafond,
    required this.color,
    required this.icon,
  });

  Map<String, dynamic> toMap() {
    return {
      'idcat': idcat,
      'nom': nom,
      'plafond': plafond,
      'color': color,
      'icon': icon,
    };
  }

  Map<String, dynamic> toMapInsert() {
    return {
      'nom': nom,
      'plafond': plafond,
      'color': color,
      'icon': icon,
    };
  }
}
