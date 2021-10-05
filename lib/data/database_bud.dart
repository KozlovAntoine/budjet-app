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
      join(await getDatabasesPath(), 'mydb.db'),
      onConfigure: (db) async {
        await db.execute('PRAGMA foreign_keys = ON');
      },
      onCreate: (db, version) async {
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
      },
      version: 1,
    );
  }

  Future<Database> get initDone => _database;
}
