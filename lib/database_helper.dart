import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'main.dart';

class DatabaseHelper {
  static Database? _database;

  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDB();
    return _database!;
  }

  static Future<Database> initDB() async {
    String path = join(await getDatabasesPath(),
        'expense_tracker.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE transactions(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT,
            amount REAL,
            isIncome INTEGER
          )
        ''');
      },
    );
  }

  static Future<int> insertTransaction(
      Transaction t) async {
    final db = await database;
    return db.insert('transactions', {
      'title': t.title,
      'amount': t.amount,
      'isIncome': t.isIncome ? 1 : 0,
    });
  }

  static Future<List<Transaction>>
      getTransactions() async {
    final db = await database;
    final List<Map<String, dynamic>> maps =
        await db.query('transactions');
    return List.generate(maps.length, (i) {
      return Transaction(
        maps[i]['title'],
        maps[i]['amount'],
        maps[i]['isIncome'] == 1,
      );
    });
  }

  static Future<void> deleteTransaction(
      int id) async {
    final db = await database;
    await db.delete(
      'transactions',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}