import 'package:budjet_app/classes/Compte.dart';
import 'package:budjet_app/data/dao/DAO.dart';
import 'package:budjet_app/data/database_bud.dart';

class CompteDAO extends DAO<Compte> {
  final String table = DatabaseBud.compte;
  @override
  Future<List<Compte>> getAll() async {
    final db = await DatabaseBud.instance.database;
    final List<Map<String, dynamic>> maps = await db.query(table);
    return List.generate(maps.length, (i) {
      return Compte.fromDAO(maps[i]);
    });
  }

  @override
  Future<Compte> getFromId(int id) async {
    final db = await DatabaseBud.instance.database;
    final List<Map<String, dynamic>> maps =
        await db.query(table, where: 'idcpt = ?', whereArgs: [id], limit: 1);
    return Compte.fromDAO(maps[0]);
  }

  @override
  Future<int> insert(Compte compte) async {
    final db = await DatabaseBud.instance.database;
    return await db.insert(table, compte.toMap());
  }

  @override
  Future<void> update(Compte compte) async {
    final db = await DatabaseBud.instance.database;
    db.update(table, compte.toMap());
  }

  @override
  Future<void> delete(Compte compte) async {
    final db = await DatabaseBud.instance.database;
    db.delete(table, where: 'idcpt = ?', whereArgs: [compte.id]);
  }
}
