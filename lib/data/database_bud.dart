import 'package:budjet_app/classes/Categorie.dart';
import 'package:budjet_app/classes/Compte.dart';
import 'package:budjet_app/classes/Livret.dart';
import 'package:budjet_app/classes/Revenu.dart';
import 'package:budjet_app/classes/Transaction.dart';
import 'package:budjet_app/classes/TypeTransaction.dart';
import 'package:budjet_app/convert/DateHelper.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseBud {
  static final String _creerDb = 'CREATE TABLE ';

  static final String compte = 'BudComptes';
  static final String categorie = 'BudCategories';
  static final String transaction = 'BudTransactions';
  static final String virement = 'BudVirements';
  static final String revenu = 'BudRevenus';

  static final String _colorDb = 'color INTEGER NOT NULL,';
  static final String _nomDb = 'nom TEXT NOT NULL,';
  static final String _montantDb = 'montant REAL NOT NULL,';
  static final String _dateInitialDb = 'dateInitial TEXT NOT NULL,';
  static final String _dateActuelDb = 'dateActuel TEXT NOT NULL,';
  static final String _dateFinDb = 'dateFin TEXT NOT NULL,';
  static final String _typeDb = 'type INTEGER NOT NULL,';
  static late Future<Database> _database;

  DatabaseBud._privateConstructor();
  static final DatabaseBud instance = DatabaseBud._privateConstructor();

  DatabaseBud() {
    _database = _initDatabase();
  }

  Future<Database> get database async {
    return _database;
  }

  Future<Database> _initDatabase() async {
    return await openDatabase(
      join(await getDatabasesPath(), 'prevision.db'),
      onConfigure: (db) async {
        await db.execute('PRAGMA foreign_keys = ON');
      },
      onCreate: (db, version) async {
        await _createTable(db, version);
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion == 1) {
          //print('upgrade');
          await _createTable(db, newVersion);
          //print('2');
          Compte defaultCompte = Compte(
              soldeActuel: 0,
              soldeInitial: 0,
              livret: Livret.compteCourant(),
              banque: 'Banque',
              color: Colors.red,
              lastModification: DateTime.now());
          //print('3');
          int cpt = await db.insert(compte, defaultCompte.toMap());
          //print('4');
          defaultCompte.id = cpt;
          final List<Map<String, dynamic>> categories =
              await db.query('Categorie');
          //print('5');
          for (var c in categories) {
            Categorie tmp = Categorie(
                nom: c['name'],
                plafond: (c['budgetMax'] as int).toDouble(),
                color: Color(int.parse(c['color'])),
                icon: Icons.circle);
            await db.insert(categorie, tmp.toMap());
          }
          //print('6');
          final List<Map<String, dynamic>> transactions =
              await db.query('UserTransaction');
          //print('7');
          for (var t in transactions) {
            DateTime start = DateTime.parse(t['dateDebut']);
            DateTime end;
            TypeTransaction type;
            if (t['periode'] == 'Occasionnel') {
              end = start;
              type = TypeTransaction.DIFFERE;
            } else {
              type = TypeTransaction.PERMANANT;
              end = t['dateFin'] != null
                  ? DateTime.parse(t['dateFin'])
                  : DateTime(start.year + 50, start.month, start.day);
            }
            if (t['type'] == 'Revenu') {
              Revenu revenu = Revenu(
                  nom: t['name'],
                  montant: t['montant'],
                  dateInitial: start,
                  dateActuel: start,
                  dateFin: end,
                  type: type,
                  compte: defaultCompte,
                  color: Colors.blue);
              //print('7.2');
              //print('8');
              await insertAllRevenu(db, revenu);
              //print('9');
            } else {
              //print('7.3');
              final List<Map<String, dynamic>> maps = await db.query(categorie,
                  where: 'nom = ?', whereArgs: [t['categorie']], limit: 1);

              Categorie tmp = Categorie.fromDAO(maps[0]);
              //print('7.4 $tmp');
              TransactionBud transactionBud = TransactionBud(
                  montant: t['montant'],
                  nom: t['name'],
                  categorie: tmp,
                  dateInitial: start,
                  dateActuel: start,
                  dateFin: end,
                  type: type,
                  compte: defaultCompte);
              //print('8.2');
              await insertAllTransaction(db, transactionBud);
              //print('9.2');
            }
            //print('10');
          }
        }
      },
      version: 2,
    );
  }

  Future<void> _createTable(Database db, int version) async {
    if (version == 1) {
      //print('version 1');
      await db.execute(
          "CREATE TABLE IF NOT EXISTS Categorie(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, color TEXT NOT NULL, budgetMax INTEGER NOT NULL)");
      await db.execute(
          "CREATE TABLE IF NOT EXISTS Compte(id INTEGER PRIMARY KEY AUTOINCREMENT, type TEXT NOT NULL, montant REAL NOT NULL, plafond REAL, interet REAL)");
      await db.execute(
          "CREATE TABLE IF NOT EXISTS UserTransaction(id INTEGER PRIMARY KEY AUTOINCREMENT, type TEXT NOT NULL, name TEXT NOT NULL, montant REAL NOT NULL, categorie TEXT, dateDebut TEXT NOT NULL, dateFin TEXT, periode TEXT NOT NULL)");

      await db.insert('Categorie', {
        'id': 1,
        'name': 'Abc',
        'color': Colors.blue.value.toString(),
        'budgetMax': 100
      });
      await db.insert('Categorie', {
        'id': 2,
        'name': 'Voyage',
        'color': Colors.orange.value.toString(),
        'budgetMax': 500
      });
      await db.insert('Categorie', {
        'id': 3,
        'name': 'Assurance',
        'color': Colors.green.value.toString(),
        'budgetMax': 100
      });
      //print(await db.query('Categorie'));
      await db.insert('UserTransaction', {
        'id': 1,
        'type': 'Depense',
        'name': 'Course',
        'montant': 100,
        'categorie': 'Abc',
        'dateDebut': DateTime.now().toString(),
        'dateFin': DateTime.now().toString(),
        'periode': 'Occasionnel',
      });
      await db.insert('UserTransaction', {
        'id': 2,
        'type': 'Revenu',
        'name': 'Travail',
        'montant': 524,
        'categorie': null,
        'dateDebut': DateTime.now().toString(),
        'dateFin': DateTime.now().toString(),
        'periode': 'Occasionnel',
      });
      await db.insert('UserTransaction', {
        'id': 3,
        'type': 'Depense',
        'name': 'Nice',
        'montant': 250,
        'categorie': 'Voyage',
        'dateDebut': DateTime.now().toString(),
        'dateFin': DateTime.now().toString(),
        'periode': 'Occasionnel',
      });
      await db.insert('UserTransaction', {
        'id': 4,
        'type': 'Depense',
        'name': 'Assurance',
        'montant': 20,
        'categorie': 'Abc',
        'dateDebut': DateTime.now().toString(),
        'dateFin': null,
        'periode': 'Mensuel',
      });
      await db.insert('UserTransaction', {
        'id': 5,
        'type': 'Depense',
        'name': 'Habitation',
        'montant': 20,
        'categorie': 'Assurance',
        'dateDebut': DateTime.now().toString(),
        'dateFin': DateTime(2022, 10, 10).toString(),
        'periode': 'Mensuel',
      });
      //print('Ajouter:');
    } else if (version == 2) {
      await db.execute(
          '$_creerDb $compte(idcpt INTEGER PRIMARY KEY AUTOINCREMENT, solde REAL, $_nomDb livret TEXT NOT NULL, $_colorDb lastModification TEXT NOT NULL)');
      await db.execute(
          '$_creerDb $categorie(idcat INTEGER PRIMARY KEY AUTOINCREMENT, $_nomDb plafond REAL NOT NULL, $_colorDb icon INTEGER NOT NULL)');
      await db.execute(
          '$_creerDb $transaction(idt INTEGER PRIMARY KEY AUTOINCREMENT,$_nomDb $_montantDb $_dateInitialDb $_dateActuelDb $_dateFinDb $_typeDb compte INTEGER NOT NULL, categorie INTEGER NOT NULL, FOREIGN KEY (compte) REFERENCES $compte(idcpt) ON DELETE CASCADE, FOREIGN KEY (categorie) REFERENCES $categorie(idcat) ON DELETE CASCADE)');
      await db.execute(
          '$_creerDb $virement(idv INTEGER PRIMARY KEY AUTOINCREMENT, depuis INTEGER NOT NULL, vers INTEGER NOT NULL, $_montantDb $_dateInitialDb $_dateActuelDb $_dateFinDb  $_typeDb FOREIGN KEY (depuis) REFERENCES $compte(idcpt) ON DELETE CASCADE, FOREIGN KEY (vers) REFERENCES $compte(idcpt) ON DELETE CASCADE)');
      await db.execute(
          '$_creerDb $revenu(idr INTEGER PRIMARY KEY AUTOINCREMENT, $_nomDb $_montantDb $_dateInitialDb $_dateActuelDb $_dateFinDb $_typeDb $_colorDb compte INTEGER NOT NULL, FOREIGN KEY (compte) REFERENCES $compte(idcpt) ON DELETE CASCADE)');
      //print('create version 2');
    }
  }

  Future<void> insertAllTransaction(Database db, TransactionBud t) async {
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
      await db.insert(transaction, tmpTransac.toMap());
      //on ajoute un mois
      tmp = DateHelper.ajoutMois(tmp);
    }
  }

  Future<void> insertAllRevenu(Database db, Revenu t) async {
    DateTime tmp =
        DateTime(t.dateInitial.year, t.dateInitial.month, t.dateInitial.day);
    while (!tmp.isAfter(t.dateFin)) {
      Revenu r = Revenu(
          color: t.color,
          compte: t.compte,
          montant: t.montant,
          nom: t.nom,
          type: t.type,
          id: t.id,
          dateInitial: t.dateInitial,
          dateFin: t.dateFin,
          dateActuel: tmp);
      await db.insert(revenu, r.toMap());
      //on ajoute un mois
      tmp = DateHelper.ajoutMois(tmp);
    }
  }

  Future<Database> get initDone => _database;
}
