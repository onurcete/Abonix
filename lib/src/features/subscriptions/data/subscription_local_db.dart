import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

class SubscriptionLocalDb {
  static const _dbName = 'abonix.db';
  static const _table = 'subscriptions';
  Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    final dbPath = await getDatabasesPath();
    _db = await openDatabase(
      p.join(dbPath, _dbName),
      version: 4,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $_table(
            id TEXT PRIMARY KEY,
            name TEXT NOT NULL,
            price REAL NOT NULL,
            cycle TEXT NOT NULL,
            renewalDate TEXT NOT NULL,
            remindersEnabled INTEGER NOT NULL DEFAULT 0,
            category TEXT,
            currency TEXT NOT NULL DEFAULT 'TRY'
          )
        ''');
        await _createIndexes(db);
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute(
            'ALTER TABLE $_table ADD COLUMN remindersEnabled INTEGER NOT NULL DEFAULT 0',
          );
        }
        if (oldVersion < 3) {
          await _createIndexes(db);
        }
        if (oldVersion < 4) {
          await db.execute(
            "ALTER TABLE $_table ADD COLUMN currency TEXT NOT NULL DEFAULT 'TRY'",
          );
        }
      },
    );
    return _db!;
  }

  Future<List<Map<String, dynamic>>> listRows() async {
    final db = await database;
    return db.query(_table, orderBy: 'renewalDate ASC');
  }

  Future<void> upsert(Map<String, dynamic> row) async {
    final db = await database;
    await db.insert(_table, row, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> deleteById(String id) async {
    final db = await database;
    await db.delete(_table, where: 'id = ?', whereArgs: [id]);
  }

  Future<void> _createIndexes(Database db) async {
    await db.execute('CREATE INDEX IF NOT EXISTS idx_subscriptions_renewalDate ON $_table (renewalDate)');
    await db.execute(
      'CREATE INDEX IF NOT EXISTS idx_subscriptions_remindersEnabled ON $_table (remindersEnabled)',
    );
  }
}
