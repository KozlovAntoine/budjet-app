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

  Future<List<Revenu>> getAllFromDate(DateTime date) async {
    final db = await DatabaseBud.instance.database;
    final List<Map<String, dynamic>> maps = await db.query(table,
        where:
            "dateActuel BETWEEN date('${date.toString()}','start of month') AND date('${date.toString()}','start of month','+1 month')");
    List<Revenu> transactions = [];
    Revenu tmp;
    for (var element in maps) {
      tmp = await Revenu.fromDAO(element);
      transactions.add(tmp);
    }
    return transactions;
  }

  Future<List<Revenu>> getAllFromDateCompte(DateTime date, int compte) async {
    final db = await DatabaseBud.instance.database;
    final List<Map<String, dynamic>> maps = await db.query(table,
        where:
            "compte = ? AND dateActuel BETWEEN date('${date.toString()}','start of month') AND date('${date.toString()}','start of month','+1 month')",
        whereArgs: [compte]);
    List<Revenu> transactions = [];
    Revenu tmp;
    for (var element in maps) {
      tmp = await Revenu.fromDAO(element);
      transactions.add(tmp);
    }
    return transactions;
  }

  Future<List<Revenu>> getAllUntilTodayFromAccount(int compte) async {
    final db = await DatabaseBud.instance.database;
    final List<Map<String, dynamic>> maps = await db.query(table,
        where: "compte = ? AND dateActuel < date('now','+1 day')",
        whereArgs: [compte]);
    List<Revenu> transactions = [];
    Revenu tmp;
    for (var element in maps) {
      tmp = await Revenu.fromDAO(element);
      transactions.add(tmp);
    }
    return transactions;
  }
}
