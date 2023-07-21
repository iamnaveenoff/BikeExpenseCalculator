import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../models/expense_model.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._();

  DatabaseHelper._();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('expenses.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE expenses(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        amount REAL NOT NULL,
        date TEXT NOT NULL
      )
    ''');
  }

  Future<int> insertExpense(Expense expense) async {
    try {
      final db = await instance.database;
      return await db.insert('expenses', expense.toMap());
    } catch (e) {
      // Handle the error appropriately (e.g., log it or show an error message)
      rethrow;
    }
  }

  Future<List<Expense>> getExpenses() async {
    try {
      final db = await instance.database;
      const orderBy = 'date DESC';
      final result = await db.query('expenses', orderBy: orderBy);

      return result.map((map) => Expense.fromMap(map)).toList();
    } catch (e) {
      // Handle the error appropriately (e.g., log it or show an error message)
      rethrow;
    }
  }

  Future<void> deleteExpense(int? expenseId) async {
    try {
      final db = await instance.database;
      await db.delete(
        'expenses',
        where: 'id = ?',
        whereArgs: [expenseId],
      );
    } catch (e) {
      // Handle the error appropriately (e.g., log it or show an error message)
      rethrow;
    }
  }

  Future<void> updateExpense(Expense updatedExpense) async {
    try {
      final db = await instance.database;
      await db.update(
        'expenses',
        updatedExpense.toMap(),
        where: 'id = ?',
        whereArgs: [updatedExpense.id],
      );
    } catch (e) {
      // Handle the error appropriately (e.g., log it or show an error message)
      rethrow;
    }
  }
}
