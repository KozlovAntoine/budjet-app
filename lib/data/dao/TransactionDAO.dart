import 'package:budjet_app/classes/Transaction.dart';

import '../database_bud.dart';
import 'DAO.dart';

class TransactionDAO extends DAO<TransactionBud> {
  final String table = DatabaseBud.transaction;
  @override
  Future<void> delete(TransactionBud t) async {
    final db = await DatabaseBud.instance.database;
    print('delete from $table, $t');
    await db.delete(table, where: 'idt = ?', whereArgs: [t.id]);
  }

  @override
  Future<List<TransactionBud>> getAll() async {
    final db = await DatabaseBud.instance.database;
    final List<Map<String, dynamic>> maps = await db.query(table);
    List<TransactionBud> transactions = [];
    TransactionBud tmp;
    for (var element in maps) {
      tmp = await TransactionBud.fromDAO(element);
      transactions.add(tmp);
    }
    return transactions;
  }

  Future<List<TransactionBud>> getAllFromDate(DateTime date) async {
    final db = await DatabaseBud.instance.database;
    final List<Map<String, dynamic>> maps = await db.query(table,
        where:
            "dateActuel BETWEEN date('${date.toString()}','start of month') AND date('${date.toString()}','start of month','+1 month')");
    List<TransactionBud> transactions = [];
    TransactionBud tmp;
    for (var element in maps) {
      tmp = await TransactionBud.fromDAO(element);
      transactions.add(tmp);
    }
    return transactions;
  }

  Future<List<TransactionBud>> transactionUnCompteJusquaAujourdhui(
      int idCompte) async {
    final db = await DatabaseBud.instance.database;
    final List<Map<String, dynamic>> maps = await db.query(table,
        where: "compte = ? AND dateActuel <= date('now','+1 day')",
        whereArgs: [idCompte]);
    List<TransactionBud> transactions = [];
    TransactionBud tmp;
    for (var element in maps) {
      tmp = await TransactionBud.fromDAO(element);
      transactions.add(tmp);
    }
    return transactions;
  }

  Future<List<TransactionBud>> getAllFromOneCategorie(int id) async {
    final db = await DatabaseBud.instance.database;
    final List<Map<String, dynamic>> maps =
        await db.query(table, where: 'categorie = ?', whereArgs: [id]);
    List<TransactionBud> transactions = [];
    TransactionBud tmp;
    for (var element in maps) {
      tmp = await TransactionBud.fromDAO(element);
      transactions.add(tmp);
    }
    return transactions;
  }

  @override
  Future<TransactionBud?> getFromId(int id) async {
    final db = await DatabaseBud.instance.database;
    final List<Map<String, dynamic>> maps =
        await db.query(table, where: 'idt = ?', whereArgs: [id], limit: 1);
    if (maps.isEmpty) return null;
    return await TransactionBud.fromDAO(maps[0]);
  }

  @override
  Future<int> insert(TransactionBud t) async {
    final db = await DatabaseBud.instance.database;
    return await db.insert(table, t.toMap());
  }

  @override
  Future<void> update(TransactionBud t) async {
    final db = await DatabaseBud.instance.database;
    db.update(table, t.toMap());
  }
}
