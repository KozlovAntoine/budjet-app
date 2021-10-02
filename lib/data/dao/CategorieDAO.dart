import 'package:budjet_app/classes/Categorie.dart';

import '../database_bud.dart';
import 'DAO.dart';

class CategorieDAO implements DAO<Categorie> {
  final String table = DatabaseBud.categorie;
  final String tableTransaction = DatabaseBud.transaction;

  @override
  Future<void> delete(Categorie t) async {
    final db = await DatabaseBud.instance.database;
    db.delete(table, where: 'idcat = ?', whereArgs: [t.id]);
  }

  @override
  Future<List<Categorie>> getAll() async {
    final db = await DatabaseBud.instance.database;
    final List<Map<String, dynamic>> maps = await db.query(table);
    return List.generate(maps.length, (i) {
      return Categorie.fromDAO(maps[i]);
    });
  }

  @override
  Future<Categorie> getFromId(int id) async {
    final db = await DatabaseBud.instance.database;
    final List<Map<String, dynamic>> maps =
        await db.query(table, where: 'idcat = ?', whereArgs: [id], limit: 1);
    return Categorie.fromDAO(maps[0]);
  }

  @override
  Future<int> insert(Categorie t) async {
    final db = await DatabaseBud.instance.database;
    return await db.insert(table, t.toMap());
  }

  @override
  Future<void> update(Categorie t) async {
    final db = await DatabaseBud.instance.database;
    db.update(table, t.toMap());
  }

  Future<double> getPourcentage(Categorie c) async {
    final db = await DatabaseBud.instance.database;
    DateTime date = DateTime.now();
    final List<Map<String, dynamic>> maps = await db.query(tableTransaction,
        columns: ['montant'],
        where:
            "categorie = ? AND dateActuel BETWEEN date('${date.toString()}','start of month') AND date('${date.toString()}','start of month','+1 month')",
        whereArgs: [c.id]);
    double total = 0;
    double max = c.plafond;
    for (var element in maps) {
      total += element['montant'] as num;
    }
    return (total * 100) / max;
  }
}
