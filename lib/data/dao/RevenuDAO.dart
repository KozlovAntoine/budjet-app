import 'package:budjet_app/classes/Revenu.dart';
import 'package:budjet_app/data/database_bud.dart';

import 'DAO.dart';

class RevenuDAO extends DAO<Revenu> {
  final String table = DatabaseBud.revenu;
  @override
  Future<void> delete(Revenu t) async {
    final db = await DatabaseBud.instance.database;
    db.delete(table, where: 'idr = ?', whereArgs: [t.id]);
  }

  @override
  Future<List<Revenu>> getAll() async {
    final db = await DatabaseBud.instance.database;
    final List<Map<String, dynamic>> maps = await db.query(table);
    List<Revenu> revenus = [];
    Revenu tmp;
    for (var element in maps) {
      tmp = await Revenu.fromDAO(element);
      revenus.add(tmp);
    }
    return revenus;
  }

  Future<List<Revenu>> getAllFromOneCompte(int id) async {
    final db = await DatabaseBud.instance.database;
    final List<Map<String, dynamic>> maps =
        await db.query(table, where: 'compte = ?', whereArgs: [id]);
    List<Revenu> revenus = [];
    Revenu tmp;
    for (var element in maps) {
      tmp = await Revenu.fromDAO(element);
      revenus.add(tmp);
    }
    return revenus;
  }

  @override
  Future<Revenu> getFromId(int id) async {
    final db = await DatabaseBud.instance.database;
    final List<Map<String, dynamic>> maps =
        await db.query(table, where: 'idr = ?', whereArgs: [id], limit: 1);
    return await Revenu.fromDAO(maps[0]);
  }

  @override
  Future<int> insert(Revenu t) async {
    final db = await DatabaseBud.instance.database;
    return await db.insert(table, t.toMap());
  }

  @override
  Future<void> update(Revenu t) async {
    final db = await DatabaseBud.instance.database;
    db.update(table, t.toMap());
  }
}
