import 'package:budjet_app/classes/Categorie.dart';

import '../database_bud.dart';
import 'DAO.dart';

class CategorieDAO implements DAO<Categorie> {
  final String table = DatabaseBud.categorie;

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
        await db.query(table, where: 'idcat = ?', whereArgs: [id]);
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
}
