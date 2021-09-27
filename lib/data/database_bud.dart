import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseBud {
  static final String compte = 'BudComptes';
  static final String categorie = 'BudCategories';
  static final String transaction = 'BudTransactions';
  static final String virement = 'BudVirements';
  static final String revenu = 'BudRevenus';
  static final String _colorDb = 'color INTEGER,';
  static final String _creerDb = 'CREATE TABLE ';
  static final String _nomDb = 'nom TEXT,';
  static final String _montantDb = 'montant REAL,';
  static final String _dateDb = 'date TEXT,';
  static final String _dateFinDb = 'dateFin TEXT,';
  static final String _typeDb = 'type INTEGER,';
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
    WidgetsFlutterBinding.ensureInitialized();
    return await openDatabase(
      join(await getDatabasesPath(), 'mydb.db'),
      onConfigure: (db) async {
        await db.execute('PRAGMA foreign_keys = ON');
      },
      onCreate: (db, version) async {
        await db.execute(_creerDb +
            compte +
            '(idcpt INTEGER PRIMARY KEY AUTOINCREMENT, solde REAL,' +
            _nomDb +
            'livret TEXT,' +
            _colorDb +
            'lastModification TEXT)');
        await db.execute(_creerDb +
            categorie +
            '(idcat INTEGER PRIMARY KEY AUTOINCREMENT,' +
            _nomDb +
            'plafond REAL,' +
            _colorDb +
            'icon INTEGER' +
            ')');
        await db.execute(_creerDb +
            transaction +
            '(idt INTEGER PRIMARY KEY AUTOINCREMENT,' +
            _nomDb +
            _montantDb +
            _dateDb +
            _dateFinDb +
            _typeDb +
            'compte INTEGER, categorie INTEGER, ' +
            'FOREIGN KEY (compte) REFERENCES ' +
            compte +
            '(idcpt), ' +
            'FOREIGN KEY (categorie) REFERENCES ' +
            categorie +
            '(idcat) ' +
            ')');
        await db.execute(_creerDb +
            virement +
            '(idv INTEGER PRIMARY KEY AUTOINCREMENT,' +
            'depuis INTEGER, vers INTEGER,' +
            _montantDb +
            _dateDb +
            _dateFinDb +
            _typeDb +
            'FOREIGN KEY (depuis) REFERENCES ' +
            compte +
            '(idcpt),'
                'FOREIGN KEY (vers) REFERENCES ' +
            compte +
            '(idcpt) ' +
            ')');
        await db.execute(_creerDb +
            revenu +
            '(idr INTEGER PRIMARY KEY AUTOINCREMENT,' +
            _nomDb +
            _montantDb +
            _dateDb +
            _dateFinDb +
            _typeDb +
            'compte INTEGER,' +
            'FOREIGN KEY (compte) REFERENCES ' +
            compte +
            '(idcpt) ' +
            ')');
      },
      version: 1,
    );
  }

  Future<Database> get initDone => _database;
}
