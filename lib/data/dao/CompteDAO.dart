import 'package:budjet_app/classes/Compte.dart';
import 'package:budjet_app/data/dao/DAO.dart';
import 'package:budjet_app/data/database_bud.dart';

class CompteDAO extends DAO<Compte> {
  final String table = DatabaseBud.compte;
  final String tableTransaction = DatabaseBud.transaction;
  final String tableRevenu = DatabaseBud.revenu;
  final String tableVirement = DatabaseBud.virement;

  @override
  Future<List<Compte>> getAll() async {
    final db = await DatabaseBud.instance.database;
    final List<Map<String, dynamic>> maps = await db.query(table);
    List<Compte> comptes = [];
    for (var m in maps) {
      Compte c = Compte.fromDAO(m, await getSolde(m['idcpt']));
      comptes.add(c);
    }
    return comptes;
  }

  Future<double> getSolde(int compteId) async {
    final db = await DatabaseBud.instance.database;
    double montantTotal = 0;
    await db.query(tableTransaction,
        columns: ['montant'],
        where: "compte = ? AND dateActuel <= date('now','+1 day')",
        whereArgs: [compteId])
      ..forEach((element) {
        print('$element');
        montantTotal -= element['montant'] as num;
      });
    await db.query(tableVirement,
        columns: ['montant'],
        where: "depuis = ? AND dateActuel <= date('now','+1 day')",
        whereArgs: [compteId])
      ..forEach((element) {
        print('$element');
        montantTotal -= element['montant'] as num;
      });
    await db.query(tableVirement,
        columns: ['montant'],
        where: "vers = ? AND dateActuel <= date('now','+1 day')",
        whereArgs: [compteId])
      ..forEach((element) {
        print('$element');
        montantTotal += element['montant'] as num;
      });
    await db.query(tableRevenu,
        columns: ['montant'],
        where: "compte = ? AND dateActuel <= date('now','+1 day')",
        whereArgs: [compteId])
      ..forEach((element) {
        print('$element');
        montantTotal += element['montant'] as num;
      });
    print('montant $montantTotal');
    return montantTotal;
  }

  @override
  Future<Compte> getFromId(int id) async {
    final db = await DatabaseBud.instance.database;
    final List<Map<String, dynamic>> maps =
        await db.query(table, where: 'idcpt = ?', whereArgs: [id], limit: 1);
    return Compte.fromDAO(maps[0], await getSolde(id));
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