import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DatabaseService {
  static Database? _db;
  static final DatabaseService instance = DatabaseService._();
  DatabaseService._();

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDB();
    return _db!;
  }

  Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), "expense.db");
    return await openDatabase(
      path,
      version: 4,
      onCreate: (db, version) async {
        await db.execute(''' 
        CREATE TABLE expenses( 
          id INTEGER PRIMARY KEY AUTOINCREMENT, 
          amount REAL, 
          title TEXT NOT NULL, 
          category TEXT NOT NULL, 
          date TEXT NOT NULL 
        ) 
        ''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 4) {
          await db.execute('DROP TABLE IF EXISTS expenses');
          await db.execute(''' 
          CREATE TABLE expenses( 
            id INTEGER PRIMARY KEY AUTOINCREMENT, 
            amount REAL, 
            title TEXT NOT NULL, 
            category TEXT NOT NULL, 
            date TEXT NOT NULL 
          ) 
          ''');
        }
      },
    );
  }

  Future<int> addExpense(
    double amount,
    String title,
    String category,
    String date,
  ) async {
    final db = await database;
    return await db.insert("expenses", {
      "title": title,
      "amount": amount,
      "category": category,
      "date": date,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Map<String, dynamic>>> getExpenses() async {
    final db = await database;
    return await db.query("expenses", orderBy: "id DESC");
  }

  Future<double> getTotal() async {
    final db = await database;
    final result = await db.rawQuery(
      "SELECT SUM(amount) as total FROM expenses",
    );
    return (result.first["total"] as num?)?.toDouble() ?? 0.0;
  }

  Future<List<Map<String, dynamic>>> getCategoryTotals() async {
    final db = await database;
    return await db.rawQuery(''' 
      SELECT category, SUM(amount) as total FROM expenses GROUP BY category 
    ''');
  }

  Future<int> updateExpense(
    int id,
    double amount,
    String title,
    String category,
    String date,
  ) async {
    final db = await database;
    return await db.update(
      "expenses",
      {"title": title, "amount": amount, "category": category, "date": date},
      where: "id = ?",
      whereArgs: [id],
    );
  }

  Future<int> deleteExpense(int id) async {
    final db = await database;
    return await db.delete("expenses", where: "id = ?", whereArgs: [id]);
  }

  Future<double> getMonthlyBudget() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble('monthlyBudget') ?? 0.0;
  }

  Future<void> setMonthlyBudget(double val) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('monthlyBudget', val);
  }
}
