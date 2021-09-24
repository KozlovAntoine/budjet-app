import 'package:budjet_app/classes/Compte.dart';
import 'package:budjet_app/data/CompteDAO.dart';
import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseBud {
  final String _compte = 'BudComptes';
  final String _categorie = 'BudCategories';
  final String _transaction = 'BudTransactions';
  final String _virement = 'BudVirements';
  final String _revenu = 'BudRevenus';
  final String _colorDb = 'color INTEGER,';
  final String _creerDb = 'CREATE TABLE ';
  final String _nomDb = 'nom TEXT,';
  final String _montantDb = 'montant REAL,';
  final String _dateDb = 'date TEXT,';
  final String _dateFinDb = 'dateFin TEXT,';
  final String _typeDb = 'type TEXT,';
  late Future<Database> _database;

  DatabaseBud() {
    init();
  }

  init() async {
    WidgetsFlutterBinding.ensureInitialized();
    _database = openDatabase(
      join(await getDatabasesPath(), 'mydb.db'),
      onConfigure: (db) async {
        await db.execute('PRAGMA foreign_keys = ON');
      },
      onCreate: (db, version) async {
        await db.execute(_creerDb +
            _compte +
            '(idcpt INTEGER PRIMARY KEY AUTOINCREMENT, solde REAL,' +
            _nomDb +
            'livret TEXT,' +
            _colorDb +
            'lastModification TEXT)');
        await db.execute(_creerDb +
            _categorie +
            '(idcat INTEGER PRIMARY KEY AUTOINCREMENT,' +
            _nomDb +
            'plafond REAL,' +
            _colorDb +
            'icon INTEGER' +
            ')');
        await db.execute(_creerDb +
            _transaction +
            '(idt INTEGER PRIMARY KEY AUTOINCREMENT,' +
            _nomDb +
            _montantDb +
            _dateDb +
            _dateFinDb +
            _typeDb +
            'compte INTEGER,' +
            'FOREIGN KEY (compte) REFERENCES ' +
            _compte +
            '(idcpt) ' +
            ')');
        await db.execute(_creerDb +
            _virement +
            '(idv INTEGER PRIMARY KEY AUTOINCREMENT,' +
            'cptDepuis INTEGER, cptVers INTEGER,' +
            _montantDb +
            _dateDb +
            _dateFinDb +
            _typeDb +
            'FOREIGN KEY (cptDepuis) REFERENCES ' +
            _compte +
            '(idcpt),'
                'FOREIGN KEY (cptVers) REFERENCES ' +
            _compte +
            '(idcpt) ' +
            ')');
        await db.execute(_creerDb +
            _revenu +
            '(idr INTEGER PRIMARY KEY AUTOINCREMENT,' +
            _nomDb +
            _montantDb +
            _dateDb +
            _dateFinDb +
            _typeDb +
            'compte INTEGER,' +
            'FOREIGN KEY (compte) REFERENCES ' +
            _compte +
            '(idcpt) ' +
            ')');
      },
      version: 1,
    );
  }

  Future<Database> get initDone => _database;

  Future<void> insertCompte(CompteDAO compteDAO) async {
    final db = await _database;
    await db.insert(_compte, compteDAO.toMap());
  }

  Future<List<Compte>> comptes() async {
    final db = await _database;
    final List<Map<String, dynamic>> maps = await db.query(_compte);
    return List.generate(maps.length, (i) {
      return Compte.fromDAO(CompteDAO(
          idcpt: maps[i]['idcpt'],
          solde: maps[i]['solde'],
          nom: maps[i]['nom'],
          livret: maps[i]['livret'],
          color: maps[i]['color'],
          lastModification: maps[i]['lastModification']));
    });
  }
}
