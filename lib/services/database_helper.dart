import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../model/rental_transaction_model.dart';
import '../model/user_model.dart';

class DatabaseHelper {
  static Database? _database;
  static const String _userTable = 'users';
  static const String _rentalTransactionTable = 'rental_transactions';

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  DatabaseHelper._privateConstructor();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'elibrary.db');
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''CREATE TABLE $_userTable(
      id TEXT PRIMARY KEY,
      displayName TEXT,
      email TEXT,
      photoUrl TEXT
    )''');

    await db.execute('''CREATE TABLE $_rentalTransactionTable(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      isbn_no TEXT,
      rental_date TEXT,
      expiry_date TEXT,
      amount_paid REAL,
      filename TEXT
    )''');
  }

  Future<int> insertUser(UserModel userModel) async {
    final db = await database;
    return await db.insert(
      _userTable,
      userModel.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> getAllUsers() async {
    final db = await database;
    return await db.query(_userTable);
  }

  Future<Map<String, dynamic>?> getUserById(String id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      _userTable,
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return maps.first;
    } else {
      return null;
    }
  }

  Future<int> updateUser(UserModel userModel, String id) async {
    final db = await database;
    return await db.update(
      _userTable,
      userModel.toMap(),
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteUser(String id) async {
    final db = await database;
    return await db.delete(
      _userTable,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> insertRentalTransaction(Map<String, dynamic> rentalData) async {
    final db = await database;
    return await db.insert(
      _rentalTransactionTable,
      rentalData,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<RentalTransactionModel>> getAllRentalTransactions() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(_rentalTransactionTable);
    return List.generate(maps.length, (i) {
      return RentalTransactionModel.fromMap(maps[i]);
    });
  }

  Future<RentalTransactionModel?> getRentalTransactionById(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      _rentalTransactionTable,
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return RentalTransactionModel.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future<int> updateRentalTransaction(Map<String, dynamic> rentalData, int id) async {
    final db = await database;
    return await db.update(
      _rentalTransactionTable,
      rentalData,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteRentalTransaction(int id) async {
    final db = await database;
    return await db.delete(
      _rentalTransactionTable,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> close() async {
    final db = await database;
    db.close();
  }
}
