import 'package:budjet_app/classes/Virement.dart';
import 'package:budjet_app/data/database_bud.dart';

import 'DAO.dart';

class VirementDAO extends DAO<Virement> {
  String table = DatabaseBud.virement;
  @override
  Future<void> delete(Virement t) async {
    final db = await DatabaseBud.instance.database;
    db.delete(table, where: 'idv = ?', whereArgs: [t.id]);
  }

  @override
  Future<List<Virement>> getAll() async {
    final db = await DatabaseBud.instance.database;
    final List<Map<String, dynamic>> maps = await db.query(table);
    List<Virement> virements = [];
    Virement tmp;
    for (var element in maps) {
      tmp = await Virement.fromDAO(element);
      virements.add(tmp);
    }
    return virements;
  }

  Future<List<Virement>> getAllFromOneCompteDepuis(int id) async {
    final db = await DatabaseBud.instance.database;
    final List<Map<String, dynamic>> maps =
        await db.query(table, where: 'depuis = ?', whereArgs: [id]);
    List<Virement> virements = [];
    Virement tmp;
    for (var element in maps) {
      tmp = await Virement.fromDAO(element);
      virements.add(tmp);
    }
    return virements;
  }

  Future<List<Virement>> getAllFromOneCompteVers(int id) async {
    final db = await DatabaseBud.instance.database;
    final List<Map<String, dynamic>> maps =
        await db.query(table, where: 'vers = ?', whereArgs: [id]);
    List<Virement> virements = [];
    Virement tmp;
    for (var element in maps) {
      tmp = await Virement.fromDAO(element);
      virements.add(tmp);
    }
    return virements;
  }

  @override
  Future<Virement> getFromId(int id) async {
    final db = await DatabaseBud.instance.database;
    final List<Map<String, dynamic>> maps =
        await db.query(table, where: 'idv = ?', whereArgs: [id], limit: 1);
    return await Virement.fromDAO(maps[0]);
  }

  @override
  Future<int> insert(Virement t) async {
    final db = await DatabaseBud.instance.database;
    return await db.insert(table, t.toMap());
  }

  @override
  Future<void> update(Virement t) async {
    final db = await DatabaseBud.instance.database;
    db.update(table, t.toMap());
  }
}
