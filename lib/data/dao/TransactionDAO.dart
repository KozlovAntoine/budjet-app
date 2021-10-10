import 'package:budjet_app/classes/Transaction.dart';
import 'package:budjet_app/convert/DateHelper.dart';

import '../database_bud.dart';
import 'DAO.dart';

class TransactionDAO extends DAO<TransactionBud> {
  final String table = DatabaseBud.transaction;
  @override
  Future<void> delete(TransactionBud t) async {
    final db = await DatabaseBud.instance.database;
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

  Future<List<TransactionBud>> toutesLesTransactionsDunMois(
      DateTime date) async {
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

  Future<List<TransactionBud>> toutesLesTransactionsDunMoisDunCompte(
      DateTime date, int compte) async {
    final db = await DatabaseBud.instance.database;
    final List<Map<String, dynamic>> maps = await db.query(table,
        where:
            "compte = ? AND dateActuel BETWEEN date('${date.toString()}','start of month') AND date('${date.toString()}','start of month','+1 month')",
        whereArgs: [compte]);
    List<TransactionBud> transactions = [];
    TransactionBud tmp;
    for (var element in maps) {
      tmp = await TransactionBud.fromDAO(element);
      transactions.add(tmp);
    }
    return transactions;
  }

  Future<List<TransactionBud>> toutesLesTransactionsDunCompteJusquaAujourdhui(
      int compte) async {
    final db = await DatabaseBud.instance.database;
    final List<Map<String, dynamic>> maps = await db.query(table,
        where: "compte = ? AND dateActuel < date('now','+1 day')",
        whereArgs: [compte]);
    List<TransactionBud> transactions = [];
    TransactionBud tmp;
    for (var element in maps) {
      tmp = await TransactionBud.fromDAO(element);
      transactions.add(tmp);
    }
    return transactions;
  }

  Future<List<TransactionBud>> toutesLesTransactionsDuneCategorie(
      int id) async {
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

  Future<List<TransactionBud>> toutesLesTransactionsDuneCategorieDunMois(
      DateTime date, int categorie) async {
    final db = await DatabaseBud.instance.database;
    final List<Map<String, dynamic>> maps = await db.query(table,
        where:
            "categorie = ? AND dateActuel BETWEEN date('${date.toString()}','start of month') AND date('${date.toString()}','start of month','+1 month')",
        whereArgs: [categorie]);
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

  Future<void> insertAll(TransactionBud t) async {
    DateTime tmp =
        DateTime(t.dateInitial.year, t.dateInitial.month, t.dateInitial.day);
    while (!tmp.isAfter(t.dateFin)) {
      TransactionBud tmpTransac = TransactionBud(
          categorie: t.categorie,
          compte: t.compte,
          montant: t.montant,
          nom: t.nom,
          type: t.type,
          id: t.id,
          dateInitial: t.dateInitial,
          dateFin: t.dateFin,
          dateActuel: tmp);
      await insert(tmpTransac);
      //on ajoute un mois
      tmp = DateHelper.ajoutMois(tmp);
    }
  }
}
