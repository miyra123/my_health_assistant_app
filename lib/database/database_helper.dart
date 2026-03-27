import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {

  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {

    if (_database != null) return _database!;

    _database = await _initDB('users.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {

    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 2,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {

    await db.execute('''
  CREATE TABLE users(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    username TEXT,
    password TEXT
  )
  ''');

    await db.execute('''
  CREATE TABLE medications(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT,
    dose TEXT,
    time TEXT
  )
  ''');

    await db.execute('''
CREATE TABLE records (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  title TEXT,
  date TEXT
)
''');

  }

  Future<int> insertRecord(Map<String, dynamic> record) async {
    final db = await database;
    return await db.insert('records', record);
  }

  Future<List<Map<String, dynamic>>> getRecords() async {
    final db = await database;
    return await db.query('records', orderBy: "id DESC");
  }

  Future<int> insertUser(String username, String password) async {

    final db = await instance.database;

    return await db.insert('users', {
      'username': username,
      'password': password,
    });
  }

  Future<int> deleteRecord(int id) async {
    final db = await database;

    return await db.delete(
      'records',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<Map<String, dynamic>?> loginUser(String username, String password) async {

    final db = await instance.database;

    final result = await db.query(
      'users',
      where: 'username = ? AND password = ?',
      whereArgs: [username, password],
    );

    if (result.isNotEmpty) {
      return result.first;
    }

    return null;
  }
  Future<int> insertMedication(Map<String, dynamic> medication) async {
    final db = await instance.database;
    return await db.insert('medications', medication);
  }

  Future<List<Map<String, dynamic>>> getMedications() async {
    final db = await instance.database;
    return await db.query('medications');
  }

  Future<int> deleteMedication(int id) async {
    final db = await instance.database;
    return await db.delete(
      'medications',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}