import 'dart:io';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../model/user_model.dart';

class DatabaseHelper {
  static Database? _db;

  Future<Database> get db async {
    if (_db != null) return _db!;
    _db = await initDb();
    return _db!;
  }

  Future<Database> initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'auth.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE users (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            email TEXT UNIQUE NOT NULL,
            password TEXT NOT NULL
          )
        ''');
      },
    );
  }

  // ✅ Copy DB file into Flutter project's "db" folder
  Future<void> exportDbToProjectFolder() async {
    final dbPath = await getDatabasesPath();
    final dbFile = File(join(dbPath, 'auth.db'));

    // ⚠️ This is relative to your project root
    final projectDbFolder = Directory('db');
    if (!projectDbFolder.existsSync()) {
      projectDbFolder.createSync(recursive: true);
    }

    final newPath = join(projectDbFolder.path, 'auth_copy.db');
    await dbFile.copy(newPath);

    print("📂 Database copied to project folder: $newPath");
  }

  Future<int> insertUser(UserModel user) async {
    final database = await db;
    return await database.insert(
      'users',
      user.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> getAllUsers() async {
    final database = await db;
    return await database.query('users');
  }

  Future<String> getDbPath() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'auth.db');
    return path;
  }

  Future<UserModel?> getUser(String email, String password, String name) async {
    final database = await db;
    final res = await database.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );

    if (res.isNotEmpty) {
      return UserModel.fromMap(res.first);
    }
    return null;
  }
}
