import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper{
  static final DatabaseHelper _instance = DatabaseHelper.internal();
  static Database? _database;
  static String? url = dotenv.env['API_URL'];
  factory DatabaseHelper() => _instance;
  DatabaseHelper.internal();
  Future<Database?> get db async{
    if(_database != null){
      return _database;
    }
    _database = await initDb();
    return _database;
  }
  initDb() async{
    String databasesPath = await getDatabasesPath();
    String path = databasesPath + 'futbol.db';
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }
  void _onCreate(Database db, int newVersion) async{
    await db.execute('''
      CREATE TABLE user(
        id INTEGER PRIMARY KEY,
        user_id INTEGER,
        name TEXT,
        email TEXT,
        token TEXT,
        url TEXT
      )
    ''');
  }
}