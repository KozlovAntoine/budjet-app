import 'package:budjet_app/classes/Transaction.dart';

import '../database_bud.dart';
import 'DAO.dart';

class TransactionDAO extends DAO<TransactionBud> {
  final String table = DatabaseBud.transaction;
  @override
  Future<void> delete(TransactionBud t) async {
    final db = await DatabaseBud.instance.database;
    db.delete(table, where: 'idt = ?', whereArgs: [t.id]);
  }

  @override
  Future<List<TransactionBud>> getAll() async {
    final db = await DatabaseBud.instance.database;
    final List<Map<String, dynamic>> maps = await db.query(table);
    List<TransactionBud> transactions = [];
    TransactionBud tmp;
    maps.forEach((element) async {
      tmp = await TransactionBud.fromDAO(element);
      transactions.add(tmp);
    });
    return transactions;
  }

  @override
  Future<TransactionBud> getFromId(int id) async {
    final db = await DatabaseBud.instance.database;
    final List<Map<String, dynamic>> maps = await db.query(table);
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
